import { CssShadow, CssSize, Breakpoint, BreakpointValue, ScaleSizeValue, ScaleSize, Intent, IconSet, TextVariant, ButtonFlag } from "../Interfaces/";
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
export interface CleanTheme {
    colors: {
        intents: Record<Intent, IntentColors>;
    };
    breakpoints: BreakpointValue<number>;
    default: {
        scale: ScaleSize;
        spacing: ScaleSize;
    };
    spacing: ScaleSizeValue<number>;
    radius: {
        sm: number;
        md: number;
        lg: number;
        default: Breakpoint;
    };
    typography: {
        display: TypographyStyle;
        title: TypographyStyle;
        heading: TypographyStyle;
        body: TypographyStyle;
        label: TypographyStyle;
        caption: TypographyStyle;
    };
    typeScaleMap: Record<ScaleSize, TextVariant>;
    components: {
        scroller: {
            barColor: Color3;
        };
        boxShadow: {
            color: Color3;
            transparency: number;
        };
        box: {
            backgroundColor: Color3;
            backgroundTransparency: number;
            borderColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            boxShadow?: CssShadow;
            intents?: Partial<Record<Intent, InlineIntentColors>>;
        };
        button: {
            backgroundTransparency: number;
            cornerRadius: CssSize;
            boxShadow?: CssShadow;
            borderThickness: number;
            typography?: Partial<TypographyStyle> | ScaledTypographyStyle;
            intents?: Partial<Record<Intent, InlineIntentColors>>;
        };
        input: {
            borderColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            typography?: Partial<TypographyStyle> | ScaledTypographyStyle;
        };
        select: {
            borderColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            dropDownBackgroundColor: Color3;
            typography?: Partial<TypographyStyle> | ScaledTypographyStyle;
            intents?: Partial<Record<Intent, InlineIntentColors>>;
            maxDropDownHeight: number;
        };
        checkbox: {
            borderColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            intents?: Partial<Record<Intent, InlineIntentColors>>;
            spacing?: ScaleSizeValue<number>;
        };
        tabs: {
            borderColor: Color3;
            backgroundColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            spacing?: ScaleSizeValue<number>;
            list: {
                borderColor?: Color3;
                backgroundColor?: Color3;
                borderThickness: number;
                cornerRadius: CssSize;
                spacing?: ScaleSizeValue<number>;
            };
            button: {
                borderThickness: number;
                cornerRadius: CssSize;
                spacing?: ScaleSizeValue<number>;
                boxShadow?: CssShadow;
                typography?: Partial<TypographyStyle> | ScaledTypographyStyle;
                intents?: Partial<Record<Intent, InlineIntentColors>>;
            };
        };
    };
    icons: Partial<IconSet>;
    iconSize: ScaleSizeValue<number>;
}
