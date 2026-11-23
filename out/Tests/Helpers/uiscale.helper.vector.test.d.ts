declare class UiScaleHelperVector {
    designDivides(x: number, y: number, scale: number, expectedX: number, expectedY: number): void;
    screenMultiplies(x: number, y: number, scale: number, expectedX: number, expectedY: number): void;
    roundTrip(scale: number): void;
    zeroStaysZero(): void;
}
export = UiScaleHelperVector;
