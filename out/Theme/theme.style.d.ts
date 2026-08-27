import { Binding } from "@rbxts/react";
import { ScaleSize, CssShadow, ButtonFlag, CssDual, CssSliceInset } from "../Interfaces/";
export interface TypographyStyle {
    font: Enum.Font;
    size: Enum.FontSize;
    weight?: Enum.FontWeight;
    lineHeight?: number;
    letterSpacing?: number;
    color?: Color3;
    transparency?: number;
}
export type ScaledTypographyStyle = Partial<Record<ScaleSize, Partial<TypographyStyle>>>;
export interface IntentScheme {
    textColor: Color3;
    backgroundColor: Color3;
    borderColor: Color3;
    backgroundTransparency?: number;
    boxShadow?: CssShadow;
    typography?: Partial<TypographyStyle>;
    backgroundImage?: Partial<CssBackgroundImage>;
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
}
