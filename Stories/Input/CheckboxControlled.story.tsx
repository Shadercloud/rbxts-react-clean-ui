import React from "@rbxts/react";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import CheckboxControlled from "./CheckboxControlled";

export = createStory((props) => (
    <Container center>
        <Box>
            <VStack>
                <Container LayoutOrder={1}>
                    <Text text="Controlled vs uncontrolled checkbox" variant="title" />
                </Container>
                <Container LayoutOrder={2}>
                    <CheckboxControlled />
                </Container>
            </VStack>
        </Box>
    </Container>
));
