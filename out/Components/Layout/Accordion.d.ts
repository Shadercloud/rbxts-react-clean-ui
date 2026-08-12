import React from "@rbxts/react";
import { IconName, ScalableElementProps } from "../../Interfaces";
interface AccordionItemProps {
    children?: React.ReactNode;
    value: string;
    disabled?: boolean;
}
declare function AccordionItem(_props: AccordionItemProps): undefined;
interface AccordionHeaderProps {
    children?: React.ReactNode | string;
    icon?: IconName;
    text?: string;
}
declare function AccordionHeader(_props: AccordionHeaderProps): undefined;
interface AccordionContentProps {
    children?: React.ReactNode;
    text?: string;
}
declare function AccordionContent(_props: AccordionContentProps): undefined;
export interface AccordionProps extends ScalableElementProps {
    children?: React.ReactNode;
    collapsible?: boolean;
    animationDuration?: number;
    defaultValue?: string;
    value?: string;
    onValueChange?: (value: string | undefined) => void;
}
type AccordionComponent = React.ForwardRefExoticComponent<AccordionProps & React.RefAttributes<Frame>> & {
    Item: typeof AccordionItem;
    Header: typeof AccordionHeader;
    Content: typeof AccordionContent;
};
declare const Accordion: AccordionComponent;
export { Accordion };
