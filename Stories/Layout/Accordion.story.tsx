import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Accordion from "./Accordion";

export = createStory((props) => (
    
            <Accordion collapsible={props.controls.Collapsible} animationDuration={props.controls.Animation ? undefined : 0} />

), {
    Collapsible: Boolean(false),
    Animation: Boolean(true),
});
