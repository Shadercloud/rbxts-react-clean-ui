import React from "@rbxts/react";
import { BorderElementProps } from "../../Interfaces";
import { PressOn, PressReleaseCallback } from "./Button.press";
export interface HoverButtonContextValue {
    hover: boolean;
    isSelected: boolean;
}
export declare const HoverButtonContext: React.Context<HoverButtonContextValue | undefined>;
type ImageButtonProps = React.InstanceProps<ImageButton>;
type HoverButtonStateProps = ImageButtonProps & BorderElementProps;
interface HoverButtonProps extends BorderElementProps {
    default: HoverButtonStateProps;
    hover?: HoverButtonStateProps;
    focus?: HoverButtonStateProps;
    isSelected?: boolean;
    children?: React.ReactNode;
    name?: string;
    pressOn?: PressOn;
    onRelease?: PressReleaseCallback;
}
export declare function HoverButton(propSet: HoverButtonProps): React.JSX.Element;
export {};
