declare class CheckboxMountValidation {
    mountsContained(): void;
    silentControlledMount(variant: string, checked: boolean): void;
    defaultCheckedSeeds(variant: string, defaultChecked: boolean): void;
    controlledClickReports(): void;
    propChangeSilent(): void;
    uncontrolledClickToggles(): void;
    fieldsetLabelToggles(): void;
    scaleSizesIcon(scale: "xs" | "xl"): void;
}
export = CheckboxMountValidation;
