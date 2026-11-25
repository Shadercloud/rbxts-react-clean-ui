declare class TextareaCanvasTolerance {
    scaledTolerance(scale: number, content: number, expected: number): void;
    threeQuarterTolerance(): void;
    badScale(scale: number): void;
    fourArgsMatch(textHeight: number): void;
    fourArgsValues(): void;
}
export = TextareaCanvasTolerance;
