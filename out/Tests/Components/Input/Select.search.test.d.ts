declare class SelectSearchValidation {
    emptyQueryListsAll(): void;
    nonAsciiIgnoresCase(query: string, expected: string): void;
    asciiIgnoresCase(query: string, expected: string): void;
    noMatchShowsNoResults(query: string): void;
    clearingRestoresAll(): void;
}
export = SelectSearchValidation;
