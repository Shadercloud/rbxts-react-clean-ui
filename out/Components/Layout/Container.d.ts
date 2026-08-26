import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CssBackgroundImage } from "../../Theme";
export interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps, React.InstanceProps<ImageLabel> {
    group?: boolean;
    backgroundImage?: CssBackgroundImage;
}
export declare const Container: React.ForwardRefExoticComponent<Omit<ContainerProps, "ref"> & React.RefAttributes<ImageLabel>>;
