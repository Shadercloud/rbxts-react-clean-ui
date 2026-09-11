import { ScaleSize } from "../../../Interfaces/";
declare class VStackMountValidation {
    childrenInOrder(): void;
    gapMatchesSpacing(spacing: ScaleSize | "None", expectedGap: number): void;
    fillStretchesChildren(): void;
    centerAlignment(): void;
    allContained(): void;
}
export = VStackMountValidation;
