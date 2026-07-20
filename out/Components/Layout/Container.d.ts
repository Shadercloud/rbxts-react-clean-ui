import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps {
    BackgroundTransparency?: number;
    BackgroundColor3?: Color3;
    group?: boolean;
    children?: React.ReactNode;
    Change?: React.InstanceChangeEvent<Frame> | undefined;
}
export declare function Container(props: ContainerProps): React.JSX.Element;
export {};
