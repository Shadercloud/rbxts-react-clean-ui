import React from "@rbxts/react";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import BadgeClickable from "./BadgeClickable";

export = createStory((props) => (
    <Container center>
        <Box>
            <BadgeClickable />
        </Box>
    </Container>
));
