declare class UiScaleHelperNumber {
    designDivides(value: number, scale: number, expected: number): void;
    screenMultiplies(value: number, scale: number, expected: number): void;
    roundTrip(value: number, scale: number): void;
    identityAtOne(value: number): void;
}
export = UiScaleHelperNumber;
