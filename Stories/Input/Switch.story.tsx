import React from "@rbxts/react";
import { Box, Container, createStory, HStack, FlexItem, Text, VStack } from "@rbxts/react-clean-ui";
import Switch from "./Switch";

export = createStory((props) => (
    <Container
        width="90%"
        center
    >
        <Box>
            <VStack>
                <Container>
                    <HStack>
                        <FlexItem>
                            <Text text="Switch Examples" variant="title" />
                        </FlexItem>
                    </HStack>
                </Container>
                <Switch />
            </VStack>
        </Box>
    </Container>
));
