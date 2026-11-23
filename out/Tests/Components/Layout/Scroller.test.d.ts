declare class ScrollerMountValidation {
    fillsHostByDefault(): void;
    shortContentContained(): void;
    canvasGrowsWithContent(): void;
    insetNone(stable: boolean): void;
    contentWidth(stable: boolean, childHeight: number, reserves: boolean): void;
    gutterCountedOnce(): void;
    stableGutterNarrows(): void;
    stableGutterSteady(): void;
    plainRef(): void;
    noConstraintWhenUnset(): void;
    wrapperClamped(): void;
}
export = ScrollerMountValidation;
