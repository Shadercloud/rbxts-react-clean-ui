import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { DarkTheme, DefaultTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";
import { OverlayProvider, ThemeProvider } from "../Providers/";

const controls = {
    Theme: Choose(["Default", "Dark"]),
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
            const theme =
                props.controls.Theme === "Dark"
                    ? DarkTheme
                    : DefaultTheme;

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