import React from "@rbxts/react";
import { Container } from "../src/Components/Layout/Container";
import { LoomScene } from "./LoomScene";
import { Box } from "../src/Components/Surface/Box";
import { Input } from "../src/Components/Input/Input";
import { Button } from "../src/Components/Input/Button";
import { Checkbox } from "../src/Components/Input/Checkbox";
import { Select } from "../src/Components/Input/Select";
import { VStack, HStack, FlexItem, Fieldset } from "../src/Components/Layout";
import { Icon } from "../src/Components/Surface";
import { Text } from "../src/Components/Typography";

export const preview = {
    render: () => (
        <LoomScene>
            <Container
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
        </LoomScene >
    ),

    title: "Card",
} as const;
