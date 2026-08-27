import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { InferProps } from "@rbxts/ui-labs";
declare const controls: {
    Theme: import("@rbxts/ui-labs/src/ControlTypings/Advanced").AdvancedTypes.Choose<"Default" | "Dark" | "Sandstone" | "Wooden">;
};
type StoryControl = Parameters<typeof import("@rbxts/ui-labs").Ordered>[0];
type StoryControls = Record<string, StoryControl>;
type StoryProps<T extends StoryControls> = InferProps<typeof controls & T>;
export declare function createStory<T extends StoryControls = {}>(StoryComponent: (props: StoryProps<T>) => React.ReactNode, additionalControls?: T): {
    react: typeof React;
    reactRoblox: typeof ReactRoblox;
    controls: {
        Theme: import("@rbxts/ui-labs/src/ControlTypings/Advanced").AdvancedTypes.Choose<"Default" | "Dark" | "Sandstone" | "Wooden">;
    } & T;
    story: (props: StoryProps<T>) => React.JSX.Element;
};
export {};
