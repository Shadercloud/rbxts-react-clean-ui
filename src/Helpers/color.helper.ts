import {
    CleanTheme,
    InlineIntentColors,
    IntentScheme,
} from "../Theme";
import { ButtonFlag, Intent } from "../Interfaces";

export class ColorHelper {
    public static getIntentColors(
        theme: CleanTheme,
        intent: Intent | undefined,
        state: ButtonFlag = "default",
        componentColors?: Partial<Record<Intent, InlineIntentColors>>,
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
            ...(componentPrimary?.default ?? {}),
            ...(componentPrimary?.[state] ?? {}),

            // 1. Component theme, matching intent
            ...(componentMatching?.default ?? {}),
            ...(componentMatching?.[state] ?? {}),
        };
    }
}