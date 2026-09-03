import React from "@rbxts/react";
import { BackgroundElementProps, CssBackgroundGradient, PositionElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CssBackgroundImage } from "../../Theme";
export interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps, SizeElementProps, PositionElementProps, React.InstanceProps<ImageLabel> {
    'border-thickness'?: number;
    'border-color'?: Color3;
    'background-image'?: CssBackgroundImage;
    'background-gradient'?: CssBackgroundGradient;
    name?: string;
}
export declare const Box: React.ForwardRefExoticComponent<Omit<BoxProps, "ref"> & React.RefAttributes<ImageLabel>>;
