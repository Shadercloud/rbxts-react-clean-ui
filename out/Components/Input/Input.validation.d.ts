import { InputProps } from "./Input";
export declare const CHARACTER_ALLOW_LIST_PATTERNS: Partial<Record<NonNullable<InputProps["validation"]>, string>>;
export declare function resolveValidatedText(validation: InputProps["validation"], candidateText: string, lastValidText: string): string;
