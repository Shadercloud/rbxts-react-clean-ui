import { PaddingProps, ResolvedPadding, ScaleSize } from "../Interfaces";
import { CleanTheme } from "../Theme";
export declare class SpacingHelper {
    static GetResolvedPadding(theme: CleanTheme, props: PaddingProps): ResolvedPadding;
    static GetPadding(theme: CleanTheme, spacing?: ScaleSize | "None"): number;
}
