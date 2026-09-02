import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import {
    CleanThemeContext,
    OverlayContext,
} from "../../Contexts";
import { ColorHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import {
    CssSize,
    ScalableElementProps,
    ScaleSize,
    SpacedElementProps,
} from "../../Interfaces";
import { CssBackgroundImage } from "../../Theme";
import { Corners, Padding } from "../Decorator";
import { Container, FieldsetContext, FlexItem, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { Icon } from "../Surface";
import { Input } from "./Input";

export interface SelectProps
    extends ScalableElementProps,
    SpacedElementProps,
    React.InstanceProps<ImageLabel> {
    selected?: number;
    'max-height'?: CssSize;
    backgroundImage?: CssBackgroundImage;
    onChange?: (selected: number, value?: string) => void;
    name?: string;
    searchable?: boolean;
    searchPlaceholder?: string;
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

    assert(props.index !== undefined, "Select.Option must be a direct child of Select or Select.OptGroup",);

    return (
        <imagebutton
            key="Option"
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
            {props.text !== undefined && props.children === undefined && <Text name="OptionText" text={props.text} TextColor3={ColorHelper.getIntentColors(
                theme,
                "primary",
                context.selected === props.index ? "focus" : hover ? "hover" : "default",
                theme.components.select.intents,
            ).textColor} />}
            {props.children}
        </imagebutton>

    );
}

interface SelectOptGroupProps {
    label: string;
    children?: React.ReactNode;
}

function SelectOptGroup(_props: SelectOptGroupProps) {
    return undefined;
}

interface ParsedOption {
    index: number;
    element: React.ReactElement<SelectOptionProps>;
    text?: string;
}

interface ParsedGroup {
    key: string;
    label: string;
    options: ParsedOption[];
}

type ParsedSection =
    | { kind: "option"; option: ParsedOption }
    | { kind: "group"; group: ParsedGroup }
    | { kind: "node"; key: string; node: React.ReactNode };

interface ParsedSelectChildren {
    sections: ParsedSection[];
    // flatOptions[i].index === i always, gap-free
    flatOptions: ParsedOption[];
}

function parseSelectChildren(children: React.ReactNode): ParsedSelectChildren {
    const sections = new Array<ParsedSection>();
    const flatOptions = new Array<ParsedOption>();

    let index = 0;
    let nodeCount = 0;
    let groupCount = 0;

    // Fragment-wrapped children (`<>...</>`) are unwrapped/recursed into so
    // consumers can conditionally compose Option/OptGroup lists (a common
    // React pattern) without breaking option indexing.
    const collectGroupOptions = (node: React.ReactNode, options: ParsedOption[]) => {
        React.Children.forEach(node, (groupChild) => {
            if (React.isValidElement(groupChild) && groupChild.type === React.Fragment) {
                collectGroupOptions((groupChild.props as { children?: React.ReactNode }).children, options);
                return;
            }

            if (!React.isValidElement<SelectOptionProps>(groupChild) || groupChild.type !== SelectOption) {
                return;
            }

            const option: ParsedOption = { index: index++, element: groupChild, text: groupChild.props.text };
            options.push(option);
            flatOptions.push(option);
        });
    };

    const visit = (child: React.ReactNode) => {
        if (React.isValidElement(child) && child.type === React.Fragment) {
            React.Children.forEach((child.props as { children?: React.ReactNode }).children, visit);
            return;
        }

        if (React.isValidElement<SelectOptionProps>(child) && child.type === SelectOption) {
            const option: ParsedOption = { index: index++, element: child, text: child.props.text };
            sections.push({ kind: "option", option });
            flatOptions.push(option);
            return;
        }

        if (React.isValidElement<SelectOptGroupProps>(child) && child.type === SelectOptGroup) {
            const options = new Array<ParsedOption>();

            collectGroupOptions(child.props.children, options);

            sections.push({ kind: "group", group: { key: `group-${groupCount++}`, label: child.props.label, options } });
            return;
        }

        sections.push({ kind: "node", key: `node-${nodeCount++}`, node: child });
    };

    React.Children.forEach(children, visit);

    return { sections, flatOptions };
}

function optionMatchesQuery(option: ParsedOption, normalizedQuery: string): boolean {
    if (normalizedQuery === "") return true;
    if (option.text === undefined) return true;

    // Plain-text/literal find (the trailing `true`) avoids treating Lua
    // pattern characters in the query (e.g. `%`, `-`) as patterns.
    return option.text.lower().find(normalizedQuery, 1, true)[0] !== undefined;
}

interface SelectSearchInputProps {
    value: string;
    onChange: (value: string) => void;
    placeholder?: string;
    scale?: ScaleSize;
}

function SelectSearchInput(props: SelectSearchInputProps) {
    const theme = React.useContext(CleanThemeContext);

    return (
        <frame key="SearchInput" Size={UDim2.fromScale(1, 0)} AutomaticSize={Enum.AutomaticSize.Y} BackgroundTransparency={1}>
            <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.select.search.spacing, theme.components.select.search.padding)} />
            <Input
                icon="search"
                controlled
                value={props.value}
                onChange={props.onChange}
                placeholder={props.placeholder ?? "Search"}
                scale={props.scale}
            />
        </frame>
    );
}

