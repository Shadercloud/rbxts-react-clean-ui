declare class UiScaleHookValidation {
    defaultScale(): void;
    rootScale(scale: number): void;
    nestedMultiply(outer: number, inner: number, expected: number): void;
    viewportUnscaled(): void;
    viewportDivided(scale: number): void;
    viewportFollowsScale(): void;
}
export = UiScaleHookValidation;
