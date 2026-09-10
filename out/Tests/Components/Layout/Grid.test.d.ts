import { ScaleSize } from "../../../Interfaces/";
declare class GridMountValidation {
    numericCols(): void;
    defaultCols(): void;
    breakpointCols(): void;
    customBreakpoints(): void;
    cellSizing(cols: number, gapKey: ScaleSize | "None", gapPixels: number, expectedScale: number, expectedOffset: number): void;
    childOrder(): void;
    relockOnChildAdded(): void;
    relockOnWidthChange(): void;
    pixelWidth(): void;
    percentWidth(hostWidth: number, expectedGridWidth: number): void;
    defaultWidth(): void;
}
export = GridMountValidation;
