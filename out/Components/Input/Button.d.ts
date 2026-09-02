import React from "@rbxts/react";
import { BackgroundElementProps, IconElementProps, IntentElementProps, ScalableElementProps, ShadowElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { IconProps } from "../Surface";
import { ThemeTemplate } from "../../Theme/theme.template";
export type ButtonStyleOverride = Partial<ThemeTemplate["components"]["button"]>;
export interface ButtonProps extends SpacedElementProps, ShadowElementProps, ZIndexElementProps, BackgroundElementProps, IntentElementProps, ScalableElementProps, IconElementProps {
    text?: string;
    fontWeight?: Enum.FontWeight;
    Event?: React.InstanceEvent<ImageButton>;
    children?: React.ReactNode;
    group?: boolean;
    disabled?: boolean;
    LayoutOrder?: number;
    styleOverride?: ButtonStyleOverride;
    name?: string;
}
export interface ButtonTextProps extends ScalableElementProps, IntentElementProps {
    children?: string;
    text: string;
    disabled?: boolean;
    styleOverride?: ButtonStyleOverride;
}
declare function ButtonText(props: ButtonTextProps): React.JSX.Element;
export interface ButtonIconProps extends IconProps, IntentElementProps {
    disabled?: boolean;
    styleOverride?: ButtonStyleOverride;
}
declare function ButtonIcon(props: ButtonIconProps): React.JSX.Element;
type ButtonComponent = React.ForwardRefExoticComponent<ButtonProps & React.RefAttributes<ImageButton>> & {
    Text: typeof ButtonText;
    Icon: typeof ButtonIcon;
};
declare const Button: ButtonComponent;
export { Button };
