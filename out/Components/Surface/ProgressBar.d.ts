import React from "@rbxts/react";
import { IntentElementProps, PositionElementProps, ScalableElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces";
export interface ProgressBarProps extends IntentElementProps, ScalableElementProps, SizeElementProps, PositionElementProps, ZIndexElementProps, React.InstanceProps<ImageLabel> {
    value: number;
    max?: number;
    label?: string;
    showValue?: boolean;
    valueFormatter?: (value: number, max: number) => string;
    name?: string;
    striped?: boolean;
    stripeDuration?: number;
    stripeDirection?: number;
}
export declare const ProgressBar: React.ForwardRefExoticComponent<Omit<ProgressBarProps, "ref"> & React.RefAttributes<ImageLabel>>;
