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

export type ScaledTypographyStyle = Partial<Record<ScaleSize, Partial<TypographyStyle>>>

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
    image: string | number;                           // raw asset id number, or a full string (rbxassetid://..., rbxasset://..., etc)
    slice?: CssSliceInset;                             // absolute pixel corner coords, e.g. "12 288" or "12 12 288 288" — omit for a plain stretched image, no 9-slice
    size?: Enum.ScaleType | "Stretch" | "Slice" | "Tile" | "Fit" | "Crop" | Binding<Enum.ScaleType>; // ScaleType to use when slice is not set, default Enum.ScaleType.Stretch
    transparency?: number;
    tintColor?: Color3;
    tileSize?: CssDual;                                // CSS shorthand, e.g. "25%" or "25% 25%"; only takes effect when size resolves to Enum.ScaleType.Tile; ignored when slice is set (slice always forces Enum.ScaleType.Slice)
    sliceScale?: number;                               // maps directly to ImageLabel.SliceScale, default 1 (Roblox's own default) when unset; only has an effect when slice is set; the mechanism for rendering the 9-sliced border thicker/thinner than the slice region's literal source-image pixel size would otherwise produce
};