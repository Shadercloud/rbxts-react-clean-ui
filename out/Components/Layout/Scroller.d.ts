import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
export interface ScrollerProps extends SizeElementProps, SpacedElementProps, PositionElementProps {
    children?: React.ReactNode;
    AutomaticSizeParent?: boolean;
    name?: string;
    stableGutter?: boolean;
    onScroll?: (canvasPosition: Vector2, scroller: ScrollingFrame) => void;
    onNearEnd?: () => void;
    nearEndThreshold?: number;
}
export declare const Scroller: React.ForwardRefExoticComponent<ScrollerProps & React.RefAttributes<ScrollingFrame>>;
