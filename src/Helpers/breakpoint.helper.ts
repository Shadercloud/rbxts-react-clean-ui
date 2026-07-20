import {
    Breakpoint,
    BreakpointValue,
} from "../Interfaces/";

export class BreakpointHelper {
    private static readonly breakpointOrder: Record<Breakpoint, number> = {
        xs: 0,
        sm: 1,
        md: 2,
        lg: 3,
        xl: 4,
    };
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

    public static compare(
        left: Breakpoint,
        operator: ">" | ">=" | "<" | "<=" | "==" | "!=",
        right: Breakpoint,
    ): boolean {
        const a = BreakpointHelper.breakpointOrder[left];
        const b = BreakpointHelper.breakpointOrder[right];

        switch (operator) {
            case ">":
                return a > b;

            case ">=":
                return a >= b;

            case "<":
                return a < b;

            case "<=":
                return a <= b;

            case "!=":
                return a !== b;

            case "==":
            default:
                return a === b;
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