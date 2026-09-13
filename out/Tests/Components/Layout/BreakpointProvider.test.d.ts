import { Breakpoint } from "../../../Interfaces/responsive.types";
declare class BreakpointProviderMountValidation {
    measuredBreakpoint(width: number, expected: Breakpoint): void;
    publishesWidth(): void;
    breakpointsProp(): void;
    rerendersOnCrossing(): void;
}
export = BreakpointProviderMountValidation;
