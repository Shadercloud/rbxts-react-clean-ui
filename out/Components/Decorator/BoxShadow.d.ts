import React from "@rbxts/react";
import { CssBoxShadow, CssShadow, ShadowElementProps } from "../../Interfaces/";
interface BoxShadowProps extends ShadowElementProps {
    value?: CssShadow;
    completeShadow?: CssBoxShadow;
    color?: Color3;
    transparency?: number;
    zindex?: number;
    name?: string;
}
export declare function BoxShadow(props: BoxShadowProps): React.JSX.Element | undefined;
export {};