interface SelectGroupHeaderProps {
    label: string;
    scale?: ScaleSize;
}

function SelectGroupHeader(props: SelectGroupHeaderProps) {
    const theme = React.useContext(CleanThemeContext);

    const typography = TypographyHelper.getTypography(
        theme,
        props.scale,
        theme.components.select.optGroup.typography,
    );

    return (
        <frame
            key="OptGroupHeader"
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundColor3={theme.components.select.optGroup.backgroundColor}
            BackgroundTransparency={theme.components.select.optGroup.backgroundTransparency ?? 1}
            BorderSizePixel={0}
        >
            <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.select.optGroup.spacing, theme.components.select.optGroup.padding)} />
            <Text name="OptGroupLabel" text={props.label} TextColor3={theme.components.select.optGroup.textColor} typography={typography} />
        </frame>
    );
}

type SelectComponent = React.ForwardRefExoticComponent<
    SelectProps & React.RefAttributes<ImageLabel>
> & {
    Option: typeof SelectOption;
    OptGroup: typeof SelectOptGroup;
};


const Select = React.forwardRef<ImageLabel, SelectProps>((props, ref) => {
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
    const [query, setQuery] = React.useState("");

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

    const { sections, flatOptions } = React.useMemo(() => parseSelectChildren(props.children), [props.children]);

    const selectedOption = flatOptions[selected]?.element ?? flatOptions[0]?.element;

    React.useEffect(() => {
        if (!open) setQuery("");
    }, [open]);

    const normalizedQuery = props.searchable ? query.lower() : "";

    const renderOption = (option: ParsedOption) =>
        React.cloneElement(option.element, { index: option.index, key: `option-${option.index}` });

    const renderSections = () => sections.map((section) => {
        if (section.kind === "node") {
            return section.node;
        }

        if (section.kind === "option") {
            if (props.searchable && !optionMatchesQuery(section.option, normalizedQuery)) {
                return undefined;
            }

            return renderOption(section.option);
        }

        if (section.group.options.size() === 0) {
            return undefined;
        }

        const visibleOptions = props.searchable
            ? section.group.options.filter((option) => optionMatchesQuery(option, normalizedQuery))
            : section.group.options;

        if (props.searchable && query !== "" && visibleOptions.size() === 0) {
            return undefined;
        }

        return (
            <React.Fragment key={section.group.key}>
                <SelectGroupHeader label={section.group.label} scale={props.scale} />
                {visibleOptions.map(renderOption)}
            </React.Fragment>
        );
    });

    const hasVisibleOptions = !props.searchable || query === "" || flatOptions.some((option) => optionMatchesQuery(option, normalizedQuery));

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
            name={props.name ?? "Select"}
            ref={ref}
            {...props}
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            backgroundImage={props.backgroundImage ?? theme.components.select.backgroundImage}
        >
            <SelectContext.Provider value={context}>
                <imagebutton
                    key="SelectButton"
                    ref={buttonRef}
                    Size={UDim2.fromScale(1, 0)}
                    AutomaticSize={Enum.AutomaticSize.Y}
                    BackgroundTransparency={1}
                    Event={{
                        Activated: activateSelect,
                    }}
                >
                    <uistroke key="Stroke" Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Inner} Color={theme.components.select.borderColor} />

                    <Corners radius={theme.components.select.cornerRadius} />

                    <Padding {...props} />
                    <HStack>
                        <FlexItem>
                            <Text
                                name="SelectedText"
                                text={selectedOption?.props.text ?? "No Options"}
                                typography={typography}
                            />
                        </FlexItem>
                        <Icon name="SelectCaret" icon="caret-down" color={theme.colors.intents.primary.default.textColor} />
                    </HStack>

                    {open &&
                        overlay.overlay !== undefined &&
                        ReactRoblox.createPortal(
                            <frame
                                key="SelectDropdown"
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
                                <uistroke key="Stroke" Thickness={theme.components.select.borderThickness} BorderStrokePosition={Enum.BorderStrokePosition.Outer} Color={theme.components.select.borderColor} />

                                <Corners radius={theme.components.select.cornerRadius} />

                                <VStack spacing="None">
                                    {props.searchable && (
                                        <SelectSearchInput
                                            value={query}
                                            onChange={setQuery}
                                            placeholder={props.searchPlaceholder}
                                            scale={props.scale}
                                        />
                                    )}
                                    <Scroller Size={new UDim2(1, 0, 0, dropdownHeight)} spacing="None">
                                        <VStack
                                            spacing="None"
                                            Change={{
                                                AbsoluteContentSize: (layout) => {
                                                    setContentHeight(layout.AbsoluteContentSize.Y);
                                                },
                                            }}>
                                            {hasVisibleOptions
                                                ? renderSections()
                                                : <Text name="NoResultsText" text="No Results" typography={typography} />}
                                        </VStack>
                                    </Scroller>
                                </VStack>
                            </frame>,
                            overlay.overlay,
                        )}
                </imagebutton>
            </SelectContext.Provider>
        </Container>
    );
}) as SelectComponent;

Select.Option = SelectOption;
Select.OptGroup = SelectOptGroup;
export { Select }
