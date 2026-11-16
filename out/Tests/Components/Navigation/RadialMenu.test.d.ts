declare class RadialMenuMountValidation {
    placeholderCentre(): void;
    emptyCentre(): void;
    defaultValueCentre(): void;
    unknownDefault(): void;
    controlledRerender(): void;
    selectsByAngle(angle: number, radius: number, expected: string): void;
    missSelectsNothing(angle: number, radius: number): void;
    missKeepsSelection(): void;
    releaseInputTypes(): void;
    reselectFires(): void;
    controlledClickReports(): void;
    hoverFollowsPointer(): void;
}
export = RadialMenuMountValidation;
