import React from "@rbxts/react";
import { CleanTheme } from "../Theme";
interface CleanUiProviderProps {
    children?: React.ReactNode;
    theme: CleanTheme;
    toasts?: boolean;
}
export declare function CleanUiProvider({ children, theme, toasts }: CleanUiProviderProps): React.JSX.Element;
export {};
