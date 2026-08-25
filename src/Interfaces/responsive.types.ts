export type Breakpoint = "xs" | "sm" | "md" | "lg" | "xl";

export const ScaleSizes = ["xs", "sm", "md", "lg", "xl"] as const;

export type ScaleSize = typeof ScaleSizes[number];

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
