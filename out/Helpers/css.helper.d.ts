import { CssBoxShadow, CssShadow, CssSize, CssQuad, CssDual, CssSliceInset } from "../Interfaces/css.types";
import { CssBackgroundImage } from "../Theme";
interface ParsedShadow {
    offset: UDim2;
    blurRadius: UDim;
    spread: UDim2;
}
interface ParsedQuad {
    top: number;
    right: number;
    bottom: number;
    left: number;
}
interface ParsedSliceInset {
    x1: number;
    y1: number;
    x2: number;
    y2: number;
}
export declare class CssHelper {
    static parseCssShadow(value: CssShadow): ParsedShadow | undefined;
    private static isZero;
    static parseCssSize(value: CssSize): UDim;
    static parseCssQuad(value: CssQuad): ParsedQuad;
    private static toRawPixels;
    static parseCssSliceInset(value: CssSliceInset): ParsedSliceInset;
    static parseCssDual(value: CssDual): UDim2;
    static ResolveShadow(shadow: CssBoxShadow): React.InstanceProps<UIShadow>;
    static resolveBackgroundImage(value: CssBackgroundImage | undefined): {
        Image?: string;
        ImageColor3?: Color3;
        ImageTransparency?: number;
        ScaleType?: CssBackgroundImage["size"];
        SliceCenter?: Rect;
        SliceScale?: number;
        TileSize?: UDim2;
    };
}
export {};
