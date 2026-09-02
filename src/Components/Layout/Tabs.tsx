import React from "@rbxts/react";
import { HStack } from "./HStack";
import { VStack } from "./VStack";
import { Text } from "../Typography";
import { Container } from "./Container";
import { CleanThemeContext } from "../../Contexts";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { PaddingProps, ScalableElementProps } from "../../Interfaces";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";
import { CssBackgroundImage } from "../../Theme";

// Selection only — Tabs.List/Tabs.Body/Tabs.Title/Tabs.Content each render
// themselves for real (see Card.tsx's CardHeader/CardFooter for the same
// "Root provides Context, subparts consume it independently" pattern), so
// there's nothing here to scan or harvest from children.
interface TabsContextValue {
    selected: string | undefined;
    setSelected: (value: string) => void;
}

const TabsContext = React.createContext<TabsContextValue>({
    selected: undefined,
    setSelected: () => { },
});

interface TabTitleProps extends PaddingProps {
    value: string;
    text: string;
}

function TabButtonContent(props: TabTitleProps) {
    const theme = React.useContext(CleanThemeContext);
    const hover = React.useContext(HoverButtonContext);
    const intent = ColorHelper.getIntentColors(theme, "primary", hover?.isSelected ? "focus" : hover?.hover ? "hover" : "default", theme.components.tabs.button.intents);
    return <>
        <Corners radius={theme.components.tabs.list.cornerRadius} />
        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props, theme.components.tabs.button.spacing, theme.components.tabs.button.padding)} />
        <BoxShadow value={intent.boxShadow} />
        <Text
            TextColor3={intent.textColor}
            text={props.text}
            typography={TypographyHelper.getTypography(theme, undefined, intent.typography)}

        /></>
}

// The real per-tab button — derives its own default/hover/focus color scheme
// from the theme (same per-instance derivation Card.Header/Card.Footer use,
// not hoisted to Root) and drives selection itself via TabsContext.
function TabTitle(props: TabTitleProps) {
    const theme = React.useContext(CleanThemeContext);
    const { selected, setSelected } = React.useContext(TabsContext);
    const isSelected = selected === props.value;

    // The first-mounted Tabs.Title claims the selection if none is set yet,
    // preserving "first tab selected by default" now that nothing scans the
    // tab list up front. Known limitation: if the currently-selected tab's
    // Tabs.Title unmounts, selection isn't automatically reassigned.
    React.useEffect(() => {
        if (selected === undefined) {
            setSelected(props.value);
        }
    }, []);

    const buttonDefault = ColorHelper.getIntentColors(
        theme,
        "primary",
        "default",
        theme.components.tabs.button.intents,
    );

    const buttonHover = ColorHelper.getIntentColors(
        theme,
        "primary",
        "hover",
        theme.components.tabs.button.intents,
    );

    const buttonFocus = ColorHelper.getIntentColors(
        theme,
        "primary",
        "focus",
        theme.components.tabs.button.intents,
    );

    const buttonDefaultBackgroundImage = CssHelper.resolveBackgroundImage(buttonDefault.backgroundImage);
    const buttonHoverBackgroundImage = CssHelper.resolveBackgroundImage(buttonHover.backgroundImage);
    const buttonFocusBackgroundImage = CssHelper.resolveBackgroundImage(buttonFocus.backgroundImage);

    return (
        <HoverButton isSelected={isSelected}
            default={{
                Size: UDim2.fromScale(0, 0),
                AutomaticSize: Enum.AutomaticSize.XY,
                BackgroundColor3: buttonDefault.backgroundColor,
                BackgroundTransparency: buttonDefault.backgroundTransparency,
                BorderSizePixel: 0,
                AutoButtonColor: false,
                Image: buttonDefaultBackgroundImage.Image,
                ImageColor3: buttonDefaultBackgroundImage.ImageColor3,
                ImageTransparency: buttonDefaultBackgroundImage.ImageTransparency,
                ScaleType: buttonDefaultBackgroundImage.ScaleType,
                SliceCenter: buttonDefaultBackgroundImage.SliceCenter,
                SliceScale: buttonDefaultBackgroundImage.SliceScale,
                TileSize: buttonDefaultBackgroundImage.TileSize,
                Event: {
                    Activated: () => {
                        setSelected(props.value);
                    }
                }
            }} hover={{
                BackgroundColor3: buttonHover.backgroundColor,
                BackgroundTransparency: buttonHover.backgroundTransparency,
                Image: buttonHoverBackgroundImage.Image,
                ImageColor3: buttonHoverBackgroundImage.ImageColor3,
                ImageTransparency: buttonHoverBackgroundImage.ImageTransparency,
                ScaleType: buttonHoverBackgroundImage.ScaleType,
                SliceCenter: buttonHoverBackgroundImage.SliceCenter,
                SliceScale: buttonHoverBackgroundImage.SliceScale,
                TileSize: buttonHoverBackgroundImage.TileSize,
            }} focus={{
                BackgroundColor3: buttonFocus.backgroundColor,
                BackgroundTransparency: buttonFocus.backgroundTransparency,
                Image: buttonFocusBackgroundImage.Image,
                ImageColor3: buttonFocusBackgroundImage.ImageColor3,
                ImageTransparency: buttonFocusBackgroundImage.ImageTransparency,
                ScaleType: buttonFocusBackgroundImage.ScaleType,
                SliceCenter: buttonFocusBackgroundImage.SliceCenter,
                SliceScale: buttonFocusBackgroundImage.SliceScale,
                TileSize: buttonFocusBackgroundImage.TileSize,
            }}>
            <TabButtonContent {...props} />
        </HoverButton>
    );
}

