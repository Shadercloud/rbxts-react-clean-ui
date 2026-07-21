import React from "@rbxts/react";
import { SizeElementProps, SpacedElementProps } from "../../Interfaces";
interface ScrollerProps extends SizeElementProps, SpacedElementProps {
    children?: React.ReactNode;
}
export declare function Scroller(props: ScrollerProps): React.JSX.Element;
export {};
