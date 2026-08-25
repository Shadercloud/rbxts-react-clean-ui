import React from "@rbxts/react";
import { Box, Container, createStory, Text } from "@rbxts/react-clean-ui";
import Slider from "./Slider";

export = createStory((props) => (
    <Container
        width="90%"
        center
    >
        <Box>
            <Container>
                <Text text="Slider Example" variant="heading" />
            </Container>
            <Slider />
        </Box>
    </Container>
));
