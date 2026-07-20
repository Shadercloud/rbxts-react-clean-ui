import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, FlexItem, Text, VStack, Input, Fieldset } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <><Container
        width="90%"
        center
    >
        <Box>
            <VStack>
                <Container>
                    <HStack>
                        <FlexItem>
                            <Text text="Basic Form" variant="title" />
                        </FlexItem>
                        <Button icon="times" />
                    </HStack>
                </Container>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Enter Name:" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Input
                            placeholder="John Doe"
                            value="" />
                    </Fieldset.Control>
                </Fieldset>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Enter Delivery Address:" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Input
                            placeholder="123 Main Street"
                            value="" />
                    </Fieldset.Control>
                </Fieldset>
                <Container>
                    <Button text="Submit Form" intent="info" icon="arrow-circle-right"></Button>
                </Container>
            </VStack>
        </Box>
    </Container>
    </>
));