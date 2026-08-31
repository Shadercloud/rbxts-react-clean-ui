import React from "@rbxts/react";
import { PaddingProps, ScalableElementProps } from "../../Interfaces";
import { CssBackgroundImage } from "../../Theme";
interface TabProps {
    children?: React.ReactNode;
}
declare function Tab(_props: TabProps): undefined;
interface TabTitleProps extends PaddingProps {
    text: string;
}
declare function TabTitle(_props: TabTitleProps): undefined;
interface TabContentProps {
    children?: React.ReactNode;
}
declare function TabContent(props: TabContentProps): undefined;
interface TabsProps extends ScalableElementProps {
    backgroundImage?: CssBackgroundImage;
}
type TabsComponent = React.ForwardRefExoticComponent<TabsProps & React.RefAttributes<ImageLabel>> & {
    Tab: typeof Tab;
    Title: typeof TabTitle;
    Content: typeof TabContent;
};
declare const Tabs: TabsComponent;
export { Tabs };
