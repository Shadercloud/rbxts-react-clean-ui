import { ScaleSize } from "../Interfaces";
import { TypographyStyle, ScaledTypographyStyle, ThemeTemplate } from "../Theme";
export declare class TypographyHelper {
    static getTypography(theme: ThemeTemplate, scale?: ScaleSize, component?: Partial<TypographyStyle> | ScaledTypographyStyle): TypographyStyle;
    private static getClosestTypography;
    private static isScaledTypographyStyle;
}
