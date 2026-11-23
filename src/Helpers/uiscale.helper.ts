export function toDesignPixels(value: Vector2, scale: number): Vector2;
export function toDesignPixels(value: number, scale: number): number;
export function toDesignPixels(value: Vector2 | number, scale: number): Vector2 | number {
    if (typeIs(value, "number")) {
        return value / scale;
    }

    return value.div(scale);
}

export function toScreenPixels(value: Vector2, scale: number): Vector2;
export function toScreenPixels(value: number, scale: number): number;
export function toScreenPixels(value: Vector2 | number, scale: number): Vector2 | number {
    if (typeIs(value, "number")) {
        return value * scale;
    }

    return value.mul(scale);
}

export function toScreenTextSize(size: number, scale: number): number | undefined {
    const screenSize = math.clamp(size, 1, 100) * scale;

    if (screenSize > 100)
        return undefined;

    return math.max(screenSize, 1);
}

export function toScreenTextSizeRange(minTextSize: number, maxTextSize: number, scale: number): [number, number] {
    const screenMin = math.clamp(minTextSize * scale, 1, 100);

    return [screenMin, math.clamp(maxTextSize * scale, screenMin, 100)];
}
