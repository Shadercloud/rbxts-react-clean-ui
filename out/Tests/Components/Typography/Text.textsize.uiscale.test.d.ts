import { TextVariant } from "../../../Interfaces";
declare class TextPreferredTextSizeUiScale {
    pinsScaled(scale: number, variant: TextVariant, size: number): void;
    pinsSpacedScaled(): void;
    nestedMultiplies(): void;
    tracksScale(): void;
    overCapNoPin(variant: TextVariant, scale: number): void;
    overrideOverCap(): void;
    exactCapPins(): void;
    overCapBounds(scale: number, minTextSize: number, maxTextSize: number, expectedMin: number, expectedMax: number): void;
    offBoundsScaled(): void;
    shrinkScaledPin(): void;
}
export = TextPreferredTextSizeUiScale;
