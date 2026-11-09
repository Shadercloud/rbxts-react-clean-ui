declare class TypographyFontFace {
    legacyFamily(font: Enum.Font, suffix: string): void;
    matchesFromName(font: Enum.Font, weight: Enum.FontWeight): void;
    keepsBold(): void;
    overridesBakedWeight(): void;
    defaultWeightAndStyle(): void;
    unknownFallsBack(): void;
}
export = TypographyFontFace;
