declare class PinTextSizeUiScale {
    scalesPin(scale: number, size: number, expected: number): void;
    nestedMultiplies(outer: number, inner: number, size: number, expected: number): void;
    tracksScale(): void;
    overCapNoPin(scale: number, size: number): void;
    exactCapPins(scale: number, size: number): void;
    capToggles(): void;
}
export = PinTextSizeUiScale;
