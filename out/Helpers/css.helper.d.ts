import { CssShadow } from "../Interfaces/clean.element.props";
interface ParsedShadow {
    offset: UDim2;
    blurRadius: UDim;
    spread: UDim2;
}
export declare class CssHelper {
    static parseCssShadow(value: CssShadow): ParsedShadow | undefined;
    private static isZero;
    private static parseCssSize;
}
export {};
