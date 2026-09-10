import React from "@rbxts/react";
import { BreakPointElementProps, ResponsiveCssSize, ResponsiveValue, ScaleSize } from "../../Interfaces/";
export interface GridProps extends BreakPointElementProps {
    cols?: ResponsiveValue<number>;
    gap?: ScaleSize | "None";
    width?: ResponsiveCssSize;
    children?: React.ReactNode;
    name?: string;
}
export declare const Grid: React.ForwardRefExoticComponent<GridProps & React.RefAttributes<Frame>>;
