import { Binding } from "@rbxts/react";
import { CssRadius, CssSize } from "../Interfaces/css.types";
import { Breakpoint, ResponsiveValue } from "../Interfaces/responsive.types";
import { SizeElementProps, PositionElementProps } from "../Interfaces/element.props";
import { ThemeTemplate } from "../Theme";
export declare class SizeHelper {
    static GetSize(props: SizeElementProps, defaultSize?: UDim2): UDim2 | Binding<UDim2>;
    static GetPosition(props: PositionElementProps): UDim2 | Binding<UDim2>;
    static GetAnchor(props: PositionElementProps): Vector2 | Binding<Vector2>;
    static GetAutoSize(props: SizeElementProps, defaultValue?: Enum.AutomaticSize): Enum.AutomaticSize | "None" | "X" | "Y" | "XY" | Binding<Enum.AutomaticSize>;
    static GetSizeConstraint(props: SizeElementProps): {
        MinSize: Vector2;
        MaxSize: Vector2;
    } | undefined;
    static toUDim(size?: CssSize): UDim;
    static resolveRadius(theme: ThemeTemplate, radius: CssRadius): CssSize;
    static resolveRadius(theme: ThemeTemplate, radius?: CssRadius): CssSize | undefined;
    static toRadius(theme: ThemeTemplate, radius?: CssRadius): UDim;
    private static parseNumber;
    private static fromFarEdge;
    private static isBreakpointSize;
    private static isBreakpointValue;
    static resolveResponsiveValue<T>(value: ResponsiveValue<T> | undefined, breakpoint: Breakpoint): T | undefined;
}
