import React from "@rbxts/react";
import { Fieldset } from "../../src/Components/Layout/Fieldset";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";
import { Input } from "../../src/Components/Input/Input";
import { Select } from "../../src/Components/Input/Select";
import { Checkbox } from "../../src/Components/Input/Checkbox";
import { Text } from "../../src/Components/Typography";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="220" center>
                <Box>
                    <VStack>
                        <Fieldset>
                            <Fieldset.Label>
                                <Text text="Enter Name:" />
                            </Fieldset.Label>
                            <Fieldset.Control>
                                <Input placeholder="John Doe" value="" />
                            </Fieldset.Control>
                        </Fieldset>
                        <Fieldset>
                            <Fieldset.Label>
                                <Text text="Country:" />
                            </Fieldset.Label>
                            <Fieldset.Control>
                                <Select onChange={(index: number) => {
                                    print(`Selected Option: ${index}`);
                                }}>
                                    <Select.Option text="United Kingdom" />
                                    <Select.Option text="United States" />
                                    <Select.Option text="Canada" />
                                </Select>
                            </Fieldset.Control>
                        </Fieldset>
                        <Fieldset checkbox>
                            <Fieldset.Control>
                                <Checkbox intent-checked="success" intent-unchecked="danger" icon-unchecked="times" onChange={(value: boolean) => {
                                    print(`Checked: ${value}`);
                                }} />
                            </Fieldset.Control>
                            <Fieldset.Label>
                                <Text text="Subscribe to updates?" />
                            </Fieldset.Label>
                        </Fieldset>
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Fieldset",
} as const;
