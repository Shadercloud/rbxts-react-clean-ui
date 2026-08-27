import {
    ThemeTemplate,
    InlineIntentColors,
    IntentScheme,
    CssBackgroundImage,
    TypographyStyle,
} from "../Theme";
import { ButtonFlag, Intent } from "../Interfaces";

type ComponentIntentColors =
    | Partial<Record<Intent, InlineIntentColors>>
    | Partial<Record<Intent, Partial<IntentScheme>>>;

export class ColorHelper {
    public static getIntentColors(
        theme: ThemeTemplate,
        intent: Intent | undefined,
        state: ButtonFlag = "default",
        componentColors?: ComponentIntentColors,
    ): IntentScheme {
        const selectedIntent = intent ?? "primary";

        const defaultPrimary = theme.colors.intents.primary;
        const defaultMatching = theme.colors.intents[selectedIntent];

        const componentPrimary = componentColors?.primary;
        const componentMatching = componentColors?.[selectedIntent];

        const layers: (Partial<IntentScheme> | undefined)[] = [
            // Theme tier, `default` sub-layers (primary before matching)
            defaultPrimary.default,
            defaultMatching.default,

            // Theme tier, requested-state sub-layers (primary before matching)
            defaultPrimary[state],
            defaultMatching[state],

            // Component tier, `default` sub-layers (primary before matching)
            this.resolveComponentDefaultLayer(componentPrimary),
            this.resolveComponentDefaultLayer(componentMatching),

            // Component tier, requested-state sub-layers (primary before matching)
            this.resolveComponentStateLayer(componentPrimary, state),
            this.resolveComponentStateLayer(componentMatching, state),
        ];

        return this.mergeLayers(layers);
    }

    // Combines an ordered list of cascade layers (earliest = lowest precedence)
    // into a single IntentScheme. Most fields are last-wins/shallow-replace, but
    // `backgroundImage` and `typography` are nested objects where a later layer
    // should only override the fields it actually sets, inheriting the rest from
    // earlier layers instead of wiping the whole object out.
    private static mergeLayers(layers: (Partial<IntentScheme> | undefined)[]): IntentScheme {
        let merged: Partial<IntentScheme> = {};
        let backgroundImage: Partial<CssBackgroundImage> | undefined;
        let typography: Partial<TypographyStyle> | undefined;

        for (const layer of layers) {
            if (layer === undefined) {
                continue;
            }

            merged = { ...merged, ...layer };

            if (layer.backgroundImage !== undefined) {
                backgroundImage = { ...backgroundImage, ...layer.backgroundImage };
            }

            if (layer.typography !== undefined) {
                typography = { ...typography, ...layer.typography };
            }
        }

        merged.backgroundImage = backgroundImage;
        merged.typography = typography;

        return merged as IntentScheme;
    }

    // Extracts a component-theme intent entry's `default` sub-layer.
    // A direct Partial<IntentScheme> (no state variants) is always
    // applied here, since the requested state is ignored for it.
    private static resolveComponentDefaultLayer(
        colors: InlineIntentColors | Partial<IntentScheme> | undefined,
    ): Partial<IntentScheme> | undefined {
        if (colors === undefined) {
            return undefined;
        }

        if (this.isInlineIntentColors(colors)) {
            return colors.default;
        }

        return colors;
    }

    // Extracts a component-theme intent entry's requested-state sub-layer.
    // A direct Partial<IntentScheme> has no state variants, so it never
    // contributes a state layer (it's already applied by the default layer).
    private static resolveComponentStateLayer(
        colors: InlineIntentColors | Partial<IntentScheme> | undefined,
        state: ButtonFlag,
    ): Partial<IntentScheme> | undefined {
        if (colors === undefined || !this.isInlineIntentColors(colors)) {
            return undefined;
        }

        return colors[state];
    }

    private static isInlineIntentColors(
        colors: InlineIntentColors | Partial<IntentScheme>,
    ): colors is InlineIntentColors {
        const statefulColors = colors as InlineIntentColors;

        return (
            statefulColors.default !== undefined ||
            statefulColors.hover !== undefined ||
            statefulColors.focus !== undefined
        );
    }
}