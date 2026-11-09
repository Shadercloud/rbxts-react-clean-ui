declare class TooltipPinValidation {
    pressPins(): void;
    pressTriggerUnpins(kind: "MouseButton1" | "Touch"): void;
    hoveredUnpinOpen(): void;
    pressPopupUnpins(kind: "MouseButton1" | "Touch"): void;
    popupPressNoPin(): void;
}
export = TooltipPinValidation;
