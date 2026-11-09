import React from "@rbxts/react";
import { IntentElementProps } from "../../Interfaces";
import { BoxProps } from "../Surface";
import { TooltipPlacement } from "./Tooltip.placement";
interface TooltipProps extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    children: React.ReactElement<React.InstanceProps<GuiObject>>;
    placement?: TooltipPlacement;
    disabled?: boolean;
    open?: boolean;
    interactive?: boolean;
    pinOnPress?: boolean;
    longPress?: boolean;
}
export declare function Tooltip(props: TooltipProps): React.JSX.Element;
export {};
