import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import Buttons from "./Buttons";



export = createStory((props) => (
    <Container center>
        <Buttons disabled={props.controls.Disabled} />
    </Container>
), {
    Disabled: Boolean(false)
});