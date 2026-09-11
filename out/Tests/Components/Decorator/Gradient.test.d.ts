import { CssBackgroundGradient } from "../../../Interfaces/";
declare class GradientMountValidation {
    colorsAndRotation(): void;
    stopsTransparencyAndName(): void;
    noValueEmitsNothing(): void;
    colorlessValueEmitsNothing(label: string, value: Partial<CssBackgroundGradient>): void;
    outOfOrderStopsMount(): void;
}
export = GradientMountValidation;
