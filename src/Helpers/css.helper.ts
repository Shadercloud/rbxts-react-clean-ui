import { CssShadow, CssSize } from "../Interfaces/clean.element.props";

interface ParsedShadow {
    offset: UDim2;
    blurRadius: UDim;
    spread: UDim2;
}

export class CssHelper {
    public static parseCssShadow(value: CssShadow): ParsedShadow | undefined {
        if (typeIs(value, "number")) {
            if (value === 0) {
                return undefined;
            }

            const size = this.parseCssSize(value);

            return {
                offset: new UDim2(size, size),
                blurRadius: new UDim(0, 0),
                spread: new UDim2(),
            };
        }

        const parts = value
            .split(" ")
            .filter((part) => part.size() > 0) as CssSize[];

        const x = this.parseCssSize(parts[0] ?? "0");
        const y = this.parseCssSize(parts[1] ?? parts[0] ?? "0");
        const blur = this.parseCssSize(parts[2] ?? "0");
        const spread = this.parseCssSize(parts[3] ?? "0");

        const isZero =
            this.isZero(x) &&
            this.isZero(y) &&
            this.isZero(blur) &&
            this.isZero(spread);

        if (isZero) {
            return undefined;
        }

        return {
            offset: new UDim2(x, y),
            blurRadius: blur,
            spread: new UDim2(spread, spread),
        };
    }

    private static isZero(value: UDim): boolean {
        return value.Scale === 0 && value.Offset === 0;
    }

    private static parseCssSize(value: CssSize): UDim {
        if (typeIs(value, "number")) {
            return new UDim(0, value);
        }

        if (value.sub(-1) === "%") {
            const amount = tonumber(value.sub(1, -2)) ?? 0;
            return new UDim(amount / 100, 0);
        }

        if (value.sub(-2) === "px") {
            const amount = tonumber(value.sub(1, -3)) ?? 0;
            return new UDim(0, amount);
        }

        return new UDim(0, tonumber(value) ?? 0);
    }
}