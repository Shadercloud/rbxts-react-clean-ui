import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
interface HStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
}
export declare function HStack(props: HStackProps): React.JSX.Element;
export {};
