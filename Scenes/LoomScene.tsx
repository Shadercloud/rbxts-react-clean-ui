import React from "@rbxts/react";
import { CleanUiProvider } from "../src/Providers/app.provider";
import { ToastContainer } from "../src/Components/Interaction/Toast";
import { DefaultTheme } from "../src/Theme/themes/default.theme";
import { SandstoneTheme } from "../src/Theme/themes/sandstone.theme";
import { DarkTheme } from "../src/Theme/themes/dark.theme";
import { WoodenTheme } from "../src/Theme/themes/wooden.theme";
import { ThemeTemplate } from "../src/Theme";

declare const window: {
    location: {
        search: string;
    };
};

declare class URLSearchParams {
    constructor(search: string);

    get(name: string): string | null;
}

interface LoomSceneProps {
    children?: React.ReactNode;
}

function getLoomTheme(): ThemeTemplate {
    const params = new URLSearchParams(window.location.search);
    const componentTheme = params.get("ct");

    if (componentTheme === "sandstone") {
        return SandstoneTheme;
    }

    if (componentTheme === "dark") {
        return DarkTheme;
    }

    if (componentTheme === "wooden") {
        return WoodenTheme;
    }

    return DefaultTheme;
}

export function LoomScene({ children }: LoomSceneProps) {
    const theme = getLoomTheme();

    return (
        <CleanUiProvider theme={theme}>

            {children}


            <ToastContainer />
        </CleanUiProvider>
    );
}

