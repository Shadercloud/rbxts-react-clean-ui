import React from "@rbxts/react";
import { Breakpoint } from "../Interfaces/responsive.types";
export interface RowContextValue {
    width: number;
    breakpoint: Breakpoint;
    padding: UDim;
    children: number;
}
export declare const RowContext: React.Context<RowContextValue>;
