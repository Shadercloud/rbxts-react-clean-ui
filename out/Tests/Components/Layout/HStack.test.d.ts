import { ScaleSize } from "../../../Interfaces/";
declare class HStackMountValidation {
    childrenInOrder(): void;
    gapMatchesSpacing(spacing: ScaleSize | "None", expectedGap: number): void;
    centerAlignment(): void;
    allContained(): void;
}
export = HStackMountValidation;
