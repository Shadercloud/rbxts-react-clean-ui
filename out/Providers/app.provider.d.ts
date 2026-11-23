import React from "@rbxts/react";
import { ThemeTemplate } from "../Theme";
interface CleanUiProviderProps {
    children?: React.ReactNode;
    theme: ThemeTemplate;
    toasts?: boolean;
    ignorePreferredTextSize?: boolean;
}
export declare function CleanUiProvider({ children, theme, toasts, ignorePreferredTextSize }: CleanUiProviderProps): React.JSX.Element;
export {};
