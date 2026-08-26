import React from "@rbxts/react";
import { HStack } from "./HStack";
import { VStack } from "./VStack";
import { Text } from "../Typography";
import { Container } from "./Container";
import { CleanThemeContext } from "../../Contexts";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { ScalableElementProps } from "../../Interfaces";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";

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

interface TabTitleProps {
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

}

function TabButtonContent(props: {
    text: string;
}) {
    const theme = React.useContext(CleanThemeContext);
    const hover = React.useContext(HoverButtonContext);
    const intent = ColorHelper.getIntentColors(theme, "primary", hover?.isSelected ? "focus" : hover?.hover ? "hover" : "default", theme.components.tabs.button.intents);
    return <>
        <Corners radius={theme.components.tabs.button.cornerRadius} />
        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.button.spacing)} />
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

        return (

            <VStack>
                <Container
                    ref={ref}
                    BackgroundColor3={theme.components.tabs.list.backgroundColor}
                    width="100%"
                    BackgroundTransparency={0}>
                    <Corners radius={theme.components.tabs.list.cornerRadius} />
                    <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing)} />
                    <HStack>
                        {tabs.map((tab, index) => (
                            <HoverButton isSelected={selected === index}
                                default={{
                                    Size: UDim2.fromScale(0, 0),
                                    AutomaticSize: Enum.AutomaticSize.XY,
                                    ImageTransparency: 1,
                                    BackgroundColor3: buttonDefault.backgroundColor,
                                    BackgroundTransparency: buttonDefault.backgroundTransparency,
                                    BorderSizePixel: 0,
                                    AutoButtonColor: false,
                                    Event: {
                                        Activated: () => {
                                            setSelected(index);
                                        }
                                    }
                                }} hover={{
                                    BackgroundColor3: buttonHover.backgroundColor,
                                    BackgroundTransparency: buttonHover.backgroundTransparency,
                                }} focus={{
                                    BackgroundColor3: buttonFocus.backgroundColor,
                                    BackgroundTransparency: buttonFocus.backgroundTransparency,
                                }}>
                                <TabButtonContent text={tab.title.text} />
                            </HoverButton>
                        ))}
                    </HStack>
                </Container>
                <Container >
                    <uistroke
                        Thickness={theme.components.tabs.borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={theme.components.tabs.borderColor}
                    />
                    <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, {}, theme.components.tabs.spacing)} />
                    <Corners radius={theme.components.tabs.list.cornerRadius} />

                    {selectedTab?.content}
                </Container>
            </VStack>
        );
    }) as TabsComponent;


Tabs.Title = TabTitle;
Tabs.Tab = Tab;
Tabs.Content = TabContent;

export { Tabs };