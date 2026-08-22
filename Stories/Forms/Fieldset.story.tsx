import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Fieldset from "./Fieldset";

export = createStory((props) => (
    <Container center>
        <Box>
            <Fieldset width={props.controls.Width} />
        </Box>
    </Container>
), {
    Width: Number(500, 280, 700),
});
