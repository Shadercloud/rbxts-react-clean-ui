import React from "@rbxts/react";
import { IconElementProps, IntentElementProps, ScalableElementProps } from "../../Interfaces/";
export interface BadgeProps extends IntentElementProps, ScalableElementProps, IconElementProps {
    text: string;
    name?: string;
    LayoutOrder?: number;
    Position?: UDim2;
    AnchorPoint?: Vector2;
}
export declare const Badge: React.ForwardRefExoticComponent<BadgeProps & React.RefAttributes<ImageLabel>>;
