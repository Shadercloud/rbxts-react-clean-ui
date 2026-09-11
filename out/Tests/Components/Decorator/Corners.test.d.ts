import { CssSize } from "../../../Interfaces/";
declare class CornersMountValidation {
    numericRadius(): void;
    percentRadiusAndName(): void;
    zeroRadiusEmitsNothing(radius: CssSize): void;
    noRadiusEmitsNothing(): void;
}
export = CornersMountValidation;
