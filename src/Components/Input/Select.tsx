import React, { Component, ReactComponent } from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import {
    CleanThemeContext,
    OverlayContext,
} from "../../Contexts";
import { ColorHelper, TypographyHelper } from "../../Helpers";
import {
    IntentElementProps,
    ScalableElementProps,
    SpacedElementProps,
} from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Padding } from "../Decorator";
import { FlexItem, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { Button } from "./Button";
import { Icon } from "../Surface";

interface SelectProps
    extends ScalableElementProps,
    SpacedElementProps,
    React.InstanceProps<TextBox> {
    selected?: number;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
}

interface SelectState {
    selected: number;
    open: boolean;
    dropdownSize: UDim2;
    dropdownPosition: UDim2;
}

interface SelectContextValue {
    props: SelectProps;
    selected: number;
    open: boolean;
    dropdownSize: UDim2;
    dropdownPosition: UDim2;
    buttonRef: React.RefObject<ImageButton>;
    setSelected: (selected: number) => void;
    setDropdown: (size: UDim2, position: UDim2) => void;
    toggleOpen: () => void;
}

const SelectContext =
    React.createContext<SelectContextValue | undefined>(
        undefined,
    );

interface SelectOptionProps {
    text?: string;
    children?: React.ReactNode;
    Event?: React.InstanceEvent<ImageButton>;
    index?: number;
    BackgroundColor3?: Color3;
}

function SelectOption(props: SelectOptionProps) {
    const theme = React.useContext(CleanThemeContext);
    const [hover, setHover] = React.useState(false);
    const context = React.useContext(SelectContext);

    assert(
        context !== undefined,
        "Select.Option must be used inside a Select",
    );

    assert(props.index !== undefined, "Select.Option must be a direct child of Select",);

    return (
        <imagebutton
            Event={{
                ...props.Event,

                MouseEnter: (button, x, y) => {
                    setHover(true);

                    props.Event?.MouseEnter?.(button, x, y);
                },

                MouseLeave: (button, x, y) => {
                    setHover(false);

                    props.Event?.MouseLeave?.(button, x, y);
                },
                Activated: () => {
                    context.setSelected(props.index!); context.toggleOpen();
                },

            }}

            Size={new UDim2(1, 0, 0, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={0}
            BackgroundColor3={ColorHelper.getIntentColor(
                theme,
                context.selected === props.index ? "info" : "primary",
                hover || context.selected === props.index ? "hover" : "background",
                theme.components.select.intents,
                props.BackgroundColor3,
            )}
            AutoButtonColor={false}
        >
            <Padding {...props} />
            {props.text !== undefined && <Text text={props.text} />}
            {props.children}
        </imagebutton>

    );
}

function SelectRenderer() {
    const context = React.useContext(SelectContext);
    const theme = React.useContext(CleanThemeContext);
    const overlay = React.useContext(OverlayContext);
    const [contentHeight, setContentHeight] = React.useState(0);

    assert(
        context !== undefined,
        "SelectRenderer must be used inside a Select",
    );

    const typography: TypographyStyle =
        TypographyHelper.getTypography(
            theme,
            context.props.scale,
            theme.components.select.typography,
        );


    const children = React.Children.toArray(
        context.props.children,
    );

    const selectedOption = (
        children[context.selected] ??
        children[0]
    ) as React.ReactElement<SelectOptionProps> | undefined;

    const dropdownHeight = math.min(contentHeight, 200);

    return (
        <imagebutton
            ref={context.buttonRef}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            Event={{
                Activated: () => {
                    const button = context.buttonRef.current;

                    if (button && overlay.overlay) {
                        const buttonPosition =
                            button.AbsolutePosition;

                        const overlayPosition =
                            overlay.overlay.AbsolutePosition;

                        const localPosition =
                            buttonPosition.sub(
                                overlayPosition,
                            );

                        context.setDropdown(
                            UDim2.fromOffset(button.AbsoluteSize.X, button.AbsoluteSize.Y),
                            UDim2.fromOffset(
                                localPosition.X,
                                localPosition.Y,
                            ),
                        );
                    }

                    context.toggleOpen();
                },
            }}
        >
            <uistroke Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Inner} Color={theme.components.select.borderColor} />

            <Corners radius={theme.components.select.cornerRadius} />

            <Padding {...context.props} />
            <HStack>
                <FlexItem>
                    <Text
                        text={selectedOption?.props.text ?? "No Options"}
                        typography={typography}
                    />
                </FlexItem>
                <Icon icon="caret-down" color={theme.colors.intents.primary.text} />
            </HStack>

            {context.open &&
                overlay.overlay !== undefined &&
                ReactRoblox.createPortal(
                    <frame
                        BackgroundTransparency={0}
                        BackgroundColor3={
                            theme.components.select.dropDownBackgroundColor
                        }
                        AnchorPoint={Vector2.zero}
                        Position={context.dropdownPosition.add(new UDim2(0, 0, 0, context.dropdownSize.Y.Offset))}
                        Size={UDim2.fromOffset(context.dropdownSize.X.Offset, 0)}
                        AutomaticSize={Enum.AutomaticSize.Y}
                        ClipsDescendants={true}
                        ZIndex={1000}
                    >
                        <uistroke Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Outer} Color={theme.components.select.borderColor} />

                        <Corners radius={theme.components.select.cornerRadius} />
                        <Scroller Size={new UDim2(1, 0, 0, dropdownHeight)} spacing="None">
                            <Corners radius={theme.components.select.cornerRadius} />
                            <VStack
                                spacing="None"
                                Change={{
                                    AbsoluteContentSize: (layout) => {
                                        setContentHeight(layout.AbsoluteContentSize.Y);
                                    },
                                }}>
                                {React.Children.map(context.props.children, (child, index) => {
                                    if (!React.isValidElement<SelectOptionProps>(child)) {
                                        return child;
                                    }
                                    return React.cloneElement(child, { index: index - 1, });
                                })}
                            </VStack>
                        </Scroller>
                    </frame>,
                    overlay.overlay,
                )}
        </imagebutton>
    );
}

@ReactComponent
class Select extends Component<SelectProps, SelectState> {
    public static Option = SelectOption;

    state: SelectState = {
        selected: this.props.selected ?? 0,
        open: false,
        dropdownSize: UDim2.fromOffset(0, 0),
        dropdownPosition: UDim2.fromOffset(0, 0),
    }

    private buttonRef = React.createRef<ImageButton>();

    public render() {
        const context: SelectContextValue = {
            props: this.props,
            selected: this.state.selected,
            open: this.state.open,
            dropdownSize: this.state.dropdownSize,
            dropdownPosition: this.state.dropdownPosition,
            buttonRef: this.buttonRef,

            setSelected: (selected) => {
                print(selected)
                this.setState({
                    selected,
                });
            },

            setDropdown: (
                size: UDim2, position: UDim2,
            ) => {
                this.setState({
                    dropdownSize: size,
                    dropdownPosition: position,
                });
            },

            toggleOpen: () => {
                this.setState((state) => ({
                    open: !state.open,
                }));
            },
        };

        return (
            <SelectContext.Provider value={context}>
                <SelectRenderer />
            </SelectContext.Provider>
        );
    }
}

export { Select };

