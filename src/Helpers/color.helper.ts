import {
    ThemeTemplate,
    InlineIntentColors,
    IntentColors,
    IntentScheme,
    CssBackgroundImage,
    TypographyStyle,
} from "../Theme";
import { ButtonFlag, CssBackgroundGradient, Intent } from "../Interfaces";

type ComponentIntentColors =
    | Partial<Record<Intent, InlineIntentColors>>
    | Partial<Record<Intent, Partial<IntentScheme>>>;

export class ColorHelper {
    public static getIntentColors(
        theme: ThemeTemplate,
        intent: Intent | undefined,
        state: ButtonFlag = "default",
        componentColors?: ComponentIntentColors,
        overrideColors?: ComponentIntentColors,
    ): IntentScheme {
        const selectedIntent = intent ?? "primary";

        const defaultPrimary = theme.colors.intents.primary;
        const defaultMatching: IntentColors | undefined = theme.colors.intents[selectedIntent];

        const componentPrimary = componentColors?.primary;
        const componentMatching = componentColors?.[selectedIntent];

        const overridePrimary = overrideColors?.primary;
        const overrideMatching = overrideColors?.[selectedIntent];

        const layers: (Partial<IntentScheme> | undefined)[] = [
            defaultPrimary.default,
            defaultMatching?.default,

            defaultPrimary[state],
            defaultMatching?.[state],

            this.resolveComponentDefaultLayer(componentPrimary),
            this.resolveComponentDefaultLayer(componentMatching),

            this.resolveComponentStateLayer(componentPrimary, state),
            this.resolveComponentStateLayer(componentMatching, state),

            this.resolveComponentDefaultLayer(overridePrimary),
            this.resolveComponentDefaultLayer(overrideMatching),

            this.resolveComponentStateLayer(overridePrimary, state),
            this.resolveComponentStateLayer(overrideMatching, state),
        ];

        return this.mergeLayers(layers);
    }

    private static mergeLayers(layers: (Partial<IntentScheme> | undefined)[]): IntentScheme {
        let merged: Partial<IntentScheme> = {};
        let backgroundImage: Partial<CssBackgroundImage> | undefined;
        let backgroundGradient: Partial<CssBackgroundGradient> | undefined;
        let typography: Partial<TypographyStyle> | undefined;

        for (const layer of layers) {
            if (layer === undefined) {
                continue;
            }

            merged = { ...merged, ...layer };

            if (layer.backgroundImage !== undefined) {
                backgroundImage = { ...backgroundImage, ...layer.backgroundImage };
            }

            if (layer.backgroundGradient !== undefined) {
                const inheritedGradient =
                    layer.backgroundGradient.colors !== undefined
                        ? { ...backgroundGradient, stops: undefined }
                        : backgroundGradient;
                backgroundGradient = { ...inheritedGradient, ...layer.backgroundGradient };
            }

            if (layer.typography !== undefined) {
                typography = { ...typography, ...layer.typography };
            }
        }

        merged.backgroundImage = backgroundImage;
        merged.backgroundGradient = backgroundGradient;
        merged.typography = typography;

        return merged as IntentScheme;
    }

    private static resolveComponentDefaultLayer(
        colors: InlineIntentColors | Partial<IntentScheme> | undefined,
    ): Partial<IntentScheme> | undefined {
        if (colors === undefined) {
            return undefined;
        }

        if (this.isInlineIntentColors(colors)) {
            return colors.default;
        }

        return colors;
    }

    private static resolveComponentStateLayer(
        colors: InlineIntentColors | Partial<IntentScheme> | undefined,
        state: ButtonFlag,
    ): Partial<IntentScheme> | undefined {
        if (colors === undefined || !this.isInlineIntentColors(colors)) {
            return undefined;
        }

        return colors[state];
    }

    private static isInlineIntentColors(
        colors: InlineIntentColors | Partial<IntentScheme>,
    ): colors is InlineIntentColors {
        const statefulColors = colors as InlineIntentColors;

        return (
            statefulColors.default !== undefined ||
            statefulColors.hover !== undefined ||
            statefulColors.focus !== undefined
        );
    }
}