import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { DarkTheme, DefaultTheme, SandstoneTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";
import { CleanUiProvider } from "../Providers/app.provider";

const controls = {
    Theme: Choose(["Default", "Dark", "Sandstone"]),
};

type StoryControl = Parameters<typeof import("@rbxts/ui-labs").Ordered>[0];
type StoryControls = Record<string, StoryControl>;
type StoryProps<T extends StoryControls> = InferProps<typeof controls & T>;

export function createStory<T extends StoryControls = {}>(
    StoryComponent: (props: StoryProps<T>) => React.ReactNode,
    additionalControls?: T,
) {
    const storyControls = {
        ...additionalControls,
        ...controls,
    } as typeof controls & T;

    return {
        react: React,
        reactRoblox: ReactRoblox,
        controls: storyControls,

        story: (props: StoryProps<T>) => {
            const baseProps = props as unknown as InferProps<typeof controls>;
            let theme = DefaultTheme;
            if (baseProps.controls.Theme === "Dark")
                theme = DarkTheme
            if (baseProps.controls.Theme === 'Sandstone')
                theme = SandstoneTheme


            return (
                <CleanUiProvider theme={theme}>
                    <StoryComponent {...props} />
                </CleanUiProvider>
            );
        },
    };
}
