import React from "@rbxts/react";
import { CleanTheme } from "./CleanTheme"
import { CleanThemeContext } from "../Contexts/";

interface ThemeProviderProps {
    theme: CleanTheme;
    children?: React.ReactNode;
}

export function ThemeProvider(props: ThemeProviderProps) {
    return (
        <CleanThemeContext.Provider value={props.theme}>
            {props.children}
        </CleanThemeContext.Provider>
    );
}