declare class TextLetterSpacing {
    labelPerGrapheme(text: string, expected: string): void;
    asciiStructureUnchanged(): void;
    asciiGapMatchesSpacing(): void;
    complexScriptStaysWhole(text: string): void;
}
export = TextLetterSpacing;
