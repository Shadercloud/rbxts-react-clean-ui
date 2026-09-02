import React from "@rbxts/react";
import { IntentElementProps } from "../../Interfaces";
import { BoxProps } from "../Surface";
export interface ModalProps extends BoxProps, IntentElementProps {
    open?: boolean;
    defaultOpen?: boolean;
    onOpenChange?: (open: boolean) => void;
    closeOnBackdropClick?: boolean;
    closeOnEscape?: boolean;
    draggable?: boolean;
    initialFocus?: React.RefObject<GuiObject>;
    children?: React.ReactNode;
}
export declare function Modal(props: ModalProps): React.JSX.Element | undefined;
