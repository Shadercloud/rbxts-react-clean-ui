import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { DarkTheme, DefaultTheme, SandstoneTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";
import { CleanUiProvider } from "../Providers/app.provider";

const controls = {
    Theme: Choose(["Default", "Dark", "Sandstone"]),
};

type StoryProps = InferProps<typeof controls>;

export function createStory(
    StoryComponent: (props: StoryProps) => React.ReactNode,
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
                <CleanUiProvider theme={theme}>
                    <StoryComponent {...props} />
                </CleanUiProvider>
            );
        },
    };
}