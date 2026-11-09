import { CssPixelSize } from "../../Interfaces/css.types";
declare class SizeConstraintResolution {
    unsetIsUndefined(): void;
    unsetDefaults(): void;
    minOnlyUnbounded(): void;
    allFourMapped(): void;
    negativeMinZero(): void;
    maxRaisedToMin(): void;
    negativeMaxZero(): void;
    pixelParsing(value: CssPixelSize): void;
}
export = SizeConstraintResolution;
