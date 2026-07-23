import React, { Component, ReactComponent, useContext } from "@rbxts/react";
import { HStack } from "./HStack";
import { VStack } from "./VStack";
import { Text } from "../Typography";
import { Container } from "./Container";
import { CleanThemeContext } from "../../Contexts";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { ScalableElementProps } from "../../Interfaces";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";


interface TabsContextValue {
    selected: number;
}

const TabsContext = React.createContext<TabsContextValue | undefined>(
    undefined,
);

interface ParsedTab {
    title: TabTitleProps;
    content?: React.ReactNode;
}


interface TabProps {
    children?: React.ReactNode;
}

function Tab(props: TabProps) {
    return undefined
}

interface TabTitleProps {
    text: string;
    children?: React.ReactNode;
}

function TabTitle(props: TabTitleProps) {
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

interface TabsState {
    selected: number;
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

@ReactComponent
export class Tabs extends Component<TabsProps, TabsState> {
    static Tab = Tab
    static Title = TabTitle
    static Content = TabContent

    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;


    state: TabsState = {
        selected: 0
    }

    render(): React.ReactNode {
        const context: TabsContextValue = {
            selected: this.state.selected
        }

        const tabs = new Array<ParsedTab>();

        React.Children.forEach(this.props.children, (child) => {
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

        const selectedTab = tabs[this.state.selected];

        return (
            <TabsContext.Provider value={context}>
                <VStack>
                    <Container BackgroundColor3={this.context.components.tabs.list.backgroundColor} width="100%" BackgroundTransparency={0}>
                        <Corners radius={this.context.components.tabs.list.cornerRadius} />
                        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(this.context, {}, this.context.components.tabs.list.spacing)} />
                        <HStack>
                            {tabs.map((tab, index) => (
                                <HoverButton isSelected={this.state.selected === index}
                                    default={{
                                        Size: UDim2.fromScale(0, 0),
                                        AutomaticSize: Enum.AutomaticSize.XY,
                                        ImageTransparency: 1,
                                        BackgroundColor3: ColorHelper.getIntentColors(this.context, "primary", "default", this.context.components.tabs.button.intents).backgroundColor,
                                        BackgroundTransparency: ColorHelper.getIntentColors(this.context, "primary", "default", this.context.components.tabs.button.intents).backgroundTransparency,
                                        BorderSizePixel: 0,
                                        AutoButtonColor: false,
                                        Event: {
                                            Activated: () => {
                                                this.setState({ selected: index })
                                            }
                                        }
                                    }} hover={{
                                        BackgroundColor3: ColorHelper.getIntentColors(this.context, "primary", "hover", this.context.components.tabs.button.intents).backgroundColor,
                                        BackgroundTransparency: ColorHelper.getIntentColors(this.context, "primary", "hover", this.context.components.tabs.button.intents).backgroundTransparency,
                                    }} focus={{
                                        BackgroundColor3: ColorHelper.getIntentColors(this.context, "primary", "focus", this.context.components.tabs.button.intents).backgroundColor,
                                        BackgroundTransparency: ColorHelper.getIntentColors(this.context, "primary", "focus", this.context.components.tabs.button.intents).backgroundTransparency,
                                    }}>
                                    <TabButtonContent text={tab.title.text} />
                                </HoverButton>
                            ))}
                        </HStack>
                    </Container>
                    <Container >
                        <uistroke
                            Thickness={this.context.components.tabs.borderThickness}
                            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                            Color={this.context.components.tabs.borderColor}
                        />
                        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(this.context, {}, this.context.components.tabs.spacing)} />
                        <Corners radius={this.context.components.tabs.list.cornerRadius} />

                        {selectedTab?.content}
                    </Container>
                </VStack>
            </TabsContext.Provider >
        );
    }
}