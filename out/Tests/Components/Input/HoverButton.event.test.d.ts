type MergedEvent = "Activated" | "MouseEnter";
declare class HoverButtonEventValidation {
    runsBothHandlers(eventName: MergedEvent): void;
    forwardsRef(): void;
}
export = HoverButtonEventValidation;
