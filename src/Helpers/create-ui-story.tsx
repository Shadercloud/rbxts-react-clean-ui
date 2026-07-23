import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { DarkTheme, DefaultTheme, SandstoneTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";
import { OverlayProvider, ThemeProvider } from "../Providers/";

const controls = {
    Theme: Choose(["Default", "Dark", "Sandstone"]),
};

type StoryProps = InferProps<typeof controls>;

export function createStory(
    render: (props: StoryProps) => React.ReactNode,
) {
    return {
        react: React,
        reactRoblox: ReactRoblox,
        controls,

        story: (props: StoryProps) => {
            let theme = DefaultTheme;
            if (props.controls.Theme === "Dark")
                theme = DarkTheme
            if (props.controls.Theme === 'Sandstone')
                theme = SandstoneTheme


            return (
                <ThemeProvider theme={theme}>
                    <OverlayProvider>
                        {render(props)}
                    </OverlayProvider>
                </ThemeProvider>
            );
        },
    };
}