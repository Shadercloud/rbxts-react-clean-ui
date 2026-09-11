import { CssPadding, PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue, ScaledCssPadding } from "../Interfaces";
import { ThemeTemplate } from "../Theme";
import { CssHelper } from "./css.helper";


export class SpacingHelper {
    public static GetPadding(theme: ThemeTemplate, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number {
        if (spacing === "None") return 0;

        const key = spacing ?? theme.default.spacing;
        return component?.[key] ?? theme.spacing[key] ?? 0;
    }

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

    public static GetExplicitPadding(componentPadding: ScaledCssPadding | undefined, key: ScaleSize): ResolvedPadding | undefined {
        if (componentPadding === undefined) return undefined;

        const quad = typeIs(componentPadding, "table")
            ? (componentPadding as ScaleSizeValue<CssPadding>)[key]
            : componentPadding as CssPadding;

        return quad !== undefined ? CssHelper.parseCssQuad(quad) : undefined;
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
