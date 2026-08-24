import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import InputValidation from "./InputValidation";

export = createStory((props) => (
    <Container center>
        <Box>
            <InputValidation min={props.controls.Min} max={props.controls.Max} />
        </Box>
    </Container>
), {
    Min: Number(0, -100, 100),
    Max: Number(100, 0, 200),
});
