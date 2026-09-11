declare class SliderMountValidation {
    mountsContained(): void;
    handleReflectsValue(value: number, fraction: number): void;
    respectsMinValue(): void;
    controlledFollowsProp(controlled: boolean, expectedFraction: number): void;
    rangeRendersTwoHandles(): void;
}
export = SliderMountValidation;
