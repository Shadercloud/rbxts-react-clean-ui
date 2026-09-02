import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
interface ScrollerProps extends SizeElementProps, SpacedElementProps, PositionElementProps {
    children?: React.ReactNode;
    AutomaticSizeParent?: boolean;
    name?: string;
}
export declare function Scroller(props: ScrollerProps): React.JSX.Element;
export {};
