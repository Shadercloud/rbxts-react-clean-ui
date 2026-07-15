import { Breakpoint, BreakpointValue } from "../Interfaces/";
export declare class BreakpointHelper {
    static getValue<T>(breakpoint: Breakpoint, value?: BreakpointValue<T>): T | undefined;
    static getBreakpoint(width: number, breakpoints: BreakpointValue<number>): Breakpoint;
}
