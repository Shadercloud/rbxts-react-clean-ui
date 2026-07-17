import { Binding } from "@rbxts/react";
import { CssSize, Breakpoint, ResponsiveValue, SizeElementProps, PositionElementProps } from "../Interfaces/clean.element.props";
export declare class SizeHelper {
    static GetSize(props: SizeElementProps, defaultSize?: UDim2): UDim2 | Binding<UDim2>;
    static GetPosition(props: PositionElementProps): UDim2 | Binding<UDim2>;
    static GetAnchor(props: PositionElementProps): Vector2 | Binding<Vector2>;
    static GetAutoSize(props: SizeElementProps, defaultValue?: Enum.AutomaticSize): Enum.AutomaticSize | "None" | "X" | "Y" | "XY" | Binding<Enum.AutomaticSize>;
    static toUDim(size?: CssSize): UDim;
    private static parseNumber;
    private static fromFarEdge;
    private static isBreakpointSize;
    private static isBreakpointValue;
    static resolveResponsiveValue<T>(value: ResponsiveValue<T> | undefined, breakpoint: Breakpoint): T | undefined;
}
