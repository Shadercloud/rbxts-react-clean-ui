import { PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue } from "../Interfaces";
import { ThemeTemplate } from "../Theme";
export declare class SpacingHelper {
    static GetResolvedPadding(theme: ThemeTemplate, props: PaddingProps, component?: ScaleSizeValue<number>): ResolvedPadding;
    static GetPadding(theme: ThemeTemplate, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number;
    static ResolveNumberPadding(value: number): ResolvedPadding;
}
