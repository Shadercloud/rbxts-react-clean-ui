declare class TooltipPlacementValidation {
    keepsPreferred(): void;
    defaultIsTop(): void;
    flipsTopToBottom(): void;
    flipsBottomToTop(): void;
    flipsRightToLeft(): void;
    flipsLeftToRight(): void;
    bothOverflow(): void;
    centerNeverFlips(): void;
    shiftsAtEdge(): void;
    shiftsAtCorner(): void;
    pointerClamped(): void;
    pointerNoRoom(): void;
    shiftsVertically(): void;
    topbarFlips(): void;
    topbarAboveOverlay(): void;
    autoCentred(): void;
    autoMostRoom(): void;
    autoTopLeft(): void;
    autoRightEdge(): void;
    autoNoneFit(): void;
    pointerPadding(): void;
    shadowPointerOffset(): void;
}
export = TooltipPlacementValidation;
