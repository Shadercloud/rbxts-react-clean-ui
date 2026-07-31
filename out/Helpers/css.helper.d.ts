import { CssBoxShadow, CssShadow, CssSize } from "../Interfaces/clean.element.props";
interface ParsedShadow {
    offset: UDim2;
    blurRadius: UDim;
    spread: UDim2;
}
export declare class CssHelper {
    static parseCssShadow(value: CssShadow): ParsedShadow | undefined;
    private static isZero;
    static parseCssSize(value: CssSize): UDim;
    static ResolveShadow(shadow: CssBoxShadow): React.InstanceProps<UIShadow>;
}
export {};
