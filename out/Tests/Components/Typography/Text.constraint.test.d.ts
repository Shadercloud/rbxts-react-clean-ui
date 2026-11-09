declare class TextSizeLimits {
    maxWidthConstraint(): void;
    maxWidthWraps(): void;
    shortKeepsNatural(): void;
    shrinkDropsMaxWidth(): void;
    shrinkKeepsMinWidth(): void;
    textSizeClamped(minTextSize: number, maxTextSize: number, expectedMin: number, expectedMax: number): void;
    textSizeDefaults(kind: string, value: number, expectedMin: number, expectedMax: number): void;
    spacedConstraintPerCharacter(): void;
    scaledCapped(): void;
}
export = TextSizeLimits;
