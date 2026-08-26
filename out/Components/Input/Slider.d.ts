import React from "@rbxts/react";
import { ContainerProps } from "../Layout";
type SliderValue = number | Vector2;
type HighlightOption = "start" | "end" | "middle";
export interface SliderProps extends Omit<ContainerProps, keyof React.InstanceProps<ImageLabel>>, React.InstanceProps<Frame> {
    "max-value": number;
    "min-value"?: number;
    value?: SliderValue;
    step?: number;
    onDragged?: (value: SliderValue) => void;
    onChanged?: (value: SliderValue) => void;
    controlled?: boolean;
    range?: boolean;
    highlight?: HighlightOption;
}
export declare const Slider: React.ForwardRefExoticComponent<Omit<SliderProps, "ref"> & React.RefAttributes<Frame>>;
export {};
