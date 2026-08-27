import React from "@rbxts/react";
import { Checkbox, Container, Fieldset as FieldsetComponent, Input, Select, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface FieldsetProps {
    width?: number;
    screenshot?: boolean;
}

function Fieldset(props: FieldsetProps = {}) {
    const content = (
        <Container width={props.width ?? 500}>
            <VStack>
                <FieldsetComponent>
                    <FieldsetComponent.Label>
                        <Text text="Name:" />
                    </FieldsetComponent.Label>
                    <FieldsetComponent.Control>
                        <Input placeholder="Jane Doe" value="" />
                    </FieldsetComponent.Control>
                </FieldsetComponent>
                <FieldsetComponent>
                    <FieldsetComponent.Label>
                        <Text text="Country:" />
                    </FieldsetComponent.Label>
                    <FieldsetComponent.Control>
                        <Select>
                            <Select.Option text="United Kingdom" />
                            <Select.Option text="United States" />
                            <Select.Option text="Canada" />
                        </Select>
                    </FieldsetComponent.Control>
                </FieldsetComponent>
                <FieldsetComponent checkbox>
                    <FieldsetComponent.Control>
                        <Checkbox />
                    </FieldsetComponent.Control>
                    <FieldsetComponent.Label>
                        <Text text="Send me updates" />
                    </FieldsetComponent.Label>
                </FieldsetComponent>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Fieldset;
