import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, FlexItem, Text, VStack } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <Container
        width="75%"
        center="50%"
    >
        <Box>
            <VStack>
                <Container>
                    <HStack>
                        <FlexItem>
                            <Text text="Enter Your Details" variant="title" />
                        </FlexItem>
                        <Button icon="times" />
                    </HStack>
                </Container>
                <Text text="Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." />
                <Container>
                    <HStack>
                        <FlexItem>
                            <Button text="Information" intent="info" icon="info-circle" scale="xl"></Button>
                        </FlexItem>
                        <Button text="Continue" intent="success" icon="arrow-circle-right"></Button>
                        <Button text="Save" intent="warning" icon="floppy"></Button>
                    </HStack>
                </Container>
            </VStack>
        </Box>
    </Container>
));