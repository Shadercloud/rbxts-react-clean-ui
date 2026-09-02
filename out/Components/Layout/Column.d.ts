import React from "@rbxts/react";
import { ResponsiveGridSpan } from "../../Interfaces/";
interface ColumnProps {
    span?: ResponsiveGridSpan | number | `${number}`;
    name?: string;
}
export declare const Column: React.ForwardRefExoticComponent<ColumnProps & React.RefAttributes<Frame>>;
export {};
