import React from "@rbxts/react";
import { ContainerProps } from "../Layout";
import { CustomInputService } from "../../Helpers";
import { CleanThemeContext } from "../../Contexts";
import { SizeHelper } from "../../Helpers";
import { BoxShadow } from "../Decorator";

type SliderValue = number | Vector2;
type SliderHandleIndex = 0 | 1;

type HighlightOption = "start" | "end" | "middle";

export interface SliderProps extends ContainerProps {
    "max-value": number;
    "min-value"?: number;

    value?: SliderValue;
    step?: number;

    onDragged?: (value: SliderValue) => void;
    onChanged?: (value: SliderValue) => void;

    controlled?: boolean;
    range?: boolean;
    highlight?: HighlightOption;
}

export const Slider = React.forwardRef<Frame, SliderProps>(
    (props, ref) => {
        const theme =
            React.useContext(CleanThemeContext).components.slider;

        const containerRef = React.useRef<Frame>();

        const isDraggingRef = React.useRef(false);

        const activeHandleRef =
            React.useRef<SliderHandleIndex>();

        const getInitialValue = (): SliderValue => {
            const minValue = props["min-value"] ?? 0;
            const maxValue = props["max-value"];

            if (props.range) {
                return typeIs(props.value, "Vector2")
                    ? props.value
                    : new Vector2(minValue, maxValue);
            }

            return typeIs(props.value, "number")
                ? props.value
                : minValue;
        };

        const [value, setValue] = React.useState<SliderValue>(getInitialValue);

        const [dragging, setDragging] = React.useState(false);

        const [hoveredHandle, setHoveredHandle] = React.useState<SliderHandleIndex>();

        const propsRef = React.useRef(props);
        propsRef.current = props;

        const currentValue = React.useMemo((): SliderValue => {
            if (props.controlled) {
                if (props.range) {
                    return typeIs(props.value, "Vector2")
                        ? props.value
                        : new Vector2(props["min-value"] ?? 0, props["max-value"]);
                }

                return typeIs(props.value, "number") ? props.value : props["min-value"] ?? 0;
            }

            return value;
        }, [
            props.controlled,
            props.range,
            props.value,
            props["min-value"],
            props["max-value"],
            value,
        ]);

        const currentValueRef = React.useRef(currentValue);
        currentValueRef.current = currentValue;

        const updateValue = React.useCallback((nextValue: SliderValue) => {
            if (!propsRef.current.controlled) {
                currentValueRef.current = nextValue;
            }

            setValue(nextValue);
        }, []);

        /**
         * Converts an input position into a single slider value.
         */
        const getNumberFromInput = React.useCallback(
            (input: InputObject): number | undefined => {
                const container = containerRef.current;

                if (!container)
                    return undefined;

                const containerWidth = container.AbsoluteSize.X;

                if (containerWidth <= 0)
                    return undefined;

                const inputX = input.Position.X;

                const containerStart = container.AbsolutePosition.X;

                const percentage = math.clamp(
                    (inputX - containerStart) / containerWidth,
                    0,
                    1,
                );

                const currentProps = propsRef.current;

                const minValue = currentProps["min-value"] ?? 0;
                const maxValue = currentProps["max-value"];

                let nextValue = minValue + percentage * (maxValue - minValue);

                const step = currentProps.step;

                if (step !== undefined && step > 0) {
                    /*
                     * Offset snapping from minValue so ranges such as
                     * min=5, step=2 produce 5, 7, 9, etc.
                     */
                    nextValue =
                        minValue +
                        math.round((nextValue - minValue) / step) * step;

                    // Remove floating-point artifacts.
                    const parts = tostring(step).split(".");

                    const decimals = parts.size() > 1 ? parts[1].size() : 0;

                    const scale = 10 ** decimals;

                    nextValue = math.round(nextValue * scale) / scale;
                }

                return math.clamp(nextValue, minValue, maxValue);
            },
            [],
        );

        /**
         * Converts a single input value into either a number or Vector2,
         * depending on whether range mode is enabled.
         */
        const getValueFromInput = React.useCallback(
            (input: InputObject): SliderValue | undefined => {
                const inputValue = getNumberFromInput(input);

                if (inputValue === undefined)
                    return undefined;

                const currentProps = propsRef.current;

                if (!currentProps.range)
                    return inputValue;

                const rangeValue = typeIs(currentValueRef.current, "Vector2")
                    ? currentValueRef.current
                    : new Vector2(
                        currentProps["min-value"] ?? 0,
                        currentProps["max-value"],
                    );

                if (activeHandleRef.current === 0) {
                    return new Vector2(
                        math.min(inputValue, rangeValue.Y),
                        rangeValue.Y,
                    );
                }

                if (activeHandleRef.current === 1) {
                    return new Vector2(
                        rangeValue.X,
                        math.max(inputValue, rangeValue.X),
                    );
                }

                return rangeValue;
            },
            [getNumberFromInput],
        );

        const beginDragging = React.useCallback(
            (handle: SliderHandleIndex, input: InputObject): void => {
                if (
                    input.UserInputType !== Enum.UserInputType.MouseButton1 &&
                    input.UserInputType !== Enum.UserInputType.Touch
                )
                    return;

                activeHandleRef.current = handle;
                isDraggingRef.current = true;

                const nextValue = getValueFromInput(input);

                setDragging(true);

                if (nextValue !== undefined) {
                    updateValue(nextValue);

                    propsRef.current.onDragged?.(nextValue);
                }
            },
            [getValueFromInput, updateValue],
        );

        React.useEffect(() => {
            const inputChangedListener =
                CustomInputService.InputChanged.Connect(
                    (input: InputObject) => {
                        if (
                            input.UserInputType !== Enum.UserInputType.MouseMovement &&
                            input.UserInputType !== Enum.UserInputType.Touch
                        )
                            return;

                        if (!isDraggingRef.current)
                            return;

                        const nextValue = getValueFromInput(input);

                        if (nextValue === undefined)
                            return;

                        updateValue(nextValue);

                        propsRef.current.onDragged?.(nextValue);
                    },
                );

            const inputEndedListener =
                CustomInputService.InputEnded.Connect(
                    (input: InputObject) => {
                        if (
                            input.UserInputType !== Enum.UserInputType.MouseButton1 &&
                            input.UserInputType !== Enum.UserInputType.Touch
                        )
                            return;

                        if (!isDraggingRef.current)
                            return;

                        /*
                         * Stop processing movement immediately, before
                         * React gets around to updating the state.
                         */
                        isDraggingRef.current = false;

                        const nextValue = getValueFromInput(input);

                        activeHandleRef.current = undefined;

                        setDragging(false);
                        setHoveredHandle(undefined);

                        if (nextValue !== undefined) {
                            updateValue(nextValue);

                            propsRef.current.onChanged?.(nextValue);
                        }
                    },
                );

            return () => {
                isDraggingRef.current = false;
                activeHandleRef.current = undefined;

                inputChangedListener.Disconnect();
                inputEndedListener.Disconnect();
            };
        }, [getValueFromInput, updateValue]);

        const height = SizeHelper.toUDim(theme.height);

        const minValue = props["min-value"] ?? 0;
        const maxValue = props["max-value"];

        const valueRange = maxValue - minValue;

        let firstValue: number;
        let secondValue: number | undefined;

        if (props.range && typeIs(currentValue, "Vector2")) {
            firstValue = currentValue.X;
            secondValue = currentValue.Y;
        } else {
            firstValue = typeIs(currentValue, "number")
                ? currentValue
                : currentValue.X;
        }

        const getPosition = (sliderValue: number): number => {
            if (valueRange <= 0)
                return 0;

            return math.clamp(
                (sliderValue - minValue) / valueRange,
                0,
                1,
            );
        };

        const firstPosition = getPosition(firstValue);

        const secondPosition =
            secondValue !== undefined
                ? getPosition(secondValue)
                : undefined;

        const padding = SizeHelper.toUDim(theme.bar.padding);

        const handles: Array<{ index: SliderHandleIndex; position: number; }> = [{
            index: 0,
            position: firstPosition,
        }];

        if (props.range && secondPosition !== undefined) {
            handles.push({
                index: 1,
                position: secondPosition,
            });
        }

        return (
            <frame
                ref={ref}
                Archivable={props.Archivable}
                Tag={props.Tag}
                Active={props.Active}
                AnchorPoint={SizeHelper.GetAnchor(props)}
                BackgroundColor3={props.BackgroundColor3}
                BackgroundTransparency={props.BackgroundTransparency ?? 1}
                BorderColor3={props.BorderColor3}
                BorderMode={props.BorderMode}
                BorderSizePixel={props.BorderSizePixel}
                ClipsDescendants={props.ClipsDescendants}
                Interactable={props.Interactable}
                LayoutOrder={props.LayoutOrder}
                NextSelectionDown={props.NextSelectionDown}
                NextSelectionLeft={props.NextSelectionLeft}
                NextSelectionRight={props.NextSelectionRight}
                NextSelectionUp={props.NextSelectionUp}
                Position={SizeHelper.GetPosition(props)}
                Rotation={props.Rotation}
                Selectable={props.Selectable}
                SelectionGroup={props.SelectionGroup}
                SelectionImageObject={props.SelectionImageObject}
                SelectionOrder={props.SelectionOrder}
                Size={SizeHelper.GetSize(props, new UDim2(new UDim(1, 0), height))}
                SizeConstraint={props.SizeConstraint}
                Visible={props.Visible}
                ZIndex={props.ZIndex}

                AutoLocalize={props.AutoLocalize}
                RootLocalizationTable={props.RootLocalizationTable}

                Style={props.Style}

                Change={props.Change}
                Event={props.Event}
            >
                <frame
                    Size={new UDim2(new UDim(1, 0), SizeHelper.toUDim(theme.bar.height))}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    AnchorPoint={new Vector2(0.5, 0.5)}
                    BackgroundTransparency={theme.bar.backgroundTransparency}
                    BackgroundColor3={theme.bar.backgroundColor}
                >
                    <uistroke
                        Thickness={theme.bar.borderThickness}
                        Color={theme.bar.borderColor}
                    />

                    <uicorner
                        CornerRadius={SizeHelper.toUDim(theme.bar.cornerRadius)}
                    />
                </frame>

                <frame
                    ref={containerRef}
                    Size={UDim2.fromScale(1, 1).sub(new UDim2(padding.add(padding), new UDim(0, 0)))}
                    BackgroundTransparency={1}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    AnchorPoint={new Vector2(0.5, 0.5)}
                >
                    {props.highlight !== undefined && (
                        <frame
                            BackgroundColor3={theme.bar.highlight.backgroundColor}
                            BackgroundTransparency={theme.bar.highlight.backgroundTransparency}
                            Position={
                                props.highlight === "start"
                                    ? UDim2.fromScale(0, 0.5).sub(new UDim2(padding, new UDim(0, 0)))
                                    : props.highlight === "end"
                                        ? UDim2.fromScale(1, 0.5).add(new UDim2(padding, new UDim(0, 0)))
                                        : UDim2.fromScale(firstPosition, 0.5)
                            }
                            AnchorPoint={props.highlight === "end" ? new Vector2(1, 0.5) : new Vector2(0, 0.5)}
                            Size={props.highlight === "start"
                                ? new UDim2(new UDim(firstPosition, 0), SizeHelper.toUDim(theme.bar.height)).add(new UDim2(padding, new UDim(0, 0)))
                                : props.highlight === "end"
                                    ? new UDim2(new UDim(1 - (secondPosition ?? firstPosition), 0), SizeHelper.toUDim(theme.bar.height)).add(new UDim2(padding, new UDim(0, 0)))
                                    : new UDim2(new UDim((secondPosition ?? 0) - firstPosition, 0), SizeHelper.toUDim(theme.bar.height))
                            }
                        >
                            <uistroke
                                Thickness={theme.bar.borderThickness}
                                Color={theme.bar.highlight.borderColor}
                            />

                            <uicorner CornerRadius={SizeHelper.toUDim(theme.bar.cornerRadius)} />
                        </frame>
                    )}

                    {handles.map(({ index, position }) => (
                        <frame
                            key={index}
                            Position={UDim2.fromScale(position, 0.5)}
                            AnchorPoint={new Vector2(0.5, 0.5)}
                            Size={UDim2.fromScale(0, 1)}
                            BackgroundTransparency={theme.handle.backgroundTransparency}
                            BackgroundColor3={theme.handle.backgroundColor}
                            BorderSizePixel={0}
                            Event={{
                                InputBegan: (_instance: Instance, input: InputObject) => {
                                    beginDragging(index, input);
                                },
                                MouseEnter: () => {
                                    setHoveredHandle(index);
                                },
                                MouseLeave: () => {
                                    setHoveredHandle((currentHoveredHandle) =>
                                        currentHoveredHandle === index
                                            ? undefined
                                            : currentHoveredHandle,
                                    );
                                },
                            }}
                        >
                            <uistroke
                                Thickness={theme.handle.borderThickness}
                                Color={theme.handle.borderColor}
                            />

                            <uicorner CornerRadius={SizeHelper.toUDim(theme.handle.cornerRadius)} />

                            {(hoveredHandle === index || (dragging && activeHandleRef.current === index)) && (
                                <BoxShadow box-shadow={theme.handle.boxShadow} />
                            )}

                            <uiaspectratioconstraint
                                AspectRatio={theme.handle.aspectRatio ?? 1}
                                DominantAxis={Enum.DominantAxis.Height}
                                AspectType={
                                    Enum.AspectType.ScaleWithParentSize
                                }
                            />
                        </frame>
                    ))}
                </frame>
            </frame>
        );
    });