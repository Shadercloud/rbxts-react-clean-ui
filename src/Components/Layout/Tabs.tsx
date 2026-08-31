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

interface ParsedTab {
    title: TabTitleProps;
    content?: React.ReactNode;
}

interface TabProps {
    children?: React.ReactNode;
}

function Tab(_props: TabProps) {
    return undefined
}

interface TabTitleProps extends PaddingProps {
    text: string;
}

function TabTitle(_props: TabTitleProps) {
    return undefined
}

interface TabContentProps {
    children?: React.ReactNode;
}

function TabContent(props: TabContentProps) {
    return undefined
}


interface TabsProps extends ScalableElementProps {
    backgroundImage?: CssBackgroundImage;
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

type TabsComponent = React.ForwardRefExoticComponent<
    TabsProps & React.RefAttributes<ImageLabel>
> & {
    Tab: typeof Tab;
    Title: typeof TabTitle;
    Content: typeof TabContent;
};

const Tabs = React.forwardRef<ImageLabel, TabsProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const [selected, setSelected] = React.useState<number>(0);

        const tabs = React.useMemo(() => {
            const tabs = new Array<ParsedTab>();

            React.Children.forEach(props.children, (child) => {
                if (!React.isValidElement(child) || child.type !== Tab) {
                    return;
                }

                let title: TabTitleProps | undefined;
                let content: React.ReactNode;
                const tab = child as React.ReactElement<TabProps>;

                React.Children.forEach(tab.props.children, (tabChild) => {
                    if (!React.isValidElement(tabChild)) {
                        return;
                    }


                    if (tabChild.type === TabTitle) {
                        title = (tabChild.props as TabTitleProps);
                    } else if (tabChild.type === TabContent) {
                        content = (tabChild.props as TabContentProps).children;
                    }
                });

                if (title !== undefined) {
                    tabs.push({
                        title,
                        content,
                    });
                }
            });

            return tabs;
        }, [props.children]);

        const tabCount = tabs.size();

        React.useEffect(() => {
            if (selected >= tabCount) {
                setSelected(math.max(0, tabCount - 1));
            }
        }, [selected, tabCount]);

        const selectedTab = tabs[selected];

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

            <VStack>
                <Container
                    ref={ref}
                    BackgroundColor3={theme.components.tabs.list.backgroundColor}
                    width="100%"
                    BackgroundTransparency={theme.components.tabs.list.backgroundTransparency ?? 0}
                    backgroundImage={theme.components.tabs.list.backgroundImage}>
                    <Corners radius={theme.components.tabs.list.cornerRadius} />
                    <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing, theme.components.tabs.list.padding)} />
                    <HStack>
                        {tabs.map((tab, index) => (
                            <HoverButton isSelected={selected === index}
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
                                            setSelected(index);
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
                                <TabButtonContent {...tab.title} />
                            </HoverButton>
                        ))}
                    </HStack>
                </Container>
                <Container backgroundImage={props.backgroundImage ?? theme.components.tabs.backgroundImage}>
                    <uistroke
                        Thickness={theme.components.tabs.borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={theme.components.tabs.borderColor}
                    />
                    <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.spacing, theme.components.tabs.padding)} />
                    <Corners radius={theme.components.tabs.cornerRadius} />

                    {selectedTab?.content}
                </Container>
            </VStack>
        );
    }) as TabsComponent;


Tabs.Title = TabTitle;
Tabs.Tab = Tab;
Tabs.Content = TabContent;

export { Tabs };