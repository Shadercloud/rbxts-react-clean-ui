import React from "@rbxts/react";
import { ToastContext, ToastContextValue, ToastOptions, ToastRecord } from "../Contexts/toast.context";



interface ToastProviderProps {
    children?: React.ReactNode;
}

let nextToastId = 0;

function generateId() {
    nextToastId++;
    return `toast-${nextToastId}`;
}


export function ToastProvider(props: ToastProviderProps) {
    const [toasts, setToasts] = React.useState<ToastRecord[]>([]);

    const show = React.useCallback((options: ToastOptions) => {
        const id = options.id ?? generateId();

        setToasts((current) => [
            ...current,
            {
                ...options,
                id,
            },
        ]);

        return id;
    }, []);

    const update = React.useCallback(
        (id: string, options: Partial<ToastOptions>) => {
            setToasts((current) =>
                current.map((toast) =>
                    toast.id === id
                        ? {
                            ...toast,
                            ...options,
                            id,
                        }
                        : toast,
                ),
            );
        },
        [],
    );

    const dismiss = React.useCallback((id: string) => {
        setToasts((current) =>
            current.filter((toast) => toast.id !== id),
        );
    }, []);

    const dismissAll = React.useCallback(() => {
        setToasts([]);
    }, []);

    const value = React.useMemo<ToastContextValue>(
        () => ({
            toasts,
            show,
            update,
            dismiss,
            dismissAll,
        }),
        [toasts, show, update, dismiss, dismissAll],
    );

    return (
        <ToastContext.Provider value={value}>
            {props.children}
        </ToastContext.Provider>
    );
}
