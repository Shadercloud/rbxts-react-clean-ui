import React from "@rbxts/react";
import { Breakpoint } from "../Interfaces/clean.element.props";

export interface RowContextValue {
    width: number;
    breakpoint: Breakpoint;
    padding: UDim;
    children: number;
}

export const RowContext = React.createContext<RowContextValue>({
    width: 0,
    padding: new UDim(0, 0),
    breakpoint: "xl",
    children: 0,
});