declare class PinTextSizeStandalone {
    pinsSize(size: number): void;
    clampsRange(size: number, expected: number): void;
    undefinedSize(): void;
    enabledToggle(): void;
    tracksSize(): void;
    hookDefaultsOff(): void;
    hookFollowsProvider(ignore: boolean): void;
}
export = PinTextSizeStandalone;
