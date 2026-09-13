import { Intent, ScaleSize } from "../../../Interfaces";
declare class BadgeMountValidation {
    mountsWithText(): void;
    defaultIntentColors(intent: Intent, textHex: string, backgroundHex: string, borderHex: string): void;
    woodenPrimary(): void;
    scaleSetsTextSize(scale: ScaleSize, expectedSize: number): void;
    largerScaleTaller(): void;
}
export = BadgeMountValidation;
