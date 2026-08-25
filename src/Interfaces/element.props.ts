import { Binding } from "@rbxts/react";
import { IconName } from "./icon";
import { CssSize, CssShadow, CssPadding, ResponsiveCssSize } from "./css.types";
import { ScaleSize, BreakpointValue } from "./responsive.types";
import { Intent } from "./semantics";

export interface ZIndexElementProps {
    ZIndex?: number | Binding<number> | undefined;
}

export interface BackgroundElementProps {
    BackgroundTransparency?: number | Binding<number> | undefined;
    BackgroundColor3?: Color3 | Binding<Color3> | undefined;
}

export interface SizeElementProps {
    Size?: UDim2 | Binding<UDim2>;
    width?: ResponsiveCssSize;
    height?: CssSize;
    AutomaticSize?: Enum.AutomaticSize | Binding<Enum.AutomaticSize> | "None" | "X" | "Y" | "XY" | undefined;

}

export interface ScalableElementProps {
    scale?: ScaleSize;
}

export interface PositionElementProps {
    Position?: UDim2 | Binding<UDim2>;
    AnchorPoint?: Vector2 | Binding<Vector2> | undefined;
    center?: boolean;
    top?: CssSize;
    left?: CssSize;
    right?: CssSize;
    bottom?: CssSize;
}

export interface IntentElementProps {
    intent?: Intent
}

export interface CleanElementProps extends SizeElementProps, PositionElementProps {

}

export interface SpacedElementProps {
    spacing?: ScaleSize | "None"
}

export interface BreakPointElementProps {
    breakpoints?: BreakpointValue<number>;
}

export interface ShadowElementProps {
    "box-shadow"?: CssShadow;
    "box-shadow-color"?: Color3;
    "box-shadow-transparency"?: number;
}

export interface IconElementProps {
    icon?: IconName
}

export interface PaddingProps extends SpacedElementProps {
    right?: ScaleSize | "None";
    left?: ScaleSize | "None";
    top?: ScaleSize | "None";
    bottom?: ScaleSize | "None";
    padding?: CssPadding;
    resolvedPadding?: ResolvedPadding;
}

export interface ResolvedPadding {
    top: number;
    bottom: number;
    left: number;
    right: number;
}
