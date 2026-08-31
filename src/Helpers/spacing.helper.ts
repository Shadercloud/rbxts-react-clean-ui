import { CssPadding, PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue, ScaledCssPadding } from "../Interfaces";
import { ThemeTemplate } from "../Theme";
import { CssHelper } from "./css.helper";


export class SpacingHelper {
    // Tiers 1+2 collapsed to one pixel value for one scale key: the
    // component map overrides the global map per-key, falling back to the
    // global map for any key it doesn't define.
    public static GetPadding(theme: ThemeTemplate, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number {
        if (spacing === "None") return 0;

        const key = spacing ?? theme.default.spacing;
        return component?.[key] ?? theme.spacing[key] ?? 0;
    }

    // Full 4-tier resolution, merged per side. `defaultSpacing` lets a
    // caller (Card.Header/Footer) pin the active scale key instead of
    // following theme.default.spacing, preserving an existing default.
    public static GetResolvedPadding(
        theme: ThemeTemplate,
        props: PaddingProps,
        componentSpacing?: ScaleSizeValue<number>,
        componentPadding?: ScaledCssPadding,
        defaultSpacing?: ScaleSize
    ): ResolvedPadding {
        if (props.resolvedPadding !== undefined) return props.resolvedPadding;

        const isNone = props.spacing === "None";
        const key: ScaleSize = props.spacing !== undefined && props.spacing !== "None" ? props.spacing : (defaultSpacing ?? theme.default.spacing);

        // tier 3: a scale-indexed map picks the quad for the active key
        // (falling through to tiers 1/2 if that key isn't defined in the
        // map); a plain quad applies regardless of key.
        const quadForKey = isNone || componentPadding === undefined
            ? undefined
            : typeIs(componentPadding, "table")
                ? (componentPadding as ScaleSizeValue<CssPadding>)[key]
                : componentPadding as CssPadding;

        const base = quadForKey !== undefined
            ? CssHelper.parseCssQuad(quadForKey)
            : this.ResolveNumberPadding(isNone ? 0 : this.GetPadding(theme, key, componentSpacing));

        const instanceQuad = props.padding !== undefined ? CssHelper.parseCssQuad(props.padding) : undefined;

        return {
            top: props.top !== undefined ? this.GetPadding(theme, props.top, componentSpacing) : instanceQuad?.top ?? base.top,
            bottom: props.bottom !== undefined ? this.GetPadding(theme, props.bottom, componentSpacing) : instanceQuad?.bottom ?? base.bottom,
            left: props.left !== undefined ? this.GetPadding(theme, props.left, componentSpacing) : instanceQuad?.left ?? base.left,
            right: props.right !== undefined ? this.GetPadding(theme, props.right, componentSpacing) : instanceQuad?.right ?? base.right,
        };
    }

    public static ResolveNumberPadding(value: number): ResolvedPadding {
        return {
            top: value,
            bottom: value,
            left: value,
            right: value
        }
    }
}
