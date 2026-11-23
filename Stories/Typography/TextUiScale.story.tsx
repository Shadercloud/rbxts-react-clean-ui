import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { createStory } from "@rbxts/react-clean-ui";
import TextUiScale from "./TextUiScale";

export = createStory(
    (props) => <TextUiScale scale={props.controls.Scale} width="100%" height="100%" />,
    {
        Scale: Number(1, 0.5, 4, 0.25),
    },
);
