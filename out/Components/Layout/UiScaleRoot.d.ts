import React from "@rbxts/react";
import { ZIndexElementProps } from "../../Interfaces";
export interface UiScaleRootProps extends ZIndexElementProps {
    scale: number;
    name?: string;
    children?: React.ReactNode;
}
export declare const UiScaleRoot: React.ForwardRefExoticComponent<UiScaleRootProps & React.RefAttributes<Frame>>;
