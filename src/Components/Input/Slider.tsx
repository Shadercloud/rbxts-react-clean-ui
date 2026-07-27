import React, { Component, ReactComponent } from "@rbxts/react";
import { ContainerProps } from "../Layout";
import {
    CustomInputService,
    DisconnectableSignal,
} from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";
import { SizeHelper } from "../../Helpers";
import { BoxShadow } from "../Decorator";

type SliderValue = number | Vector2;
type SliderHandleIndex = 0 | 1;

type HighlightOption = "start" | "end" | "middle";

interface SliderProps extends ContainerProps {
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

interface SliderState {
    value: SliderValue;
    dragging: boolean;
    hoveredHandle?: SliderHandleIndex;
}

@ReactComponent
export class Slider extends Component<SliderProps, SliderState> {
    private inputChangedListener?: DisconnectableSignal;
    private inputEndedListener?: DisconnectableSignal;

    private isDragging = false;
    private activeHandle?: SliderHandleIndex;

    public containerRef = React.createRef<Frame>();

    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;

    state: SliderState = {
        value: this.getInitialValue(),
        dragging: false,
        hoveredHandle: undefined,
    };

    private getInitialValue(): SliderValue {
        const minValue = this.props["min-value"] ?? 0;
        const maxValue = this.props["max-value"];

        if (this.props.range) {
            return typeIs(this.props.value, "Vector2")
                ? this.props.value
                : new Vector2(minValue, maxValue);
        }

        return typeIs(this.props.value, "number")
            ? this.props.value
            : minValue;
    }

    /**
     * Returns the value currently used to render the slider.
     */
    private getCurrentValue(): SliderValue {
        if (this.props.controlled) {
            const value = this.props.value;

            if (this.props.range) {
                return typeIs(value, "Vector2")
                    ? value
                    : new Vector2(
                        this.props["min-value"] ?? 0,
                        this.props["max-value"],
                    );
            }

            return typeIs(value, "number")
                ? value
                : this.props["min-value"] ?? 0;
        }

        return this.state.value;
    }

    /**
     * Converts an input position into a single slider value.
     */
    private getNumberFromInput(
        input: InputObject,
    ): number | undefined {
        const container = this.containerRef.current;
        if (!container) return;

        const containerWidth = container.AbsoluteSize.X;
        if (containerWidth <= 0) return;

        const inputX = input.Position.X;
        const containerStart = container.AbsolutePosition.X;

        const percentage = math.clamp(
            (inputX - containerStart) / containerWidth,
            0,
            1,
        );

        const minValue = this.props["min-value"] ?? 0;
        const maxValue = this.props["max-value"];

        let value =
            minValue +
            percentage * (maxValue - minValue);

        const step = this.props.step;

        if (step !== undefined && step > 0) {
            /*
             * Offset snapping from minValue so ranges such as
             * min=5, step=2 produce 5, 7, 9, etc.
             */
            value =
                minValue +
                math.round((value - minValue) / step) * step;

            // Remove floating-point artifacts.
            const parts = tostring(step).split(".");
            const decimals =
                parts.size() > 1
                    ? parts[1].size()
                    : 0;

            const scale = 10 ** decimals;

            value =
                math.round(value * scale) /
                scale;
        }

        return math.clamp(
            value,
            minValue,
            maxValue,
        );
    }

    /**
     * Converts a single input value into either a number or Vector2,
     * depending on whether range mode is enabled.
     */
    private getValueFromInput(
        input: InputObject,
    ): SliderValue | undefined {
        const inputValue = this.getNumberFromInput(input);
        if (inputValue === undefined) return;

        if (!this.props.range) {
            return inputValue;
        }

        const currentValue = this.getCurrentValue();

        const rangeValue = typeIs(currentValue, "Vector2")
            ? currentValue
            : new Vector2(
                this.props["min-value"] ?? 0,
                this.props["max-value"],
            );

        if (this.activeHandle === 0) {
            return new Vector2(
                math.min(inputValue, rangeValue.Y),
                rangeValue.Y,
            );
        }

        if (this.activeHandle === 1) {
            return new Vector2(
                rangeValue.X,
                math.max(inputValue, rangeValue.X),
            );
        }

        return rangeValue;
    }

    private beginDragging(
        handle: SliderHandleIndex,
        input: InputObject,
    ): void {
        if (input.UserInputType !== Enum.UserInputType.MouseButton1 &&
            input.UserInputType !== Enum.UserInputType.Touch
        ) return;

        this.activeHandle = handle;
        this.isDragging = true;

        const value = this.getValueFromInput(input);

        this.setState({
            dragging: true,
            value: value ?? this.state.value,
        });

        if (value !== undefined) {
            this.props.onDragged?.(value);
        }
    }

    componentDidMount(): void {
        this.inputChangedListener =
            CustomInputService.InputChanged.Connect(
                (input: InputObject) => {
                    if (input.UserInputType !== Enum.UserInputType.MouseMovement &&
                        input.UserInputType !== Enum.UserInputType.Touch
                    ) return;

                    if (!this.isDragging) return;

                    const value = this.getValueFromInput(input);

                    if (value === undefined) return;

                    this.setState({ value });
                    this.props.onDragged?.(value);
                },
            );

        this.inputEndedListener =
            CustomInputService.InputEnded.Connect(
                (input: InputObject) => {
                    if (input.UserInputType !== Enum.UserInputType.MouseButton1 &&
                        input.UserInputType !== Enum.UserInputType.Touch
                    ) return;

                    if (!this.isDragging) return;

                    /*
                     * Stop processing movement immediately, before
                     * React gets around to updating the state.
                     */
                    this.isDragging = false;

                    const value = this.getValueFromInput(input);

                    this.activeHandle = undefined;

                    this.setState({
                        value: value ?? this.state.value,
                        dragging: false,
                        hoveredHandle: React.None,
                    });

                    if (value !== undefined) this.props.onChanged?.(value);
                },
            );
    }

