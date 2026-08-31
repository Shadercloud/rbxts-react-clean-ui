import { InputProps } from "./Input";
export declare const CHARACTER_ALLOW_LIST_PATTERNS: Partial<Record<NonNullable<InputProps["validation"]>, string>>;
export declare function resolveValidatedText(validation: InputProps["validation"], candidateText: string, lastValidText: string): string;
export declare function resolveClampedText(validation: InputProps["validation"], text: string, min: number | undefined, max: number | undefined): string | undefined;
