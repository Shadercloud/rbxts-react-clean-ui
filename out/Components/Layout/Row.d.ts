import React from "@rbxts/react";
import { BreakPointElementProps, SpacedElementProps } from "../../Interfaces/";
interface RowProps extends SpacedElementProps, BreakPointElementProps {
    name?: string;
}
export declare const Row: React.ForwardRefExoticComponent<RowProps & React.RefAttributes<Frame>>;
export {};
