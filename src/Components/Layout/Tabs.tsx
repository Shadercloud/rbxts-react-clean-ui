import React from "@rbxts/react";
import { HStack } from "./HStack";
import { VStack } from "./VStack";
import { Text } from "../Typography";
import { Container } from "./Container";
import { CleanThemeContext } from "../../Contexts";
import { BoxShadow, Corners, Gradient, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { CssBackgroundGradient, PaddingProps, ScalableElementProps } from "../../Interfaces";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";
import { CssBackgroundImage } from "../../Theme";

interface TabsContextValue {
    selected: string | undefined;
    claimTab: (value: string) => void;
    selectTab: (value: string) => void;
}

const TabsContext = React.createContext<TabsContextValue>({
    selected: undefined,
    claimTab: () => { },
    selectTab: () => { },
});

interface TabsListContextValue {
    fill: boolean;
}

const TabsListContext = React.createContext<TabsListContextValue>({
    fill: false,
});

interface TabTitleProps extends PaddingProps {
    value: string;
    text: string;
}

function TabButtonCorners() {
    const theme = React.useContext(CleanThemeContext);
    const cornerRadius = theme.components.tabs.button.cornerRadius;

    if (!typeIs(cornerRadius, "table")) {
        return <Corners radius={theme.components.tabs.list.cornerRadius} />;
    }

    const fallback = SizeHelper.toUDim(theme.components.tabs.list.cornerRadius);
    const topLeftRadius = cornerRadius.topLeft !== undefined ? CssHelper.parseCssSize(cornerRadius.topLeft) : fallback;
    const topRightRadius = cornerRadius.topRight !== undefined ? CssHelper.parseCssSize(cornerRadius.topRight) : fallback;
    const bottomLeftRadius = cornerRadius.bottomLeft !== undefined ? CssHelper.parseCssSize(cornerRadius.bottomLeft) : fallback;
    const bottomRightRadius = cornerRadius.bottomRight !== undefined ? CssHelper.parseCssSize(cornerRadius.bottomRight) : fallback;

    const isZero = (radius: UDim) => radius.Scale === 0 && radius.Offset === 0;

    if (isZero(topLeftRadius) && isZero(topRightRadius) && isZero(bottomLeftRadius) && isZero(bottomRightRadius)) {
        return undefined;
    }

    return <uicorner
        key="Corners"
        TopLeftRadius={topLeftRadius}
        TopRightRadius={topRightRadius}
        BottomLeftRadius={bottomLeftRadius}
        BottomRightRadius={bottomRightRadius}
    />;
}

function TabButtonContent(props: TabTitleProps) {
    const theme = React.useContext(CleanThemeContext);
    const hover = React.useContext(HoverButtonContext);
    const { fill } = React.useContext(TabsListContext);
    const intent = ColorHelper.getIntentColors(theme, "primary", hover?.isSelected ? "focus" : hover?.hover ? "hover" : "default", theme.components.tabs.button.intents);
    const borderThickness = intent.borderThickness ?? theme.components.tabs.button.borderThickness;
    return <>
        <TabButtonCorners />
        {borderThickness > 0 && (
            <uistroke
                key="Stroke"
                Thickness={borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={intent.borderColor}
            />
        )}
        <Gradient value={intent.backgroundGradient} />
        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props, theme.components.tabs.button.spacing, theme.components.tabs.button.padding)} />
        <BoxShadow value={intent.boxShadow} />
        {fill && (
            <uilistlayout
                key="TitleLayout"
                FillDirection={Enum.FillDirection.Horizontal}
                HorizontalAlignment={Enum.HorizontalAlignment.Center}
                VerticalAlignment={Enum.VerticalAlignment.Center}
                SortOrder={Enum.SortOrder.LayoutOrder}
            />
        )}
        <Text
            name="TabTitleText"
            TextColor3={intent.textColor}
            text={props.text}
            typography={TypographyHelper.getTypography(theme, undefined, intent.typography)}

        /></>
}

function TabTitle(props: TabTitleProps) {
    const theme = React.useContext(CleanThemeContext);
    const { selected, claimTab, selectTab } = React.useContext(TabsContext);
    const { fill } = React.useContext(TabsListContext);
    const isSelected = selected === props.value;

    React.useEffect(() => {
        claimTab(props.value);
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
            name={`TabButton-${props.value}`}
            default={{
                Size: UDim2.fromScale(0, 0),
                AutomaticSize: fill ? Enum.AutomaticSize.Y : Enum.AutomaticSize.XY,
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
                        selectTab(props.value);
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
    fill?: boolean;
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
                <Gradient value={theme.components.tabs.list.backgroundGradient} />
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing, theme.components.tabs.list.padding)} />
                <TabsListContext.Provider value={{ fill: props.fill === true }}>
                    <HStack
                        HorizontalFlex={props.fill ? Enum.UIFlexAlignment.Fill : undefined}
                        Wraps={props.fill ? false : undefined}
                        Padding={theme.components.tabs.list.gap !== undefined ? new UDim(0, theme.components.tabs.list.gap) : undefined}
                    >
                        {props.children}
                    </HStack>
                </TabsListContext.Provider>
            </Container>
        );
    });

interface TabsBodyProps extends ScalableElementProps {
    backgroundImage?: CssBackgroundImage;
    backgroundGradient?: CssBackgroundGradient;
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
                {theme.components.tabs.borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={theme.components.tabs.borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={theme.components.tabs.borderColor}
                    />
                )}
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.spacing, theme.components.tabs.padding)} />
                <Corners radius={theme.components.tabs.cornerRadius} />
                <Gradient value={props.backgroundGradient ?? theme.components.tabs.backgroundGradient} />

                {props.children}
            </Container>
        );
    });

export interface TabsProps {
    children?: React.ReactNode;
    defaultValue?: string;
    value?: string;
    onValueChange?: (value: string) => void;
}

type TabsComponent = React.ForwardRefExoticComponent<
    TabsProps & React.RefAttributes<Frame>
> & {
    List: typeof TabsList;
    Body: typeof TabsBody;
    Title: typeof TabTitle;
    Content: typeof TabContent;
};

const Tabs = React.forwardRef<Frame, TabsProps>((props, _ref) => {
    const theme = React.useContext(CleanThemeContext);
    const [uncontrolledSelected, setUncontrolledSelected] = React.useState<string | undefined>(props.defaultValue);

    const controlled = props.value !== undefined;
    const selected = controlled ? props.value : uncontrolledSelected;
    const onValueChange = props.onValueChange;

    const contextValue = React.useMemo<TabsContextValue>(
        () => ({
            selected,
            claimTab: (value) => {
                if (!controlled) {
                    setUncontrolledSelected((current) => current ?? value);
                }
            },
            selectTab: (value) => {
                if (!controlled) {
                    setUncontrolledSelected(value);
                }
                onValueChange?.(value);
            },
        }),
        [selected, controlled, onValueChange],
    );

    return (
        <TabsContext.Provider value={contextValue}>
            <VStack Padding={theme.components.tabs.gap !== undefined ? new UDim(0, theme.components.tabs.gap) : undefined}>{props.children}</VStack>
        </TabsContext.Provider>
    );
}) as TabsComponent;

Tabs.List = TabsList;
Tabs.Body = TabsBody;
Tabs.Title = TabTitle;
Tabs.Content = TabContent;

export { Tabs };
