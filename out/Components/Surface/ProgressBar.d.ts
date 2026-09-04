import React from "@rbxts/react";
import { IntentElementProps, PositionElementProps, ScalableElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces";
export interface ProgressBarProps extends IntentElementProps, ScalableElementProps, SizeElementProps, PositionElementProps, ZIndexElementProps, React.InstanceProps<ImageLabel> {
    value: number;
    max?: number;
    label?: string;
    showValue?: boolean;
    valueFormatter?: (value: number, max: number) => string;
    name?: string;
    /** Overrides `theme.components.progressBar.fill.stripe.enabled`. */
    striped?: boolean;
    /** Overrides `theme.components.progressBar.fill.stripe.duration`. */
    stripeDuration?: number;
    /** Overrides `theme.components.progressBar.fill.stripe.direction`. `1` sweeps left-to-right, `-1` sweeps right-to-left; any other value is treated as `1`. */
    stripeDirection?: number;
}
export declare const ProgressBar: React.ForwardRefExoticComponent<Omit<ProgressBarProps, "ref"> & React.RefAttributes<ImageLabel>>;
