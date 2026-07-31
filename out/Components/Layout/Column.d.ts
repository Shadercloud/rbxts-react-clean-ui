import React from "@rbxts/react";
import { ResponsiveGridSpan } from "../../Interfaces/";
interface ColumnProps {
    span?: ResponsiveGridSpan | number | `${number}`;
}
export declare const Column: React.ForwardRefExoticComponent<ColumnProps & React.RefAttributes<Frame>>;
export {};
