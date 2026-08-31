import { ScaleSizeValue } from "./responsive.types";
export type CssUnit = "px" | "%";
export type CssSize = "Auto" | number | `${number}` | `${number}${CssUnit}`;
export type CssCalcSize = CssSize | `${number}% - ${number}px` | `${number}% + ${number}px`;
export type CssBreakpoint = {
    xs: number;
    sm: number;
    md: number;
    lg: number;
    xl: number;
};
export type CssBreakpointSize = {
    xs?: CssSize;
    sm?: CssSize;
    md?: CssSize;
    lg?: CssSize;
    xl?: CssSize;
};
export type CssDual = CssSize | `${CssSize} ${CssSize}`;
export type CssQuad = CssDual | `${CssSize} ${CssSize} ${CssSize}` | `${CssSize} ${CssSize} ${CssSize} ${CssSize}`;
export type CssShadow = CssQuad;
export type CssSliceInset = `${CssSize} ${CssSize}` | `${CssSize} ${CssSize} ${CssSize} ${CssSize}`;
export type CssBoxShadow = {
    shadow: CssShadow;
    color: Color3;
    transparency: number;
};
export type CssPadding = CssQuad;
export type ScaledCssPadding = CssPadding | ScaleSizeValue<CssPadding>;
export type ResponsiveCssSize = CssSize | CssBreakpointSize;
