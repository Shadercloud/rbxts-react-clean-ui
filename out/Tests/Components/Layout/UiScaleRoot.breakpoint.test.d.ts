import { Breakpoint } from "../../../Interfaces/responsive.types";
declare class UiScaleBreakpointValidation {
    providerDesignWidth(scale: number, expected: Breakpoint): void;
    providerRescales(): void;
    viewportDesignWidth(scale: number, expected: Breakpoint): void;
    rowDesignWidth(scale: number, breakpoint: Breakpoint, span: number): void;
    gridDesignWidth(scale: number, breakpoint: Breakpoint, cols: number): void;
    fieldsetDesignWidth(scale: number, breakpoint: Breakpoint, expectedWraps: boolean): void;
}
export = UiScaleBreakpointValidation;
