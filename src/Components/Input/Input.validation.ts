import { InputProps } from "./Input";

export const CHARACTER_ALLOW_LIST_PATTERNS: Partial<Record<NonNullable<InputProps["validation"]>, string>> = {
    Telephone: "^[%d%+%-%s%(%)]*$",
    Alphanumeric: "^[%w]*$",
    Email: "^[%w@%._%-+]*$",
};

export function resolveValidatedText(
    validation: InputProps["validation"],
    candidateText: string,
    lastValidText: string,
): string {
    const number = tonumber(candidateText);

    if (
        (validation === "Number" || validation === "Int") &&
        number === undefined &&
        candidateText !== "" &&
        candidateText !== "-"
    ) {
        return lastValidText;
    }

    const allowedPattern = CHARACTER_ALLOW_LIST_PATTERNS[validation ?? "None"];

    if (allowedPattern !== undefined && candidateText.match(allowedPattern)[0] === undefined) {
        return lastValidText;
    }

    return candidateText;
}

export function resolveClampedText(
    validation: InputProps["validation"],
    text: string,
    min: number | undefined,
    max: number | undefined,
): string | undefined {
    if (validation !== "Number" && validation !== "Int") {
        return undefined;
    }

    const number = tonumber(text);

    if (number === undefined) {
        return undefined;
    }

    let clamped = number;

    if (min !== undefined && clamped < min) {
        clamped = min;
    }

    if (max !== undefined && clamped > max) {
        clamped = max;
    }

    if (clamped === number) {
        return undefined;
    }

    return tostring(clamped);
}
