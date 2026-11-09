import React from "@rbxts/react";
import { BackgroundElementProps, BorderElementProps, CssPadding, IconElementProps, IntentElementProps, ScalableElementProps } from "../../Interfaces/";
export interface BadgeStateStyle {
    backgroundColor?: Color3;
    backgroundTransparency?: number;
    textColor?: Color3;
    iconColor?: Color3;
    borderColor?: Color3;
}
export interface BadgeProps extends IntentElementProps, ScalableElementProps, IconElementProps, BackgroundElementProps, BorderElementProps {
    text: string;
    name?: string;
    LayoutOrder?: number;
    Position?: UDim2;
    AnchorPoint?: Vector2;
    textColor?: Color3;
    iconColor?: Color3;
    padding?: CssPadding;
    onClick?: () => void;
    hoverStyle?: BadgeStateStyle;
    pressStyle?: BadgeStateStyle;
}
export declare const Badge: React.ForwardRefExoticComponent<BadgeProps & React.RefAttributes<ImageLabel>>;
