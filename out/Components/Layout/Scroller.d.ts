import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
interface ScrollerProps extends SizeElementProps, SpacedElementProps, PositionElementProps {
    children?: React.ReactNode;
}
export declare function Scroller(props: ScrollerProps): React.JSX.Element;
export {};
