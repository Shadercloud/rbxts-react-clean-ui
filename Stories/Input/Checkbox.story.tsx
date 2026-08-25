import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, FlexItem, Text, VStack } from "@rbxts/react-clean-ui";
import Checkbox from "./Checkbox";

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
                            <Text text="Checkbox Examples" variant="title" />
                        </FlexItem>
                        <Button icon="times" />
                    </HStack>
                </Container>
                <Checkbox />
                <Container>
                    <Button text="Submit Form" intent="info" icon="arrow-circle-right"></Button>
                </Container>
            </VStack>
        </Box>
    </Container>
));
