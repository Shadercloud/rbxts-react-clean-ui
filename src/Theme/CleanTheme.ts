import { CssShadow, CssSize, Breakpoint, BreakpointValue, ScaleSizeValue, ScaleSize, Intent, IconSet, TextVariant } from "../Interfaces/";

export interface TypographyStyle {
    font: Enum.Font;
    size: Enum.FontSize;
    weight?: Enum.FontWeight;
    lineHeight?: number;
}

export type ScaledTypographyStyle = Partial<Record<ScaleSize, Partial<TypographyStyle>>>

export interface IntentColors {
    text: Color3;
    textMuted?: Color3;
    background: Color3;
    hover: Color3;
    pressed: Color3;
    foreground: Color3;
    border: Color3;
}
export type InlineIntentColors = Partial<IntentColors>;

export interface CleanTheme {
    colors: {
        intents: Record<Intent, IntentColors>;
    };

    breakpoints: BreakpointValue<number>;

    default: {
        scale: ScaleSize;
        spacing: ScaleSize;
    },

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
        },
        boxShadow: {
            color: Color3;
            transparency: number
        },
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
            textColor?: Color3;
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
        };
    };

    icons: Partial<IconSet>;
    iconSize: ScaleSizeValue<number>;
}