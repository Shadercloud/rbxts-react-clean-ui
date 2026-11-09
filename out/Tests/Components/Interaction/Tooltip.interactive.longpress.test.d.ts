declare class TooltipLongPressValidation {
    holdOpens(): void;
    releaseCloses(state: "End" | "Cancel", pinOnPress: boolean): void;
    shortTapNoop(): void;
    tapTogglesPin(): void;
    mousePressPins(): void;
}
export = TooltipLongPressValidation;
