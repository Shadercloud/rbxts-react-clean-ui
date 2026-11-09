import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import SunkWell from "./SunkWell";

export = createStory((props) => (
    <Container center>
        <SunkWell disabled={props.controls.Disabled} />
    </Container>
), {
    Disabled: Boolean(false)
});
