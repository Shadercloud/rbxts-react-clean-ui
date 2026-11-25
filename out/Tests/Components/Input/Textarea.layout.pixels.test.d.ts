declare class TextareaWholePixels {
    roundsUp(value: number, expected: number): void;
    badValues(value: number): void;
    snapsToContext(screen: number, design: number, context: number, expected: number): void;
    measuredRatio(): void;
    unmeasured(screen: number, design: number, context: number, expected: number): void;
}
export = TextareaWholePixels;
