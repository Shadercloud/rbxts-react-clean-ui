import React from "@rbxts/react";
import { Boolean, Slider } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import RadialMenu from "./RadialMenu";

export = createStory((props) => (
    <Container center>
        <Box>
            <RadialMenu
                size={props.controls.Size}
                thickness={props.controls.Thickness}
                showLabels={props.controls.ShowLabels}
                controlled={props.controls.Controlled}
            />
        </Box>
    </Container>
), {
    Size: Slider(280, 160, 480, 1),
    Thickness: Slider(36, 10, 60, 1),
    ShowLabels: Boolean(false),
    Controlled: Boolean(false),
});
