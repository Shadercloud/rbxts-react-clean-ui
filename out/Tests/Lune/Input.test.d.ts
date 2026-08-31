declare class InputNumberValidation {
    keepsLastValidTextWhenAnInvalidCharacterIsTyped(): void;
    clampsDownToMaxWhenTextIsOverRange(): void;
    clampsUpToMinWhenTextIsUnderRange(): void;
    returnsUndefinedWhenTextIsWithinRange(): void;
    returnsUndefinedWhenTextIsNonNumeric(): void;
}
export = InputNumberValidation;
