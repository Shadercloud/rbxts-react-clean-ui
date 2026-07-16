import React from "@rbxts/react";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
}
export declare function Icon(props: IconProps): React.JSX.Element | undefined;
export {};
