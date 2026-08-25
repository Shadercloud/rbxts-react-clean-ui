import { ScaleSize, CssShadow, ButtonFlag } from "../Interfaces/";
export interface TypographyStyle {
    font: Enum.Font;
    size: Enum.FontSize;
    weight?: Enum.FontWeight;
    lineHeight?: number;
}
export type ScaledTypographyStyle = Partial<Record<ScaleSize, Partial<TypographyStyle>>>;
export interface IntentScheme {
    textColor: Color3;
    backgroundColor: Color3;
    borderColor: Color3;
    backgroundTransparency?: number;
    boxShadow?: CssShadow;
    typography?: Partial<TypographyStyle>;
}
export interface IntentColors extends Partial<Record<ButtonFlag, IntentScheme>> {
    default: IntentScheme;
    hover?: IntentScheme;
    focus?: IntentScheme;
}
export type InlineIntentColors = {
    [State in keyof IntentColors]?: Partial<NonNullable<IntentColors[State]>>;
};
