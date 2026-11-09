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
type ImageButtonEvents = React.InstanceEvent<ImageButton>;
interface HoverButtonProps extends BorderElementProps {
    default: HoverButtonStateProps;
    hover?: HoverButtonStateProps;
    focus?: HoverButtonStateProps;
    isSelected?: boolean;
    children?: React.ReactNode;
    name?: string;
    pressOn?: PressOn;
    onRelease?: PressReleaseCallback;
    Event?: ImageButtonEvents;
}
export declare const HoverButton: React.ForwardRefExoticComponent<HoverButtonProps & React.RefAttributes<ImageButton>>;
export {};
