export type TooltipPlacement = "Top" | "Bottom" | "Left" | "Right" | "Center" | "Auto";
export type TooltipSide = "Top" | "Bottom" | "Left" | "Right" | "Center";
export interface TooltipRect {
    left: number;
    top: number;
    right: number;
    bottom: number;
}
export interface TooltipSize {
    width: number;
    height: number;
}
export interface TooltipPoint {
    x: number;
    y: number;
}
export interface TooltipInsets {
    top: number;
    bottom: number;
    left: number;
    right: number;
}
export interface TooltipPointerLayout {
    anchor: TooltipPoint;
    scale: TooltipPoint;
    offset: TooltipPoint;
    rotation: number;
}
export interface TooltipLayoutInput {
    target: TooltipRect;
    content: TooltipSize;
    bounds: TooltipRect;
    placement?: TooltipPlacement;
    pointerSize: number;
    shadow: TooltipInsets;
    cornerRadius?: number;
}
export interface TooltipLayout {
    side: TooltipSide;
    anchor: TooltipPoint;
    position: TooltipPoint;
    size: TooltipSize;
    padding: TooltipInsets;
    pointer?: TooltipPointerLayout;
}
export declare function getTooltipSafeArea(overlay: TooltipSize, edgeMargin: number, topbarBottom: number): TooltipRect;
export declare function getTooltipPadding(side: TooltipSide, pointerSize: number, shadow: TooltipInsets): TooltipInsets;
export declare function resolveTooltipSide(input: TooltipLayoutInput): TooltipSide;
export declare function computeTooltipLayout(input: TooltipLayoutInput): TooltipLayout;
