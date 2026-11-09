import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import ScrollerInfinite from "./ScrollerInfinite";

export = createStory((props) => (
    <Container center>
        <Box>
            <VStack>
                <Text text="Infinite list" variant="heading" />
                <ScrollerInfinite nearEndThreshold={props.controls.NearEndThreshold} maxItems={props.controls.MaxItems} />
            </VStack>
        </Box>
    </Container>
), {
    NearEndThreshold: Number(40, 0, 200, 10),
    MaxItems: Number(60, 15, 150, 15),
});
