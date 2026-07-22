import React from "@rbxts/react";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
    Size?: UDim2;
}
export declare function Icon(props: IconProps): React.JSX.Element;
export {};
