import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Input from "./Input";

export = createStory((props) => (
    <Container center>
        <Box>
            <Input disabled={props.controls.Disabled} />
        </Box>
    </Container>
), {
    Disabled: Boolean(false)
});
