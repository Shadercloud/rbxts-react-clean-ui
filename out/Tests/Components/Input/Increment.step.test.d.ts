declare class IncrementStepValidation {
    defaultStep(): void;
    defaultStepDown(): void;
    customStep(): void;
    customStepDown(): void;
    clampsToMax(): void;
    clampsToMin(): void;
    noOpAtMax(): void;
    noOpAtMin(): void;
    decimalStepExact(): void;
    noDecimalDrift(): void;
    decimalStepDownExact(): void;
    oddDecimalStepExact(): void;
}
export = IncrementStepValidation;
