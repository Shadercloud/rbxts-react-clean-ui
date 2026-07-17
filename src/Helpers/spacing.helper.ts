import { PaddingProps, ResolvedPadding, ScaleSize } from "../Interfaces";
import { CleanTheme } from "../Theme";


export class SpacingHelper {
    public static GetResolvedPadding(
        theme: CleanTheme,
        props: PaddingProps,
    ): ResolvedPadding {
        const amount = this.GetPadding(theme, props.spacing);

        return {
            top: props.top ? this.GetPadding(theme, props.top) : amount,
            bottom: props.bottom ? this.GetPadding(theme, props.bottom) : amount,
            left: props.left ? this.GetPadding(theme, props.left) : amount,
            right: props.right ? this.GetPadding(theme, props.right) : amount,
        };
    }
    
    public static GetPadding(theme: CleanTheme, spacing?: ScaleSize | "None"): number {
        if (spacing === "None") return 0

        const resolveSpacing = spacing !== undefined ? spacing : theme.default.spacing
        return theme.spacing[resolveSpacing] ?? 0
    }
}