import React from "@rbxts/react";
import { Boolean, Choose } from "@rbxts/ui-labs";
import { createStory } from "@rbxts/react-clean-ui";
import UiScaleRoot from "./UiScaleRoot";

export = createStory(
    (props) => (
        <UiScaleRoot
            scale={props.controls.Scale}
            overlayInside={props.controls.OverlayInsideRoot}
            width="100%"
            height="100%"
        />
    ),
    {
        Scale: Choose([1, 1.25, 1.5], 0),
        OverlayInsideRoot: Boolean(true),
    },
);