    componentWillUnmount(): void {
        this.isDragging = false;
        this.activeHandle = undefined;

        this.inputChangedListener?.Disconnect();
        this.inputEndedListener?.Disconnect();
    }

    render(): React.ReactNode {
        const theme = this.context.components.slider;

        const height = SizeHelper.toUDim(
            theme.height,
        );

        const minValue = this.props["min-value"] ?? 0;

        const maxValue = this.props["max-value"];

        const valueRange = maxValue - minValue;

        const currentValue = this.getCurrentValue();

        let firstValue: number;
        let secondValue: number | undefined;

        if (this.props.range && typeIs(currentValue, "Vector2")) {
            firstValue = currentValue.X;
            secondValue = currentValue.Y;
        } else {
            firstValue = typeIs(currentValue, "number") ? currentValue : currentValue.X;
        }

        const getPosition = (value: number) => {
            if (valueRange <= 0) return 0;

            return math.clamp(
                (value - minValue) / valueRange,
                0,
                1,
            );
        };

        const firstPosition =
            getPosition(firstValue);

        const secondPosition =
            secondValue !== undefined
                ? getPosition(secondValue)
                : undefined;

        const padding = SizeHelper.toUDim(
            theme.bar.padding,
        );

        const handles: Array<{
            index: SliderHandleIndex;
            position: number;
        }> = [
                {
                    index: 0,
                    position: firstPosition,
                },
            ];

        if (
            this.props.range &&
            secondPosition !== undefined
        ) {
            handles.push({
                index: 1,
                position: secondPosition,
            });
        }

        return (
            <frame
                Size={new UDim2(new UDim(1, 0), height)}
                BackgroundTransparency={1}
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
                        Color={theme.bar.borderColor} />

                    <uicorner CornerRadius={SizeHelper.toUDim(theme.bar.cornerRadius)} />

                </frame>

                <frame
                    ref={this.containerRef}
                    Size={UDim2.fromScale(1, 1).sub(new UDim2(padding.add(padding), new UDim(0, 0)))}
                    BackgroundTransparency={1}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    AnchorPoint={new Vector2(0.5, 0.5)}
                >
                    {this.props.highlight !== undefined &&
                        <frame
                            BackgroundColor3={theme.bar.highlight.backgroundColor}
                            BackgroundTransparency={theme.bar.highlight.backgroundTransparency}
                            Position={
                                this.props.highlight === "start" ?
                                    UDim2.fromScale(0, 0.5).sub(new UDim2(padding, new UDim(0, 0))) :
                                    this.props.highlight === "end" ?
                                        UDim2.fromScale(1, 0.5).add(new UDim2(padding, new UDim(0, 0))) :
                                        UDim2.fromScale(firstPosition, 0.5)
                            }
                            AnchorPoint={
                                this.props.highlight === "end" ?
                                    new Vector2(1, 0.5) :
                                    new Vector2(0, 0.5)
                            }
                            Size={
                                this.props.highlight === "start" ?
                                    new UDim2(new UDim(firstPosition, 0), SizeHelper.toUDim(theme.bar.height)).add(new UDim2(padding, new UDim(0, 0))) :
                                    this.props.highlight === "end" ?
                                        new UDim2(new UDim(1 - (secondPosition ?? firstPosition), 0), SizeHelper.toUDim(theme.bar.height)).add(new UDim2(padding, new UDim(0, 0))) :
                                        new UDim2(new UDim((secondPosition ?? 0) - firstPosition, 0), SizeHelper.toUDim(theme.bar.height))
                            }
                        >
                            <uistroke
                                Thickness={theme.bar.borderThickness}
                                Color={theme.bar.highlight.borderColor} />
                            <uicorner CornerRadius={SizeHelper.toUDim(theme.bar.cornerRadius)} />
                        </frame>
                    }
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
                                    this.beginDragging(index, input);
                                },
                                MouseEnter: () => {
                                    this.setState({
                                        hoveredHandle: index,
                                    });
                                },

                                MouseLeave: () => {
                                    this.setState((state) => ({
                                        hoveredHandle: state.hoveredHandle === index
                                            ? React.None
                                            : (state.hoveredHandle === undefined ? React.None : state.hoveredHandle),
                                    }));
                                },
                            }}
                        >
                            <uistroke
                                Thickness={theme.handle.borderThickness}
                                Color={theme.handle.borderColor} />

                            <uicorner CornerRadius={SizeHelper.toUDim(theme.handle.cornerRadius)} />

                            {(this.state.hoveredHandle === index || (this.state.dragging && this.activeHandle === index)) && (
                                <BoxShadow box-shadow={theme.handle.boxShadow} />
                            )}

                            <uiaspectratioconstraint
                                AspectRatio={theme.handle.aspectRation ?? 1}
                                DominantAxis={Enum.DominantAxis.Height}
                                AspectType={Enum.AspectType.ScaleWithParentSize}
                            />
                        </frame>
                    )
                    )}
                </frame>
            </frame >
        );
    }
}