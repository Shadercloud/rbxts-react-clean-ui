import React from "@rbxts/react";
import { Boolean, Number } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import Scroller from "./Scroller";

export = createStory((props) => (
    <Container center>
        <Scroller maxHeight={props.controls.MaxHeight} decorated={props.controls.Decorated} />
    </Container>
), {
    MaxHeight: Number(200, 60, 200),
    Decorated: Boolean(false),
});
