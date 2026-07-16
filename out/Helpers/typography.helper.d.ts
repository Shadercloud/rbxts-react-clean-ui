import { ScaleSize } from "../Interfaces";
import { TypographyStyle, ScaledTypographyStyle, CleanTheme } from "../Theme";
export declare class TypographyHelper {
    static getTypography(theme: CleanTheme, scale?: ScaleSize, component?: Partial<TypographyStyle> | ScaledTypographyStyle): TypographyStyle;
    private static getClosestTypography;
    private static isScaledTypographyStyle;
}
