import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { ThemeProvider, DarkTheme, DefaultTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";

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
                    {render(props)}
                </ThemeProvider>
            );
        },
    };
}