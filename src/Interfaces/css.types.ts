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

export type CssQuad =
    | CssSize
    | `${CssSize} ${CssSize}`
    | `${CssSize} ${CssSize} ${CssSize}`
    | `${CssSize} ${CssSize} ${CssSize} ${CssSize}`;

export type CssShadow = CssQuad;

export type CssBoxShadow = {
    shadow: CssShadow;
    color: Color3;
    transparency: number;
}

export type CssPadding = CssQuad;

export type ResponsiveCssSize = CssSize | CssBreakpointSize;
