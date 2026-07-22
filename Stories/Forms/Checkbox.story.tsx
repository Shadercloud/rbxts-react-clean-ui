import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, FlexItem, Text, VStack, Input, Fieldset, Select, Icon, Checkbox } from "@rbxts/react-clean-ui";

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
                <Fieldset checkbox>
                    <Fieldset.Control>
                        <Checkbox onChange={(value: boolean) => {
                            print(`Checked: ${value}`)
                        }} />
                    </Fieldset.Control>
                    <Fieldset.Label>
                        <Text text="Default checkbox settings" />
                    </Fieldset.Label>
                </Fieldset>
                <Fieldset checkbox>
                    <Fieldset.Control>
                        <Checkbox scale="xl" spacing="xl" />
                    </Fieldset.Control>
                    <Fieldset.Label>
                        <Text text="<b>xl</b> Scale and Spacing" />
                    </Fieldset.Label>
                </Fieldset>
                <Fieldset checkbox>
                    <Fieldset.Control>
                        <Checkbox scale="xs" spacing="xl" />
                    </Fieldset.Control>
                    <Fieldset.Label>
                        <Text text="<b>xs</b> Scale with <b>xl</b> Spacing" />
                    </Fieldset.Label>
                </Fieldset>
                <Fieldset checkbox>
                    <Fieldset.Control>
                        <Checkbox icon-checked="thumbs-up" icon-unchecked="thumbs-down" intent-checked="info" intent-unchecked="danger" />
                    </Fieldset.Control>
                    <Fieldset.Label>
                        <Text text="Custom icons and colors" />
                    </Fieldset.Label>
                </Fieldset>
                <Container>
                    <Button text="Submit Form" intent="info" icon="arrow-circle-right"></Button>
                </Container>
            </VStack>
        </Box>
    </Container>
));