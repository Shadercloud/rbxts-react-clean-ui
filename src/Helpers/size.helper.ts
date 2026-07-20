import { Binding } from "@rbxts/react";
import { CssBreakpointSize, CssSize, ResponsiveCssSize, Breakpoint, ResponsiveValue, BreakpointValue, SizeElementProps, PositionElementProps } from "../Interfaces/clean.element.props";

const breakpointOrder: Breakpoint[] = [
    "xs",
    "sm",
    "md",
    "lg",
    "xl",
];

export class SizeHelper {
    public static GetSize(props: SizeElementProps, defaultSize?: UDim2): UDim2 | Binding<UDim2> {
        if (props.Size)
            return props.Size

        if (props.width === undefined && props.height === undefined && defaultSize !== undefined)
            return defaultSize

        let width
        if (props.width !== undefined) {
            if (props.width === "Auto")
                width = 0
            else if (this.isBreakpointSize(props.width)) {
                width = this.resolveResponsiveValue(props.width, "sm")
            } else {
                width = props.width
            }
        }
        return new UDim2(
            this.toUDim(width),
            this.toUDim(props.height),
        )
    }

    public static GetPosition(props: PositionElementProps): UDim2 | Binding<UDim2> {
        if (props.Position !== undefined) {
            return props.Position;
        }

        if (props.center !== undefined) {
            const c =
                typeIs(props.center, "boolean")
                    ? (props.center ? "50%" : undefined)
                    : props.center;
            const center = this.toUDim(c as CssSize);
            return new UDim2(center, center);
        }

        const x = props.left !== undefined
            ? this.toUDim(props.left)
            : props.right !== undefined
                ? this.fromFarEdge(props.right)
                : new UDim(0, 0);

        const y = props.top !== undefined
            ? this.toUDim(props.top)
            : props.bottom !== undefined
                ? this.fromFarEdge(props.bottom)
                : new UDim(0, 0);

        return new UDim2(x, y);
    }

    public static GetAnchor(props: PositionElementProps): Vector2 | Binding<Vector2> {
        if (props.AnchorPoint !== undefined) {
            return props.AnchorPoint;
        }
        if (props.center !== undefined)
            return new Vector2(0.5, 0.5)

        const x = props.left === undefined && props.right !== undefined ? 1 : 0;
        const y = props.top === undefined && props.bottom !== undefined ? 1 : 0;

        return new Vector2(x, y);
    }

    public static GetAutoSize(props: SizeElementProps, defaultValue?: Enum.AutomaticSize): Enum.AutomaticSize | "None" | "X" | "Y" | "XY" | Binding<Enum.AutomaticSize> {
        if (props.AutomaticSize !== undefined)
            return props.AutomaticSize

        if (props.width === "Auto")
            return Enum.AutomaticSize.X

        if (props.Size || (props.width && props.height))
            return Enum.AutomaticSize.None
        if (props.width === undefined && props.height === undefined && defaultValue === undefined)
            return Enum.AutomaticSize.XY

        if (!props.width)
            return Enum.AutomaticSize.X

        return defaultValue !== undefined ? defaultValue : Enum.AutomaticSize.Y
    }

    public static toUDim(size?: CssSize): UDim {
        if (size === undefined) {
            return new UDim(0, 0);
        }

        if (typeIs(size, "number")) {
            return new UDim(0, size);
        }

        const text = size.lower().gsub("%s+", "")[0];

        if (text.sub(-1) === "%") {
            const value = this.parseNumber(text.sub(1, -2), size);
            return new UDim(value / 100, 0);
        }

        if (text.sub(-2) === "px") {
            const value = this.parseNumber(text.sub(1, -3), size);
            return new UDim(0, value);
        }

        const value = this.parseNumber(text, size);
        return new UDim(0, value);
    }

    private static parseNumber(text: string, originalValue: string): number {
        const value = tonumber(text);

        assert(
            value !== undefined,
            `Invalid size value "${originalValue}". Expected a number, "25px", or "25%".`,
        );

        return value;
    }

    private static fromFarEdge(size: CssSize): UDim {
        const value = this.toUDim(size);

        return new UDim(
            1 - value.Scale,
            -value.Offset,
        );
    }

    private static isBreakpointSize(
        value: ResponsiveCssSize,
    ): value is CssBreakpointSize {
        return typeIs(value, "table");
    }

    private static isBreakpointValue<T>(
        value: ResponsiveValue<T>,
    ): value is BreakpointValue<T> {
        if (!typeIs(value, "table")) {
            return false;
        }

        return (
            "xs" in value ||
            "sm" in value ||
            "md" in value ||
            "lg" in value ||
            "xl" in value
        );
    }

    public static resolveResponsiveValue<T>(
        value: ResponsiveValue<T> | undefined,
        breakpoint: Breakpoint,
    ): T | undefined {
        if (value === undefined) {
            return undefined;
        }

        if (!this.isBreakpointValue(value)) {
            return value;
        }

        const breakpointIndex = breakpointOrder.indexOf(breakpoint);

        for (let index = breakpointIndex; index >= 0; index--) {
            const candidate = value[breakpointOrder[index]];

            if (candidate !== undefined) {
                return candidate;
            }
        }

        return undefined;
    }
}