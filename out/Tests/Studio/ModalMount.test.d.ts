declare class ModalMountValidation {
    rendersBackdropAndPanelWithExplicitModalProviders(): void;
    wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop(): void;
    resolvesPercentageAndScalePanelSizesAgainstTheOverlay(): void;
    defaultsToANonDraggableCenteredPanel(): void;
    makesTheHeaderADragHandleAndRetainsTheDroppedPosition(): void;
    nestedHeaderButtonClosesWithoutStartingOrCommittingADrag(): void;
    opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange(): void;
    controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen(): void;
    closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal(): void;
}
export = ModalMountValidation;
