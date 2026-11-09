import React from "@rbxts/react";
import { BorderElementProps, CssPadding, CssRadius, PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CssBackgroundImage } from "../../Theme";
import { CssBackgroundGradient } from "../../Interfaces/";
export interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps, BorderElementProps, React.InstanceProps<ImageLabel> {
    group?: boolean;
    backgroundImage?: Partial<CssBackgroundImage>;
    backgroundGradient?: Partial<CssBackgroundGradient>;
    padding?: CssPadding;
    cornerRadius?: CssRadius;
    name?: string;
}
export declare const Container: React.ForwardRefExoticComponent<Omit<ContainerProps, "ref"> & React.RefAttributes<ImageLabel>>;
