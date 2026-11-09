import React from "@rbxts/react";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import ButtonPressDown from "./ButtonPressDown";

export = createStory((props) => (
    <Container center width={320}>
        <Box>
            <VStack>
                <Text variant="heading" text='pressOn="down" + onRelease' />
                <ButtonPressDown />
                <Text text="Gamepad ButtonA isn't a press-down input: it fires on Activated as usual and gets no onRelease." />
            </VStack>
        </Box>
    </Container>
));
