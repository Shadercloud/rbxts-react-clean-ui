import React from "@rbxts/react";
import { ButtonFlag, CssBoxShadow, CssRadius, CssShadow } from "../../Interfaces";
import { FieldStateStyle, FieldStateStyles, InnerShadowStyle } from "../../Theme";
export declare function resolveFieldState(disabled: boolean | undefined, focused: boolean, hovered: boolean): ButtonFlag;
export declare function resolveFieldStateStyle(states: FieldStateStyles | undefined, state: ButtonFlag): FieldStateStyle;
interface FieldBoxShadowProps {
    value?: CssShadow | CssBoxShadow;
    name?: string;
}
export declare function FieldBoxShadow(props: FieldBoxShadowProps): React.JSX.Element | undefined;
interface FieldInnerShadowProps {
    value: InnerShadowStyle;
    cornerRadius?: CssRadius;
    inset: number;
}
export declare function FieldInnerShadow(props: FieldInnerShadowProps): React.JSX.Element;
export {};
