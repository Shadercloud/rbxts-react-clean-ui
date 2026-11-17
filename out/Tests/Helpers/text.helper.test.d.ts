declare class TextHelperValidation {
    asciiMatchesLower(text: string): void;
    foldsAccentedLatin(text: string, expected: string): void;
    foldsGreek(text: string, expected: string): void;
    foldsCyrillic(text: string, expected: string): void;
    leavesExceptions(text: string): void;
    invalidLowersAscii(): void;
    complexScripts(text: string): void;
    simpleScripts(text: string): void;
    rangeBoundaries(codepoint: number, expected: boolean): void;
    validUtf8(text: string): void;
    invalidUtf8(text: string): void;
    asciiSplitsPerByte(text: string): void;
    emptySplitsEmpty(): void;
    invalidNotSplit(text: string): void;
    complexNotSplit(text: string): void;
}
export = TextHelperValidation;
