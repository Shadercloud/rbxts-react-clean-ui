import { Binding } from "@rbxts/react";
import { ScaleSize, CssShadow, ButtonFlag, CssDual, CssSliceInset, CssSize, CssCalcSize } from "../Interfaces/";

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

export interface CssPosition {
    position?: "static" | "absolute";   // mirrors the CSS `position` property; "absolute" removes the element from normal flow and positions it relative to its container. Defaults to "static" (stays in the normal in-flow layout).
    top?: CssSize;
    left?: CssSize;
    right?: CssSize;
    bottom?: CssSize;
    center?: boolean | "x" | "y";       // CSS-style auto-centering convenience already used elsewhere in this codebase (see `center` on PositionElementProps); `true` centers both axes, "x"/"y" centers only that axis while top/left/right/bottom still apply to the other axis
    zIndex?: number;
    width?: CssCalcSize;                // fixed/relative width (height stays auto-sized to content), e.g. "100% - 50px"; only meaningful when `position` is `"absolute"` — an in-flow (`"static"`) header/footer ignores it, since VStack's default Fill flex re-stretches every in-flow child to the list's full width regardless of its own Size. When omitted but both `left` and `right` are set, a width is implied automatically as `100% - left - right`, mirroring standard CSS absolute-positioning behavior — explicit `width` always wins if both are somehow set
}