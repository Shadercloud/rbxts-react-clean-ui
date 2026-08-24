import React from "@rbxts/react";
import { Box, Button, Container, createStory, HStack, FlexItem, Text, VStack, Input, Fieldset, Select, Icon, Checkbox } from "@rbxts/react-clean-ui";

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
                        <Text text="Country:" />
                    </Fieldset.Label>

                    <Fieldset.Control>
                        <Select max-height="200px" onChange={(index: number) => {
                            print(`Selected Option: ${index}`)
                        }}>
                            <Select.Option text="United Kingdom" />
                            <Select.Option text="United States" />
                            <Select.Option text="Canada">
                                <HStack>
                                    <Icon icon="leaf" color={Color3.fromHex("#000000")} />
                                    <Text text="Canada" />
                                </HStack>
                            </Select.Option>
                            <Select.Option text="Germany" />
                            <Select.Option text="France" />
                            <Select.Option text="Australia" />
                            <Select.Option text="New Zealand" />
                            <Select.Option text="Japan" />
                            <Select.Option text="South Africa" />
                        </Select>
                    </Fieldset.Control>
                </Fieldset>
                <Fieldset checkbox>
                    <Fieldset.Control>
                        <Checkbox intent-checked="success" intent-unchecked="danger" icon-unchecked="times" onChange={(value: boolean) => {
                            print(`Checked: ${value}`)
                        }} />
                    </Fieldset.Control>
                    <Fieldset.Label>
                        <Text text="Are you allowed to play?" />
                    </Fieldset.Label>
                </Fieldset>
                <Container>
                    <Button text="Submit Form" intent="info" icon="arrow-circle-right"></Button>
                </Container>
            </VStack>
        </Box>
    </Container>
    </>
));