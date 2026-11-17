export declare class TextHelper {
    static isValidUtf8(text: string): boolean;
    static lowercase(text: string): string;
    static isComplexScript(text: string): boolean;
    static splitGraphemes(text: string): string[] | undefined;
}
