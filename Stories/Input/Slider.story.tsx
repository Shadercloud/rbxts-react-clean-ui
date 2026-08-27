import React from "@rbxts/react";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import Slider from "./Slider";

export = createStory((props) => (
    <Container
        width="90%"
        center
    >
        <Box>
            <VStack>
                <Container>
                    <Text text="Slider Example" variant="heading" />
                </Container>

                <Slider />
            </VStack>
        </Box>
    </Container>
));
