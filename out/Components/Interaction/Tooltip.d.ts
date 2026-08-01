import React from "@rbxts/react";
import { IntentElementProps } from "../../Interfaces";
import { BoxProps } from "../Surface";
type TooltipPlacement = "Top" | "Bottom" | "Left" | "Right" | "Center";
interface TooltipProps extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    children: React.ReactElement<React.InstanceProps<GuiObject>>;
    placement?: TooltipPlacement;
}
export declare function Tooltip(props: TooltipProps): React.JSX.Element;
export {};