interface TabContentProps {
    value: string;
    children?: React.ReactNode;
}

// Always mounted — visibility is toggled rather than the panel being
// unmounted/remounted, so per-tab local state (e.g. a Scroller's scroll
// position) survives switching tabs. Roblox excludes a GuiObject with
// Visible=false from its ancestors' AutomaticSize/UIListLayout
// content-size calculations, so the hidden panels don't inflate Tabs.Body's
// own AutomaticSize; since only one panel is ever visible at a time, the
// default (unset) Position/AnchorPoint every panel shares never causes a
// visible overlap either.
function TabContent(props: TabContentProps) {
    const { selected } = React.useContext(TabsContext);

    return (
        <Container
            name={`TabContent_${props.value}`}
            width="100%"
            Visible={selected === props.value}>
            {props.children}
        </Container>
    );
}

interface TabsListProps extends ScalableElementProps {
    children?: React.ReactNode;
}

const TabsList = React.forwardRef<ImageLabel, TabsListProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        return (
            <Container
                name="TabsList"
                ref={ref}
                BackgroundColor3={theme.components.tabs.list.backgroundColor}
                width="100%"
                BackgroundTransparency={theme.components.tabs.list.backgroundTransparency ?? 0}
                backgroundImage={theme.components.tabs.list.backgroundImage}>
                <Corners radius={theme.components.tabs.list.cornerRadius} />
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing, theme.components.tabs.list.padding)} />
                <HStack>
                    {props.children}
                </HStack>
            </Container>
        );
    });

interface TabsBodyProps extends ScalableElementProps {
    backgroundImage?: CssBackgroundImage;
    children?: React.ReactNode;
}

const TabsBody = React.forwardRef<ImageLabel, TabsBodyProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        return (
            <Container
                name="TabsBody"
                ref={ref}
                width="100%"
                backgroundImage={props.backgroundImage ?? theme.components.tabs.backgroundImage}>
                <uistroke
                    Thickness={theme.components.tabs.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={theme.components.tabs.borderColor}
                />
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.spacing, theme.components.tabs.padding)} />
                <Corners radius={theme.components.tabs.cornerRadius} />

                {props.children}
            </Container>
        );
    });

export interface TabsProps {
    children?: React.ReactNode;
    defaultValue?: string;
}

// Root doesn't render a real Roblox Instance of its own (just a Context
// Provider around a VStack, itself just a Fragment) — see Group.tsx for the
// same shape. It's still wrapped in React.forwardRef, not a plain function,
// because roblox-ts compiles a bare arrow function to an actual Lua
// `function` value, and Lua functions can't have table-style properties
// (Tabs.List = ...) assigned onto them — forwardRef's return value compiles
// to a table instead. The ref itself is genuinely unused: there's no
// sensible Instance for it to point at, so RefAttributes<Frame> below is a
// type-level placeholder to keep this consistent with every other compound
// component's shape, not a real forwarded ref — Tabs does not support a
// `ref` prop in practice.
type TabsComponent = React.ForwardRefExoticComponent<
    TabsProps & React.RefAttributes<Frame>
> & {
    List: typeof TabsList;
    Body: typeof TabsBody;
    Title: typeof TabTitle;
    Content: typeof TabContent;
};

const Tabs = React.forwardRef<Frame, TabsProps>((props, _ref) => {
    const [selected, setSelected] = React.useState<string | undefined>(props.defaultValue);

    const contextValue = React.useMemo<TabsContextValue>(
        () => ({ selected, setSelected }),
        [selected],
    );

    return (
        <TabsContext.Provider value={contextValue}>
            <VStack>{props.children}</VStack>
        </TabsContext.Provider>
    );
}) as TabsComponent;

Tabs.List = TabsList;
Tabs.Body = TabsBody;
Tabs.Title = TabTitle;
Tabs.Content = TabContent;

export { Tabs };
