import React from "@rbxts/react";
import { ThemeTemplate } from "../Theme";
interface ThemeProviderProps {
    theme: ThemeTemplate;
    children?: React.ReactNode;
}
export declare function ThemeProvider(props: ThemeProviderProps): React.JSX.Element;
export {};
