import React, { Binding } from "@rbxts/react";
import { ContainerProps } from "./Container";
interface FlexItemProps extends ContainerProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>;
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>;
    GrowRatio?: number;
    ShrinkRatio?: number;
}
export declare const FlexItem: React.ForwardRefExoticComponent<Omit<FlexItemProps, "ref"> & React.RefAttributes<Frame>>;
export {};
