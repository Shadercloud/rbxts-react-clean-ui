declare class SwitchMountValidation {
    seedsCheckedStateFromInitialPropAndFiresOnMountWithIt(): void;
    defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted(): void;
    uncontrolledStateIgnoresSubsequentCheckedProp(): void;
    activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange(): void;
    disabledSuppressesTheFieldsetLabelBridgeAndOnChange(): void;
    disabledMarksTheTrackNonInteractive(): void;
    defaultsInstanceNameToSwitchWhenNamePropIsOmitted(): void;
    namePropOverridesTheRenderedInstanceName(): void;
}
export = SwitchMountValidation;
