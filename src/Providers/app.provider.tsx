import React from "@rbxts/react";
import { ThemeTemplate } from "../Theme";
import { ToastContainer } from "../Components/Interaction/Toast";
import { RegistryProvider } from "./registry.provider";
import { ThemeProvider } from "./theme.provider";
import { OverlayProvider } from "./overlay.provider";
import { ToastProvider } from "./toast.provider";

interface CleanUiProviderProps {
    children?: React.ReactNode;
    theme: ThemeTemplate;
    toasts?: boolean;
}

export function CleanUiProvider({ children, theme, toasts = true }: CleanUiProviderProps) {
    return (
        <RegistryProvider>
            <ThemeProvider theme={theme}>
                <OverlayProvider>
                    <ToastProvider>
                        {children}
                        {toasts && <ToastContainer />}
                    </ToastProvider>
                </OverlayProvider>
            </ThemeProvider>
        </RegistryProvider>
    );
}