import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import {
    CleanThemeContext,
    OverlayContext,
} from "../../Contexts";
import { ColorHelper, SizeHelper, TypographyHelper } from "../../Helpers";
import {
    CssSize,
    ScalableElementProps,
    SpacedElementProps,
} from "../../Interfaces";
import { Corners, Padding } from "../Decorator";
import { Container, FieldsetContext, FlexItem, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { Icon } from "../Surface";

interface SelectProps
    extends ScalableElementProps,
    SpacedElementProps,
    React.InstanceProps<Frame> {
    selected?: number;
    'max-height'?: CssSize;
    onChange?: (selected: number, value?: string) => void;
}


interface SelectContextValue {
    selected: number;
    open: boolean;
    dropdownSize: UDim2;
    dropdownPosition: UDim2;
    buttonRef: React.RefObject<ImageButton>;
    setSelected: (selected: number, value?: string) => void;
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
    value?: string;
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
                    context.setSelected(props.index!, props.value);
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

type SelectComponent = React.ForwardRefExoticComponent<
    SelectProps & React.RefAttributes<Frame>
> & {
    Option: typeof SelectOption;
};


const Select = React.forwardRef<Frame, SelectProps>((props, ref) => {
    const theme = React.useContext(CleanThemeContext);
    const overlay = React.useContext(OverlayContext);
    const fieldset = React.useContext(FieldsetContext);

    const [selected, setSelected] = React.useState(props.selected ?? 0);
    const [open, setOpen] = React.useState(false);
    const [dropdownSize, setDropdownSize] = React.useState(
        UDim2.fromOffset(0, 0),
    );
    const [dropdownPosition, setDropdownPosition] = React.useState(
        UDim2.fromOffset(0, 0),
    );
    const [contentHeight, setContentHeight] = React.useState(0);

    const buttonRef = React.useRef<ImageButton>();

    const context = React.useMemo<SelectContextValue>(() => ({
        selected,
        open,
        dropdownSize,
        dropdownPosition,
        buttonRef,

        setSelected: (index, value) => {
            props.onChange?.(index, value);
            setSelected(index);
        },

        openDropdown: (size, position) => {
            setDropdownPosition(position);
            setDropdownSize(size);
            setOpen(true);
        },

        closeDropdown: () => {
            setOpen(false);
        },

        toggleOpen: () => {
            setOpen(current => !current);
        },
    }), [
        props.onChange,
        selected,
        open,
        dropdownSize,
        dropdownPosition,
    ]);

    const typography = TypographyHelper.getTypography(
        theme,
        props.scale,
        theme.components.select.typography,
    );

    const children = React.Children.toArray(props.children);

    const selectedOption = (
        children[selected] ?? children[0]
    ) as React.ReactElement<SelectOptionProps> | undefined;

    const dropdownHeight = math.min(
        contentHeight,
        props["max-height"] !== undefined
            ? SizeHelper.toUDim(props["max-height"]).Offset
            : theme.components.select.maxDropDownHeight,
    );

    const activateSelect = React.useCallback(() => {
        const button = buttonRef.current;
        const overlayInstance = overlay.overlay;

        if (!button || !overlayInstance) {
            return;
        }

        if (open) {
            setOpen(false);
            return;
        }

        const localPosition = button.AbsolutePosition.sub(
            overlayInstance.AbsolutePosition,
        );

        setDropdownPosition(UDim2.fromOffset(
            localPosition.X,
            localPosition.Y,
        ));

        setDropdownSize(UDim2.fromOffset(
            button.AbsoluteSize.X,
            button.AbsoluteSize.Y,
        ));

        setOpen(true);
    }, [open, overlay.overlay]);

    React.useEffect(() => {
        const labelActivated = fieldset?.labelActivated;

        if (!labelActivated) {
            return;
        }

        const connection = labelActivated.Event.Connect(activateSelect);
        return () => connection.Disconnect();
    }, [fieldset?.labelActivated, activateSelect]);

    if (open && overlay.overlay === undefined) {
        warn(
            "You have used a Select component without using the Overlay Provider",
        );
    }

    return (
        <Container
            ref={ref}
            {...props}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
        >
            <SelectContext.Provider value={context}>
                <imagebutton
                    ref={buttonRef}
                    Size={UDim2.fromScale(1, 0)}
                    AutomaticSize={Enum.AutomaticSize.Y}
                    BackgroundTransparency={1}
                    Event={{
                        Activated: activateSelect,
                    }}
                >
                    <uistroke Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Inner} Color={theme.components.select.borderColor} />

                    <Corners radius={theme.components.select.cornerRadius} />

                    <Padding {...props} />
                    <HStack>
                        <FlexItem>
                            <Text
                                text={selectedOption?.props.text ?? "No Options"}
                                typography={typography}
                            />
                        </FlexItem>
                        <Icon icon="caret-down" color={theme.colors.intents.primary.default.textColor} />
                    </HStack>

                    {open &&
                        overlay.overlay !== undefined &&
                        ReactRoblox.createPortal(
                            <frame
                                BackgroundTransparency={0}
                                BackgroundColor3={
                                    theme.components.select.dropDownBackgroundColor
                                }
                                AnchorPoint={Vector2.zero}
                                Position={dropdownPosition.add(new UDim2(0, 0, 0, dropdownSize.Y.Offset))}
                                Size={UDim2.fromOffset(dropdownSize.X.Offset, 0)}
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
                                        {React.Children.map(props.children, (child, childIndex) => {
                                            if (!React.isValidElement<SelectOptionProps>(child)) {
                                                return child;
                                            }

                                            // React.Children.map uses a 1-based index in roblox-ts.
                                            const optionIndex = childIndex - 1;

                                            return React.cloneElement(child, {
                                                index: optionIndex,
                                            });
                                        })}
                                    </VStack>
                                </Scroller>
                            </frame>,
                            overlay.overlay,
                        )}
                </imagebutton>
            </SelectContext.Provider>
        </Container>
    );
}) as SelectComponent;

Select.Option = SelectOption;
export { Select }