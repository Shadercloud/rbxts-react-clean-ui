import { CleanTheme, InlineIntentColors, IntentColors } from "../Theme";
import { Intent } from "../Interfaces";

type IntentColorKey = keyof IntentColors;

export class ColorHelper {
    public static getIntentColor(
        theme: CleanTheme,
        intent: Intent | undefined,
        key: IntentColorKey,
        componentColor?: Partial<Record<Intent, InlineIntentColors>>,
        propColor?: Color3,
        fallbackColor?: Color3,
    ): Color3 | undefined {
        if (propColor !== undefined)
            return propColor;


        const selectedIntent: Intent = intent ?? "primary";

        if (componentColor !== undefined && componentColor[selectedIntent] !== undefined && componentColor[selectedIntent]?.[key] !== undefined)
            return componentColor[selectedIntent][key]

        if (fallbackColor !== undefined)
            return fallbackColor

        return (
            theme.colors.intents[selectedIntent]?.[key] ??
            theme.colors.intents.primary[key]
        );
    }
}