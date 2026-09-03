import { ScaleSizeValue } from "./responsive.types";

export type CssUnit = "px" | "%";

export type CssSize =
    | "Auto"
    | number
    | `${number}`
    | `${number}${CssUnit}`;

// The one CSS calc() shape supported on top of CssSize: a percent term
// plus/minus a pixel term (e.g. "100% - 50px"), which maps directly onto
// UDim(scale, offset) — no general calc() parser needed for anything beyond
// this two-term form. Deliberately kept as its own type rather than folded
// directly into CssSize: CssSize is composed multiple times over in CssQuad/
// CssDual (a 4-term CssQuad is `${CssSize} ${CssSize} ${CssSize} ${CssSize}`),
// so widening CssSize itself multiplies out through every one of those
// combinations — doing so was observed to blow past TypeScript's template-
// literal complexity limit ("union type that is too complex to represent")
// at unrelated call sites that spread a large props object containing
// several CssQuad-shaped fields (e.g. Button.tsx's `<BoxShadow {...props} />`).
// Use CssCalcSize only where a calc() term is actually needed (currently
// just CssPosition.width) rather than everywhere CssSize appears.
export type CssCalcSize =
    | CssSize
    | `${number}% - ${number}px`
    | `${number}% + ${number}px`;

export type CssBreakpoint = {
    xs: number
    sm: number
    md: number
    lg: number
    xl: number
}

export type CssBreakpointSize = {
    xs?: CssSize;
    sm?: CssSize;
    md?: CssSize;
    lg?: CssSize;
    xl?: CssSize;
};

export type CssDual =
    | CssSize
    | `${CssSize} ${CssSize}`;

export type CssQuad =
    | CssDual
    | `${CssSize} ${CssSize} ${CssSize}`
    | `${CssSize} ${CssSize} ${CssSize} ${CssSize}`;

export type CssShadow = CssQuad;

// absolute pixel corner coordinates for Rect.new(minX, minY, maxX, maxY)-style slicing,
// e.g. Roblox's SliceCenter — not a CSS border-image-slice edge-inset shorthand, since
// Roblox has no intrinsic-image-size equivalent to derive corners from an inset alone
export type CssSliceInset =
    | `${CssSize} ${CssSize}`
    | `${CssSize} ${CssSize} ${CssSize} ${CssSize}`;

export type CssBoxShadow = {
    shadow: CssShadow;
    color: Color3;
    transparency: number;
}

export type CssPadding = CssQuad;

// A CssPadding quad, or a scale-key-indexed map of quads (e.g. a component's
// theme.components.X.padding tier, which can pick a different quad shape per
// spacing scale key the same way theme.components.X.spacing does for the
// numeric tier).
export type ScaledCssPadding = CssPadding | ScaleSizeValue<CssPadding>;

export type ResponsiveCssSize = CssSize | CssBreakpointSize;

export type CssBackgroundGradient = {
    colors: Color3[] | ColorSequence;
    stops?: number[]; // Stops are ignored when colors is a ColorSequence, since ColorSequence already has its own stop positions
    rotation?: number;
    offset?: Vector2;
    transparency?: number | NumberSequence;
}