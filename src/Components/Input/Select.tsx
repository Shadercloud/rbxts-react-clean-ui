import React, { Component, ReactComponent } from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import {
    CleanThemeContext,
    OverlayContext,
    OverlayContextValue,
} from "../../Contexts";
import { ColorHelper, SizeHelper, TypographyHelper } from "../../Helpers";
import {
    CssSize,
    ScalableElementProps,
    SpacedElementProps,
} from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Padding } from "../Decorator";
import { FieldsetContext, FlexItem, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { Icon } from "../Surface";

interface SelectProps
    extends ScalableElementProps,
    SpacedElementProps,
    React.InstanceProps<TextBox> {
    selected?: number;
    'max-height'?: CssSize;
    onChange?: (value: number) => void;
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
    openDropdown: (size: UDim2, position: UDim2) => void;
    closeDropdown: () => void;
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
                    context.setSelected(props.index!);
                    context.closeDropdown();
                },

            }}

            Size={new UDim2(1, 0, 0, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={0}
            BackgroundColor3={ColorHelper.getIntentColors(
                theme,
                "primary",
                context.selected === props.index ? "focus" : hover ? "hover" : "default",
                theme.components.select.intents,
            ).backgroundColor}
            AutoButtonColor={false}
        >
            <Padding {...props} />
            {props.text !== undefined && props.children === undefined && <Text text={props.text} TextColor3={ColorHelper.getIntentColors(
                theme,
                "primary",
                context.selected === props.index ? "focus" : hover ? "hover" : "default",
                theme.components.select.intents,
            ).textColor} />}
            {props.children}
        </imagebutton>

    );
}

function ActivateSelect(context: SelectContextValue, overlay: OverlayContextValue) {
    const button = context.buttonRef.current;

    if (button && overlay.overlay) {
        if (context.open) {
            context.closeDropdown();
            return;
        }
        const buttonPosition =
            button.AbsolutePosition;

        const overlayPosition =
            overlay.overlay.AbsolutePosition;

        const localPosition =
            buttonPosition.sub(
                overlayPosition,
            );

        context.openDropdown(
            UDim2.fromOffset(button.AbsoluteSize.X, button.AbsoluteSize.Y),
            UDim2.fromOffset(
                localPosition.X,
                localPosition.Y,
            ),
        );
    }

}

function SelectRenderer(props: SelectProps) {
    const context = React.useContext(SelectContext);
    const theme = React.useContext(CleanThemeContext);
    const overlay = React.useContext(OverlayContext);
    const fieldset = React.useContext(FieldsetContext);
    const [contentHeight, setContentHeight] = React.useState(0);

    const labelActivated = fieldset?.labelActivated;
    const overlayInstance = overlay.overlay;
    const buttonRef = context?.buttonRef;
    const openDropdown = context?.openDropdown;

    assert(
        context !== undefined,
        "SelectRenderer must be used inside a Select",
    );

    if (context.open && overlay.overlay === undefined)
        warn("You have used a Select component without using the Overlay Provider");

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

    const dropdownHeight = math.min(contentHeight, props['max-height'] !== undefined ? SizeHelper.toUDim(props['max-height']).Offset : theme.components.select.maxDropDownHeight);

    React.useEffect(() => {
        if (!labelActivated) {
            return;
        }

        const connection = labelActivated.Event.Connect(() => {
            ActivateSelect(context, overlay);
        });

        return () => connection.Disconnect();
    }, [
        labelActivated,
        overlayInstance,
        buttonRef,
        openDropdown,
    ]);
    return (
        <imagebutton
            ref={context.buttonRef}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            Event={{
                Activated: () => {
                    ActivateSelect(context, overlay);
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
                <Icon icon="caret-down" color={theme.colors.intents.primary.default.textColor} />
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
                    >
                        <uistroke Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Outer} Color={theme.components.select.borderColor} />

                        <Corners radius={theme.components.select.cornerRadius} />
                        <Scroller Size={new UDim2(1, 0, 0, dropdownHeight)} spacing="None">

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
                this.props.onChange?.(selected);
                this.setState({
                    selected,
                });
            },

            openDropdown: (size, position) => {
                this.setState({
                    dropdownSize: size,
                    dropdownPosition: position,
                    open: true,
                });
            },

            closeDropdown: () => {
                this.setState({
                    open: false,
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
                <SelectRenderer {...this.props} />
            </SelectContext.Provider>
        );
    }
}

export { Select };

