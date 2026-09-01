import { PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue, ScaledCssPadding } from "../Interfaces";
import { ThemeTemplate } from "../Theme";
export declare class SpacingHelper {
    static GetPadding(theme: ThemeTemplate, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number;
    static GetResolvedPadding(theme: ThemeTemplate, props: PaddingProps, componentSpacing?: ScaleSizeValue<number>, componentPadding?: ScaledCssPadding, defaultSpacing?: ScaleSize): ResolvedPadding;
    static GetExplicitPadding(componentPadding: ScaledCssPadding | undefined, key: ScaleSize): ResolvedPadding | undefined;
    static ResolveNumberPadding(value: number): ResolvedPadding;
}
