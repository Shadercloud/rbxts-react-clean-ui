import React from "@rbxts/react";
import { CssSize, IconElementProps, PositionElementProps, ScalableElementProps, ZIndexElementProps } from "../../Interfaces";
export interface RadialMenuItem extends IconElementProps {
    value: string;
    text?: string;
    description?: string;
}
export interface RadialMenuPlaceholder extends IconElementProps {
    text?: string;
    description?: string;
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
