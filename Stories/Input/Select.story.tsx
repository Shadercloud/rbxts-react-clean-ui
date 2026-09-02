import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Select from "./Select";

export = createStory((props) => (
    <Container center>
        <Box>
            <Select searchable={props.controls.Searchable} grouped={props.controls.Grouped} />
        </Box>
    </Container>
), {
    Searchable: Boolean(false),
    Grouped: Boolean(false)
});
