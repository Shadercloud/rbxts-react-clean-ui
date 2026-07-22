import React, { Binding } from "@rbxts/react";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
export interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
    Size?: UDim2;
    spinning?: boolean;
    speed?: number;
    Rotation?: number | Binding<number>;
}
export declare function Icon(props: IconProps): React.JSX.Element;
