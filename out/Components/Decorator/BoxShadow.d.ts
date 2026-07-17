import React from "@rbxts/react";
import { CssShadow, ShadowElementProps } from "../../Interfaces/";
interface BoxShadowProps extends ShadowElementProps {
    value?: CssShadow;
    color?: Color3;
    transparency?: number;
    zindex?: number;
}
export declare function BoxShadow(props: BoxShadowProps): React.JSX.Element | undefined;
export {};
