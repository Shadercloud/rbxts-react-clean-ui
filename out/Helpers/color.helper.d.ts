import { CleanTheme, InlineIntentColors, IntentScheme } from "../Theme";
import { ButtonFlag, Intent } from "../Interfaces";
export declare class ColorHelper {
    static getIntentColors(theme: CleanTheme, intent: Intent | undefined, state?: ButtonFlag, componentColors?: Partial<Record<Intent, InlineIntentColors>>): IntentScheme;
}
