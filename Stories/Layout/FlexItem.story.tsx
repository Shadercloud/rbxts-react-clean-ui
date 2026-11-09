import React from "@rbxts/react";
import { EnumList } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import FlexItem from "./FlexItem";

export = createStory((props) => (
    <Container center>
        <Box>
            <FlexItem direction={props.controls.Direction} />
        </Box>
    </Container>
), {
    Direction: EnumList<"horizontal" | "vertical">(
        {
            Vertical: "vertical",
            Horizontal: "horizontal",
        },
        "Vertical",
    ),
});
