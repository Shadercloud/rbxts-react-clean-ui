import { PaddingProps, ResolvedPadding, ScaleSize, ScaleSizeValue } from "../Interfaces";
import { CleanTheme } from "../Theme";


export class SpacingHelper {
    public static GetResolvedPadding(
        theme: CleanTheme,
        props: PaddingProps,
        component?: ScaleSizeValue<number>
    ): ResolvedPadding {
        const amount = this.GetPadding(theme, props.spacing, component);

        return {
            top: props.top ? this.GetPadding(theme, props.top) : amount,
            bottom: props.bottom ? this.GetPadding(theme, props.bottom) : amount,
            left: props.left ? this.GetPadding(theme, props.left) : amount,
            right: props.right ? this.GetPadding(theme, props.right) : amount,
        };
    }
    
    public static GetPadding(theme: CleanTheme, spacing?: ScaleSize | "None", component?: ScaleSizeValue<number>): number {
        if (spacing === "None") return 0

        const resolveSpacing = spacing !== undefined ? spacing : theme.default.spacing
        return component !== undefined ? component[resolveSpacing] ?? 0 : theme.spacing[resolveSpacing] ?? 0
    }
}