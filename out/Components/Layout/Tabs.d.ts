import React from "@rbxts/react";
import { CssBackgroundGradient, PaddingProps, ScalableElementProps } from "../../Interfaces";
import { CssBackgroundImage } from "../../Theme";
interface TabTitleProps extends PaddingProps {
    value: string;
    text: string;
}
declare function TabTitle(props: TabTitleProps): React.JSX.Element;
interface TabContentProps {
    value: string;
    children?: React.ReactNode;
}
declare function TabContent(props: TabContentProps): React.JSX.Element;
interface TabsListProps extends ScalableElementProps {
    children?: React.ReactNode;
}
declare const TabsList: React.ForwardRefExoticComponent<TabsListProps & React.RefAttributes<ImageLabel>>;
interface TabsBodyProps extends ScalableElementProps {
    backgroundImage?: CssBackgroundImage;
    backgroundGradient?: CssBackgroundGradient;
    children?: React.ReactNode;
}
declare const TabsBody: React.ForwardRefExoticComponent<TabsBodyProps & React.RefAttributes<ImageLabel>>;
export interface TabsProps {
    children?: React.ReactNode;
    defaultValue?: string;
}
type TabsComponent = React.ForwardRefExoticComponent<TabsProps & React.RefAttributes<Frame>> & {
    List: typeof TabsList;
    Body: typeof TabsBody;
    Title: typeof TabTitle;
    Content: typeof TabContent;
};
declare const Tabs: TabsComponent;
export { Tabs };
