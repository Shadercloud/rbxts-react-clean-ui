import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { DarkTheme, DefaultTheme, SandstoneTheme, WoodenTheme } from "../Theme";
import { InferProps, Choose } from "@rbxts/ui-labs";
import { CleanUiProvider } from "../Providers/app.provider";

const THEME_ATTRIBUTE = "UILabsSelectedTheme";
const themeControl = Choose(["Default", "Dark", "Sandstone", "Wooden"]);
const persistedTheme = script.GetAttribute(THEME_ATTRIBUTE);

function isThemeName(value: unknown): value is typeof themeControl.ControlValue {
    return typeIs(value, "string") && themeControl.List.some((theme) => theme === value);
}

if (isThemeName(persistedTheme)) {
    themeControl.ControlValue = persistedTheme;
}

const controls = {
    Theme: themeControl,
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
            script.SetAttribute(THEME_ATTRIBUTE, baseProps.controls.Theme);

            let theme = DefaultTheme;
            if (baseProps.controls.Theme === "Dark")
                theme = DarkTheme
            if (baseProps.controls.Theme === 'Sandstone')
                theme = SandstoneTheme
            if (baseProps.controls.Theme === 'Wooden')
                theme = WoodenTheme

            return (
                <CleanUiProvider theme={theme}>
                    <StoryComponent {...props} />
                </CleanUiProvider>
            );
        },
    };
}
