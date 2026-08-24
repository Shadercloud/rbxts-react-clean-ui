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
