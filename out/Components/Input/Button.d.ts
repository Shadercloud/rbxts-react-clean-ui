import React, { Component } from "@rbxts/react";
import { BackgroundElementProps, IconElementProps, IntentElementProps, ScalableElementProps, ShadowElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { IconProps } from "../Surface";
export interface ButtonProps extends SpacedElementProps, ShadowElementProps, ZIndexElementProps, BackgroundElementProps, IntentElementProps, ScalableElementProps, IconElementProps {
    text?: string;
    fontWeight?: Enum.FontWeight;
    Event?: React.InstanceEvent<ImageButton>;
    children?: React.ReactNode;
    group?: boolean;
}
export interface ButtonTextProps extends ScalableElementProps, IntentElementProps {
    children?: string;
    text: string;
}
declare function ButtonText(props: ButtonTextProps): React.JSX.Element;
export interface ButtonIconProps extends IconProps, IntentElementProps {
}
declare function ButtonIcon(props: ButtonIconProps): React.JSX.Element;
export declare class Button extends Component<ButtonProps> {
    static Text: typeof ButtonText;
    static Icon: typeof ButtonIcon;
    render(): React.ReactNode;
}
export {};
