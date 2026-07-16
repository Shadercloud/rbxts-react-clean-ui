import { IconName } from "./icon";

export type CssUnit = "px" | "%";

export type Breakpoint = "xs" | "sm" | "md" | "lg" | "xl";

export const ScaleSizes = ["xs", "sm", "md", "lg", "xl"] as const;

export type ScaleSize = typeof ScaleSizes[number];

export type TextVariant =
    | "display"
    | "title"
    | "heading"
    | "body"
    | "label"
    | "caption";

export type Intent =
    | "primary"
    | "success"
    | "warning"
    | "danger"
    | "info";


export type GridSpan =
    | 1
    | 2
    | 3
    | 4
    | 5
    | 6
    | 7
    | 8
    | 9
    | 10
    | 11
    | 12;

export interface ResponsiveGridSpan {
    xs?: GridSpan;
    sm?: GridSpan;
    md?: GridSpan;
    lg?: GridSpan;
    xl?: GridSpan;
}

export type ResponsiveValue<T> =
    | T
    | Partial<Record<Breakpoint, T>>;

export interface BreakpointValue<T> {
    xs?: T;
    sm?: T;
    md?: T;
    lg?: T;
    xl?: T;
}

export interface ScaleSizeValue<T> {
    xs?: T;
    sm?: T;
    md?: T;
    lg?: T;
    xl?: T;
}


export type CssSize =
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

export type CssPadding = CssQuad;

export type ResponsiveCssSize = CssSize | CssBreakpointSize;

export interface ZIndexElementProps {
    ZIndex?: number;
}

export interface BackgroundElementProps {
    BackgroundTransparency?: number;
    BackgroundColor3?: Color3;
}

export interface SizeElementProps {
    Size?: UDim2;
    width?: ResponsiveCssSize;
    height?: CssSize;
    AutomaticSize?: Enum.AutomaticSize;

}

export interface ScalableElementProps {
    scale?: ScaleSize;
}

export interface PositionElementProps {
    Position?: UDim2;
    AnchorPoint?: Vector2;

    center?: CssSize;
    top?: CssSize;
    left?: CssSize;
    right?: CssSize;
    bottom?: CssSize;
}

export interface IntentElementProps {
    intent?: Intent
}

export interface CleanElementProps extends SizeElementProps, PositionElementProps {

}

export interface SpacedElementProps {
    spacing?: ScaleSize
}

export interface ShadowElementProps {
    "box-shadow"?: CssShadow;
    "box-shadow-color"?: Color3;
    "box-shadow-transparency"?: number;
}

export interface IconElementProps {
    icon?: IconName
}