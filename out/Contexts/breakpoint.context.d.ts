import React from "@rbxts/react";
import { Breakpoint, ResponsiveValue } from "../Interfaces/responsive.types";
export interface BreakpointContextValue {
    width: number;
    breakpoint: Breakpoint;
}
export declare const BreakpointContext: React.Context<BreakpointContextValue | undefined>;
export declare function useBreakpoint(): Breakpoint;
export declare function useBreakpointValue<T>(value: ResponsiveValue<T> | undefined): T | undefined;
