import { ScaleSize, ScaleSizes } from "../Interfaces";
import { TypographyStyle, ScaledTypographyStyle, CleanTheme } from "../Theme";

export class TypographyHelper {
    public static getTypography(
        theme: CleanTheme,
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

        // Prefer the exact scale, then progressively smaller scales.
        for (let index = scaleIndex; index >= 0; index--) {
            const value = typography[ScaleSizes[index]];

            if (value !== undefined) {
                return value;
            }
        }

        // If no smaller scale exists, use the nearest larger scale.
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

}