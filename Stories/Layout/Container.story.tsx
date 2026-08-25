import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { createStory } from "@rbxts/react-clean-ui";
import Container from "./Container";

export = createStory((props) => (
    <Container width={props.controls.Width} />
), {
    Width: Number(420, 200, 600),
});
