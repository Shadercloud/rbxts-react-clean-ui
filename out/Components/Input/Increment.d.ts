import React from "@rbxts/react";
import { IntentElementProps, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
export interface IncrementProps extends ScalableElementProps, SpacedElementProps, IntentElementProps, React.InstanceProps<Frame> {
    value: number;
    onChange?: (value: number) => void;
    step?: number;
    min?: number;
    max?: number;
    controlled?: boolean;
}
export declare const Increment: React.ForwardRefExoticComponent<Omit<IncrementProps, "ref"> & React.RefAttributes<Frame>>;
