import {
    Breakpoint,
    BreakpointValue,
} from "../Interfaces/";

export class BreakpointHelper {
    public static getValue<T>(
        breakpoint: Breakpoint,
        value?: BreakpointValue<T>,
    ): T | undefined {
        if (value === undefined) {
            return undefined;
        }

        switch (breakpoint) {
            case "xl":
                return value.xl
                    ?? value.lg
                    ?? value.md
                    ?? value.sm
                    ?? value.xs;

            case "lg":
                return value.lg
                    ?? value.md
                    ?? value.sm
                    ?? value.xs;

            case "md":
                return value.md
                    ?? value.sm
                    ?? value.xs;

            case "sm":
                return value.sm
                    ?? value.xs;

            case "xs":
            default:
                return value.xs;
        }
    }

    public static getBreakpoint(
        width: number,
        breakpoints: BreakpointValue<number>,
    ): Breakpoint {
        let active: Breakpoint = "xs";

        if (
            breakpoints.sm !== undefined
            && width >= breakpoints.sm
        ) {
            active = "sm";
        }

        if (
            breakpoints.md !== undefined
            && width >= breakpoints.md
        ) {
            active = "md";
        }

        if (
            breakpoints.lg !== undefined
            && width >= breakpoints.lg
        ) {
            active = "lg";
        }

        if (
            breakpoints.xl !== undefined
            && width >= breakpoints.xl
        ) {
            active = "xl";
        }

        return active;
    }
}