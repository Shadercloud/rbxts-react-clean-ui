import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import ContainerMaxWidth from "./ContainerMaxWidth";

export = createStory((props) => (
    <Container center>
        <ContainerMaxWidth pageWidth={props.controls.PageWidth} maxWidth={props.controls.MaxWidth} />
    </Container>
), {
    PageWidth: Number(800, 300, 1000),
    MaxWidth: Number(600, 200, 1000),
});
