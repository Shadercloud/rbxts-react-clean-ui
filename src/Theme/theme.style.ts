import { Binding } from "@rbxts/react";
import { ScaleSize, CssShadow, ButtonFlag, CssDual, CssSliceInset, CssSize, CssRadius, CssCalcSize, CssBackgroundGradient } from "../Interfaces/";

export interface TypographyOutline {
    color?: Color3;
    thickness?: number;
    transparency?: number;
}

export interface TypographyStyle {
    font: Enum.Font;
    size: Enum.FontSize;
    weight?: Enum.FontWeight;
    lineHeight?: number;
    letterSpacing?: number;
    color?: Color3;
    transparency?: number;
    outline?: TypographyOutline;
}

export type ScaledTypographyStyle = Partial<Record<ScaleSize, Partial<TypographyStyle>>>

export interface IntentScheme {
    textColor: Color3;
    backgroundColor: Color3;
    borderColor: Color3;
    borderThickness?: number;
    backgroundTransparency?: number;
    boxShadow?: CssShadow;
    typography?: Partial<TypographyStyle>;
    backgroundImage?: Partial<CssBackgroundImage>;
    backgroundGradient?: Partial<CssBackgroundGradient>;
}

export interface IntentColors extends Partial<Record<ButtonFlag, IntentScheme>> {
    default: IntentScheme;
    hover?: IntentScheme;
    focus?: IntentScheme;
}
export type InlineIntentColors = {
    [State in keyof IntentColors]?: Partial<NonNullable<IntentColors[State]>>;
};

export interface CssBackgroundImage {
    image: string | number;
    slice?: CssSliceInset;
    size?: Enum.ScaleType | "Stretch" | "Slice" | "Tile" | "Fit" | "Crop" | Binding<Enum.ScaleType>;
    transparency?: number;
    tintColor?: Color3;
    tileSize?: CssDual;
    sliceScale?: number;
};

export interface CssPosition {
    position?: "static" | "absolute";
    top?: CssSize;
    left?: CssSize;
    right?: CssSize;
    bottom?: CssSize;
    center?: boolean | "x" | "y";
    zIndex?: number;
    width?: CssCalcSize;
}

export interface CssCornerRadius {
    topLeft?: CssRadius;
    topRight?: CssRadius;
    bottomLeft?: CssRadius;
    bottomRight?: CssRadius;
}

export interface FieldStateStyle {
    borderColor?: Color3;
    borderThickness?: number;
    backgroundColor?: Color3;
    backgroundTransparency?: number;
    backgroundGradient?: CssBackgroundGradient;
}

export type FieldStateStyles = Partial<Record<Exclude<ButtonFlag, "default">, FieldStateStyle>>;

export interface InnerShadowStyle {
    color: Color3;
    transparency: number;
    size: number;
}
