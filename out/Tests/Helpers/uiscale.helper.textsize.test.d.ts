declare class UiScaleHelperTextSize {
    sizeMultiplies(size: number, scale: number, expected: number): void;
    exactCapPins(size: number, scale: number): void;
    aboveCapUndefined(size: number, scale: number): void;
    clampsBeforeScale(size: number, scale: number, expected: number): void;
    clampedThenCapped(size: number, scale: number): void;
    floorsAtOne(size: number, scale: number): void;
    rangeScales(minTextSize: number, maxTextSize: number, scale: number, expectedMin: number, expectedMax: number): void;
    rangeClampsEdges(minTextSize: number, maxTextSize: number, scale: number, expectedMin: number, expectedMax: number): void;
    rangeMaxFollowsMin(minTextSize: number, maxTextSize: number, scale: number, expected: number): void;
}
export = UiScaleHelperTextSize;
