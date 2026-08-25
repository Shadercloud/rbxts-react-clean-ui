import {
    ThemeTemplate,
    InlineIntentColors,
    IntentScheme,
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

        return {
            // 4. Default theme, primary intent
            ...defaultPrimary.default,
            ...(defaultPrimary[state] ?? {}),

            // 3. Default theme, matching intent
            ...defaultMatching.default,
            ...(defaultMatching[state] ?? {}),

            // 2. Component theme, primary intent
            ...this.resolveComponentColors(componentPrimary, state),

            // 1. Component theme, matching intent
            ...this.resolveComponentColors(componentMatching, state),
        };
    }

    private static resolveComponentColors(
        colors: InlineIntentColors | Partial<IntentScheme> | undefined,
        state: ButtonFlag,
    ): Partial<IntentScheme> {
        if (colors === undefined) {
            return {};
        }

        if (this.isInlineIntentColors(colors)) {
            return {
                ...(colors.default ?? {}),
                ...(colors[state] ?? {}),
            };
        }

        // A direct Partial<IntentScheme> has no state variants,
        // so the requested state is ignored.
        return colors;
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