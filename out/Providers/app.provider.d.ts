import React from "@rbxts/react";
import { ThemeTemplate } from "../Theme";
interface CleanUiProviderProps {
    children?: React.ReactNode;
    theme: ThemeTemplate;
    toasts?: boolean;
}
export declare function CleanUiProvider({ children, theme, toasts }: CleanUiProviderProps): React.JSX.Element;
export {};
