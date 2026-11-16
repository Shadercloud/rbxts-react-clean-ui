import React from "@rbxts/react";
import { CssSize, IconElementProps, PositionElementProps, ScalableElementProps, ZIndexElementProps } from "../../Interfaces";
export interface RadialMenuItemState {
    selected: boolean;
    hovered: boolean;
}
export type RadialMenuContent = React.ReactNode | ((state: RadialMenuItemState) => React.ReactNode);
export interface RadialMenuItem extends IconElementProps {
    value: string;
    text?: string;
    description?: string;
    content?: RadialMenuContent;
    centerContent?: RadialMenuContent;
}
export interface RadialMenuPlaceholder extends IconElementProps {
    text?: string;
    description?: string;
    centerContent?: React.ReactNode;
}
export interface RadialMenuProps extends ScalableElementProps, ZIndexElementProps, Pick<PositionElementProps, "Position" | "AnchorPoint"> {
    items: RadialMenuItem[];
    value?: string;
    defaultValue?: string;
    onValueChange?: (value: string, item: RadialMenuItem) => void;
    size?: CssSize;
    thickness?: CssSize;
    showLabels?: boolean;
    placeholder?: RadialMenuPlaceholder;
    LayoutOrder?: number;
    name?: string;
}
declare const RadialMenu: React.ForwardRefExoticComponent<RadialMenuProps & React.RefAttributes<Frame>>;
export { RadialMenu };
