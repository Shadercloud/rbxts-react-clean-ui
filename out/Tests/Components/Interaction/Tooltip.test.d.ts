declare class TooltipMountValidation {
    hiddenUntilHover(): void;
    showsOnHover(placement: "Top" | "Bottom"): void;
    hidesAfterLeave(): void;
    disabledNoPopup(): void;
    disabledKeepsInstance(): void;
    disableHidesOpen(): void;
    controlledOpen(): void;
    controlledClosedIgnoresHover(): void;
    disabledOverridesOpen(): void;
    nativeChildMounts(): void;
    nativeChildShows(): void;
    rightEdgeFlips(): void;
    topEdgeFlips(): void;
    leftEdgeShifts(): void;
    autoRightEdge(): void;
}
export = TooltipMountValidation;
