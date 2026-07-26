import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
export interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps, React.InstanceProps<Frame> {
    group?: boolean;
}
export declare const Container: React.ForwardRefExoticComponent<Omit<ContainerProps, "ref"> & React.RefAttributes<Frame>>;
