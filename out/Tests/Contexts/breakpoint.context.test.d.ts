import { Breakpoint } from "../../Interfaces/responsive.types";
declare class BreakpointHookValidation {
    viewportDefaultTheme(): void;
    viewportIgnoresContainer(): void;
    valueFallsBack(width: number, breakpoint: Breakpoint, expected: string): void;
    valueUndefinedBelow(): void;
    plainValue(): void;
}
export = BreakpointHookValidation;
