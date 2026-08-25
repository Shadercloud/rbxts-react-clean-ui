import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Increment from "./Increment";

export = createStory((props) => (
    <Container center>
        <Box>
            <Increment
                min={props.controls.Min}
                max={props.controls.Max}
                step={props.controls.Step}
            />
        </Box>
    </Container>
), {
    Min: Number(0, -50, 50),
    Max: Number(10, -50, 50),
    Step: Number(1, 0.1, 10, 0.01),
});
