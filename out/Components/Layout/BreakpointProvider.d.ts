import React from "@rbxts/react";
import { BreakPointElementProps } from "../../Interfaces/";
export interface BreakpointProviderProps extends BreakPointElementProps {
    name?: string;
    LayoutOrder?: number;
    children?: React.ReactNode;
}
export declare const BreakpointProvider: React.ForwardRefExoticComponent<BreakpointProviderProps & React.RefAttributes<Frame>>;
