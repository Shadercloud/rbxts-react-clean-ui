import React from "@rbxts/react";
import { CssPixelSize, ScalableElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
export interface TextareaProps extends ScalableElementProps, SpacedElementProps, Omit<SizeElementProps, "Size" | "AutomaticSize" | "height">, Omit<React.InstanceProps<TextBox>, "Size" | "AutomaticSize"> {
    value: string;
    placeholder?: string;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
    controlled?: boolean;
    name?: string;
    disabled?: boolean;
    height?: CssPixelSize;
    rows?: number;
    maxLength?: number;
    showCount?: boolean;
}
export declare const Textarea: React.ForwardRefExoticComponent<Omit<TextareaProps, "ref"> & React.RefAttributes<TextBox>>;
