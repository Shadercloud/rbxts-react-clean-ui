declare class TextareaCaretLineText {
    restOfWord(text: string, cursor: number, expected: string): void;
    lineStart(): void;
    emptyText(): void;
    belowOne(cursor: number): void;
    multibyteWord(cursor: number): void;
}
export = TextareaCaretLineText;
