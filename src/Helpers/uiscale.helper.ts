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
