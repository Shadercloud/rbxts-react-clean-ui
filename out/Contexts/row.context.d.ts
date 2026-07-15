import React from "@rbxts/react";
import { Breakpoint } from "../Interfaces/clean.element.props";
export interface RowContextValue {
    width: number;
    breakpoint: Breakpoint;
    padding: UDim;
    children: number;
}
export declare const RowContext: React.Context<RowContextValue>;
