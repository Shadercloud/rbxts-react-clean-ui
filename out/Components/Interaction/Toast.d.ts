import React from "@rbxts/react";
import { SizeElementProps } from "../../Interfaces";
import { ToastOptions } from "../../Contexts";
interface ToastProps extends ToastOptions {
    onDismiss: () => void;
}
export declare function Toast({ title, description, icon, intent, duration, dismissible, children, name, onDismiss, }: ToastProps): React.JSX.Element;
interface ToastContainerProps extends SizeElementProps {
    name?: string;
}
export declare function ToastContainer(props: ToastContainerProps): React.JSX.Element | undefined;
export {};
