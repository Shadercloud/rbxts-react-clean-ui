declare class IncrementStepValidation {
    incrementsByDefaultStepWithNoBounds(): void;
    decrementsByDefaultStepWithNoBounds(): void;
    incrementsByCustomStepWithNoBounds(): void;
    decrementsByCustomStepWithNoBounds(): void;
    incrementingPastMaxClampsToMax(): void;
    decrementingPastMinClampsToMin(): void;
    incrementingWhenAlreadyAtMaxReturnsUndefined(): void;
    decrementingWhenAlreadyAtMinReturnsUndefined(): void;
    repeatedDecimalStepIncrementsLandOnExactValue(): void;
    repeatedDecimalStepIncrementsDoNotDriftOverManyCalls(): void;
    repeatedDecimalStepDecrementsLandOnExactValue(): void;
    repeatedDifferentDecimalStepIncrementsLandOnExactValue(): void;
}
export = IncrementStepValidation;
