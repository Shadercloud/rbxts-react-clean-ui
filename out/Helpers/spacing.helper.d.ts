import { PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue } from "../Interfaces";
import { CleanTheme } from "../Theme";
export declare class SpacingHelper {
    static GetResolvedPadding(theme: CleanTheme, props: PaddingProps, component?: ScaleSizeValue<number>): ResolvedPadding;
    static GetPadding(theme: CleanTheme, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number;
}
