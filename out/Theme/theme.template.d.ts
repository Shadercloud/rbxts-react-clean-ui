import { CssShadow, CssSize, CssPadding, Breakpoint, BreakpointValue, ScaleSizeValue, ScaleSize, Intent, IconSet, TextVariant, PositionElementProps, CssBoxShadow } from "../Interfaces/";
import { TypographyStyle, ScaledTypographyStyle, IntentScheme, IntentColors, InlineIntentColors, CssBackgroundImage } from "./theme.style";
export interface ThemeTemplate {
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
        draggable: {
            placeholder: {
                backgroundColor: Color3;
                backgroundTransparency: number;
                borderColor: Color3;
                borderThickness: number;
                cornerRadius: CssSize;
            };
        };
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
            padding?: CssPadding;
            boxShadow?: CssShadow;
            backgroundImage?: CssBackgroundImage;
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
        accordion: {
            borderColor: Color3;
            borderThickness: number;
            cornerRadius: CssSize;
            spacing?: ScaleSizeValue<number>;
            header: {
                spacing?: ScaleSizeValue<number>;
                typography?: Partial<TypographyStyle> | ScaledTypographyStyle;
                intents?: Partial<Record<Intent, InlineIntentColors>>;
                indicatorSize: number;
                indicatorColor: Color3;
            };
            content: {
                spacing?: ScaleSizeValue<number>;
                backgroundColor: Color3;
                backgroundTransparency: number;
            };
            animation: {
                duration: number;
            };
        };
        card: {
            borderThickness: number;
            cornerRadius: CssSize;
            header: {
                spacing?: ScaleSizeValue<number>;
                intents?: Partial<Record<Intent, InlineIntentColors>>;
            };
            footer: {
                spacing?: ScaleSizeValue<number>;
                intents?: Partial<Record<Intent, InlineIntentColors>>;
            };
        };
        slider: {
            height: CssSize;
            bar: {
                height: CssSize;
                padding: CssSize;
                borderColor: Color3;
                borderThickness: number;
                cornerRadius: CssSize;
                backgroundColor: Color3;
                backgroundTransparency: number;
                highlight: {
                    borderColor: Color3;
                    backgroundColor: Color3;
                    backgroundTransparency: number;
                };
            };
            handle: {
                boxShadow?: CssShadow;
                borderColor: Color3;
                borderThickness: number;
                cornerRadius: CssSize;
                backgroundColor: Color3;
                backgroundTransparency: number;
                aspectRatio?: number;
            };
        };
        toast: {
            width: CssSize;
            fadeDuration: number;
            position?: PositionElementProps;
            intents?: Partial<Record<Intent, Partial<IntentScheme>>>;
            header: {
                typography?: Partial<TypographyStyle>;
            };
            body: {
                typography?: Partial<TypographyStyle>;
            };
            statusBar?: {
                position: "Top" | "Bottom";
                height: CssSize;
                intents?: Partial<Record<Intent, Partial<IntentScheme>>>;
            };
        };
        tooltip: {
            fadeDuration: number;
            pointerSize: number;
            spacing?: ScaleSizeValue<number>;
            boxShadow?: CssShadow;
            cornerRadius: CssSize;
            intents?: Partial<Record<Intent, Partial<IntentScheme>>>;
        };
        charts: {
            colors: Color3[];
            pie: {
                boxShadow?: CssBoxShadow;
                hoverDarken: number;
                labels: {
                    spacing?: ScaleSizeValue<number>;
                    backgroundColor?: Color3;
                    backgroundTransparency?: number;
                    typography?: Partial<TypographyStyle>;
                    borderColor?: Color3;
                    borderThickness?: number;
                    cornerRadius?: CssSize;
                };
            };
            bar: {
                spacing?: ScaleSizeValue<number>;
                unstackedTransparency: number;
                borderColor: Color3;
                borderThickness: number;
                cornerRadius: CssSize;
                tweenTime: number;
                axis: {
                    color: Color3;
                    transparency: number;
                    thickness: number;
                };
                xAxis: {
                    size: number;
                    spacing: number;
                    tickColor: Color3;
                    tickTransparency: number;
                    tickThickness: number;
                    tickSize: number;
                };
                yAxis: {
                    size: number;
                    spacing: number;
                    tickColor: Color3;
                    tickTransparency: number;
                    tickThickness: number;
                    tickSize: number;
                };
                gridLines: {
                    color: Color3;
                    transparency: number;
                    thickness: number;
                };
            };
        };
    };
    icons: Partial<IconSet>;
    iconSize: ScaleSizeValue<number>;
}
