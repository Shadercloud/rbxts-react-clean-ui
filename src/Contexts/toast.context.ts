import React from "@rbxts/react";
import { IconName, Intent } from "../Interfaces";

export interface ToastOptions {
    id?: string;
    title?: string;
    description?: string;
    icon?: IconName;
    intent?: Intent;
    duration?: number;
    dismissible?: boolean;
    children?: React.ReactNode;
    name?: string;
}

export interface ToastRecord extends ToastOptions {
    id: string;
}

export interface ToastController {
    show: (options: ToastOptions) => string;
    update: (id: string, options: Partial<ToastOptions>) => void;
    dismiss: (id: string) => void;
    dismissAll: () => void;
}

export interface ToastContextValue extends ToastController {
    toasts: ToastRecord[];
}


export const ToastContext = React.createContext<ToastContextValue | undefined>(
    undefined,
);

export function useToast(): ToastContextValue {
    const context = React.useContext(ToastContext);

    assert(context !== undefined, "ToastProvider is missing.");

    return context;
}
