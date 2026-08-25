import React from "@rbxts/react";
import { CleanThemeContext } from "../Contexts/";
import { ThemeTemplate } from "../Theme";

interface ThemeProviderProps {
    theme: ThemeTemplate;
    children?: React.ReactNode;
}

export function ThemeProvider(props: ThemeProviderProps) {
    return (
        <CleanThemeContext.Provider value={props.theme}>
            {props.children}
        </CleanThemeContext.Provider>
    );
}