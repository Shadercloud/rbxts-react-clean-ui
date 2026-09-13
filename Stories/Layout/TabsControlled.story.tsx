import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import TabsControlled from "./TabsControlled";

export = createStory((props) => (
    <Container center>
        <Box>
            <TabsControlled fill={props.controls.Fill} />
        </Box>
    </Container>
), {
    Fill: Boolean(false)
});
