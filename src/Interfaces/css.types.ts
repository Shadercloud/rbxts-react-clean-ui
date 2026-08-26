export type CssUnit = "px" | "%";

export type CssSize =
    | "Auto"
    | number
    | `${number}`
    | `${number}${CssUnit}`;

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

export type ResponsiveCssSize = CssSize | CssBreakpointSize;
