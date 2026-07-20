import { Breakpoint, BreakpointValue } from "../Interfaces/";
export declare class BreakpointHelper {
    private static readonly breakpointOrder;
    static getValue<T>(breakpoint: Breakpoint, value?: BreakpointValue<T>): T | undefined;
    static compare(left: Breakpoint, operator: ">" | ">=" | "<" | "<=" | "==" | "!=", right: Breakpoint): boolean;
    static getBreakpoint(width: number, breakpoints: BreakpointValue<number>): Breakpoint;
}
