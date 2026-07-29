import { CleanTheme, InlineIntentColors, IntentScheme } from "../Theme";
import { ButtonFlag, Intent } from "../Interfaces";
type ComponentIntentColors = Partial<Record<Intent, InlineIntentColors>> | Partial<Record<Intent, Partial<IntentScheme>>>;
export declare class ColorHelper {
    static getIntentColors(theme: CleanTheme, intent: Intent | undefined, state?: ButtonFlag, componentColors?: ComponentIntentColors): IntentScheme;
    private static resolveComponentColors;
    private static isInlineIntentColors;
}
export {};
