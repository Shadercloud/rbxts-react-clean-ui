import React from "@rbxts/react";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import SwitchControlled from "./SwitchControlled";

export = createStory((props) => (
    <Container center>
        <Box>
            <VStack>
                <Container LayoutOrder={1}>
                    <Text text="Controlled vs uncontrolled switch" variant="title" />
                </Container>
                <Container LayoutOrder={2}>
                    <SwitchControlled />
                </Container>
            </VStack>
        </Box>
    </Container>
));
