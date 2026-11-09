declare class TooltipHoverValidation {
    plainClosesAtOnce(): void;
    plainPressNoop(kind: "MouseButton1" | "Touch"): void;
    crossToPopup(): void;
    closeAfterDelay(): void;
    themeCloseDelay(): void;
}
export = TooltipHoverValidation;
