import React, { Component } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { ScalableElementProps } from "../../Interfaces";
interface TabProps {
    children?: React.ReactNode;
}
declare function Tab(props: TabProps): undefined;
interface TabTitleProps {
    text: string;
    children?: React.ReactNode;
}
declare function TabTitle(props: TabTitleProps): undefined;
interface TabContentProps {
    children?: React.ReactNode;
}
declare function TabContent(props: TabContentProps): undefined;
interface TabsProps extends ScalableElementProps {
}
interface TabsState {
    selected: number;
}
export declare class Tabs extends Component<TabsProps, TabsState> {
    static Tab: typeof Tab;
    static Title: typeof TabTitle;
    static Content: typeof TabContent;
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    state: TabsState;
    render(): React.ReactNode;
}
export {};
