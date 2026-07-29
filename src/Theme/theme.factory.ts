import { CleanTheme } from "./theme.template";
import { DefaultTheme } from "./themes/default.theme";

export type DeepPartial<T> = {
    [K in keyof T]?: T[K] extends object
    ? DeepPartial<T[K]>
    : T[K];
};

type UnknownRecord = Record<string, unknown>;

function isRecord(value: unknown): value is UnknownRecord {
    return typeIs(value, "table");
}

function deepMerge<T extends object>(
    base: T,
    overrides: DeepPartial<T>,
): T {
    const result = { ...base } as UnknownRecord;
    const overrideRecord = overrides as UnknownRecord;

    for (const [key, overrideValue] of pairs(overrideRecord)) {
        const baseValue = result[key];

        if (isRecord(baseValue) && isRecord(overrideValue)) {
            result[key] = deepMerge(
                baseValue,
                overrideValue,
            );
        } else if (overrideValue !== undefined) {
            result[key] = overrideValue;
        }
    }

    return result as T;
}



export function createTheme(
    overrides: DeepPartial<CleanTheme> = {},
): CleanTheme {
    return deepMerge(DefaultTheme, overrides);
}

export function extendTheme(
    baseTheme: CleanTheme,
    overrides: DeepPartial<CleanTheme>,
): CleanTheme {
    return deepMerge(baseTheme, overrides);
}