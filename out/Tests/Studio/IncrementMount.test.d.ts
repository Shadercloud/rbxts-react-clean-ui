declare class IncrementMountValidation {
    seedsDisplayedTextFromInitialValueWhenUncontrolled(): void;
    uncontrolledStateIgnoresSubsequentValueProps(): void;
    controlledStateReflectsUpdatedValueProp(): void;
    typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit(): void;
    outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange(): void;
}
export = IncrementMountValidation;
