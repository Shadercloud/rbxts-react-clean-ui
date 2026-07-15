import { CleanTheme, InlineIntentColors, IntentColors } from "../Theme";
import { Intent } from "../Interfaces";
type IntentColorKey = keyof IntentColors;
export declare class ColorHelper {
    static getIntentColor(theme: CleanTheme, intent: Intent | undefined, key: IntentColorKey, componentColor?: Partial<Record<Intent, InlineIntentColors>>, propColor?: Color3, fallbackColor?: Color3): Color3 | undefined;
}
export {};
