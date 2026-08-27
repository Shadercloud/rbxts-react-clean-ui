import { ThemeTemplate, InlineIntentColors, IntentScheme } from "../Theme";
import { ButtonFlag, Intent } from "../Interfaces";
type ComponentIntentColors = Partial<Record<Intent, InlineIntentColors>> | Partial<Record<Intent, Partial<IntentScheme>>>;
export declare class ColorHelper {
    static getIntentColors(theme: ThemeTemplate, intent: Intent | undefined, state?: ButtonFlag, componentColors?: ComponentIntentColors, overrideColors?: ComponentIntentColors): IntentScheme;
    private static mergeLayers;
    private static resolveComponentDefaultLayer;
    private static resolveComponentStateLayer;
    private static isInlineIntentColors;
}
export {};
