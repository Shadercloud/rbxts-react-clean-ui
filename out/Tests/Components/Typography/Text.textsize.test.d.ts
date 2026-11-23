import { TextVariant } from "../../../Interfaces";
declare class TextPreferredTextSize {
    pinsVariant(variant: TextVariant, expected: number): void;
    offNoPin(): void;
    noProviderNoPin(): void;
    pinsTypographyOverride(): void;
    pinsSpacedChars(): void;
    spacedOffNoPin(): void;
    tracksVariant(): void;
    tracksSwitch(): void;
    scaledSkipped(): void;
    scaledKeepsBounds(): void;
    scaledBinding(): void;
    boundsReplaced(minTextSize: number, maxTextSize: number, expected: number): void;
    boundsKeptWhenOff(): void;
    spacedBoundsReplaced(): void;
    shrinkKeepsPin(): void;
}
export = TextPreferredTextSize;
