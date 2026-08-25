const ROUNDING_PRECISION = 1e9; // 9 decimal places

function roundToPrecision(value: number): number {
    return value >= 0
        ? math.floor(value * ROUNDING_PRECISION + 0.5) / ROUNDING_PRECISION
        : math.ceil(value * ROUNDING_PRECISION - 0.5) / ROUNDING_PRECISION;
}

export function resolveSteppedValue(
    current: number,
    direction: "increment" | "decrement",
    step: number,
    min?: number,
    max?: number,
): number | undefined {
    if (direction === "decrement" && min !== undefined && current <= min) {
        return undefined;
    }

    if (direction === "increment" && max !== undefined && current >= max) {
        return undefined;
    }

    let candidate = direction === "increment" ? current + step : current - step;
    candidate = roundToPrecision(candidate);

    if (min !== undefined && candidate < min) {
        candidate = min;
    }

    if (max !== undefined && candidate > max) {
        candidate = max;
    }

    return candidate;
}
