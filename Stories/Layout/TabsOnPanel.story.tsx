import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import TabsOnPanel from "./TabsOnPanel";

export = createStory((props) => (
    <Container center>
        <TabsOnPanel fill={props.controls.Fill} />
    </Container>
), {
    Fill: Boolean(false)
});
