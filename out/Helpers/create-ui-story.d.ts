import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { InferProps } from "@rbxts/ui-labs";
declare const controls: {
    Theme: import("@rbxts/ui-labs/src/ControlTypings/Advanced").AdvancedTypes.Choose<"Default" | "Dark">;
};
type StoryProps = InferProps<typeof controls>;
export declare function createStory(render: (props: StoryProps) => React.ReactNode): {
    react: typeof React;
    reactRoblox: typeof ReactRoblox;
    controls: {
        Theme: import("@rbxts/ui-labs/src/ControlTypings/Advanced").AdvancedTypes.Choose<"Default" | "Dark">;
    };
    story: (props: StoryProps) => React.JSX.Element;
};
export {};
