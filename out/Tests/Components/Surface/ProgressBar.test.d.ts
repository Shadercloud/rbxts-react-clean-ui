declare class ProgressBarMountValidation {
    fillFraction(variant: string, value: number, max: number, fraction: number): void;
    defaultTrackSize(): void;
    widthOnlyKeepsHeight(): void;
    heightOnlyFullWidth(): void;
    fillContained(): void;
    headerLabelAndValue(): void;
}
export = ProgressBarMountValidation;
