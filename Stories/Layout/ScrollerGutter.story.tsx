import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import ScrollerGutter from "./ScrollerGutter";

export = createStory((props) => (
    <Container center>
        <Box>
            <HStack Wraps={false}>
                <VStack>
                    <Text text="Default" variant="heading" />
                    <ScrollerGutter stableGutter={false} itemCount={props.controls.Items} />
                </VStack>
                <VStack>
                    <Text text="stableGutter" variant="heading" />
                    <ScrollerGutter stableGutter itemCount={props.controls.Items} />
                </VStack>
            </HStack>
        </Box>
    </Container>
), {
    Items: Number(3, 1, 12, 1),
});
