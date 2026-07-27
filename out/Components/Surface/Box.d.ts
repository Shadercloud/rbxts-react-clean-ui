import React from "@rbxts/react";
import { BackgroundElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
export interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps, SizeElementProps, React.InstanceProps<Frame> {
    'border-thickness'?: number;
    'border-color'?: Color3;
}
export declare const Box: React.ForwardRefExoticComponent<Omit<BoxProps, "ref"> & React.RefAttributes<Frame>>;
