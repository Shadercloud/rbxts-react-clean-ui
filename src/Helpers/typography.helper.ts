import { ScaleSize, ScaleSizes } from "../Interfaces";
import { TypographyStyle, ScaledTypographyStyle, ThemeTemplate } from "../Theme";

export class TypographyHelper {
    public static getTypography(
        theme: ThemeTemplate,
        scale?: ScaleSize,
        component?: Partial<TypographyStyle> | ScaledTypographyStyle,
    ): TypographyStyle {
        const resolvedScale = scale ?? theme.default.scale;

        let typography: TypographyStyle = {
            ...theme.typography[theme.typeScaleMap[resolvedScale]],
        };

        if (component === undefined) {
            return typography;
        }

        const componentTypography = this.isScaledTypographyStyle(component)
            ? this.getClosestTypography(component, resolvedScale)
            : component;

        if (componentTypography !== undefined) {
            typography = {
                ...typography,
                ...componentTypography,
            };
        }

        return typography;
    }

    private static getClosestTypography(
        typography: ScaledTypographyStyle,
        scale: ScaleSize,
    ): Partial<TypographyStyle> | undefined {
        const scaleIndex = ScaleSizes.indexOf(scale);

        for (let index = scaleIndex; index >= 0; index--) {
            const value = typography[ScaleSizes[index]];

            if (value !== undefined) {
                return value;
            }
        }

        for (let index = scaleIndex + 1; index < ScaleSizes.size(); index++) {
            const value = typography[ScaleSizes[index]];

            if (value !== undefined) {
                return value;
            }
        }

        return undefined;
    }

    private static isScaledTypographyStyle(
        value: Partial<TypographyStyle> | ScaledTypographyStyle,
    ): value is ScaledTypographyStyle {
        for (const key of ScaleSizes) {
            if (key in value) {
                return true;
            }
        }

        return false;
    }

    public static toFontFace(font: Enum.Font, weight?: Enum.FontWeight, style?: Enum.FontStyle): Font {
        const resolvedWeight = weight ?? Enum.FontWeight.Regular;
        const resolvedStyle = style ?? Enum.FontStyle.Normal;
        const [success, family] = pcall(() => Font.fromEnum(font).Family);

        if (success && typeIs(family, "string") && family !== "") {
            return new Font(family, resolvedWeight, resolvedStyle);
        }

        return Font.fromName(font.Name, resolvedWeight, resolvedStyle);
    }
}