import React from "@rbxts/react";
import { Checkbox, Container, Fieldset as FieldsetComponent, Input, Select, Text, VStack } from "@rbxts/react-clean-ui";

interface FieldsetProps {
    width?: number;
}

function Fieldset(props: FieldsetProps = {}) {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={props.width ?? 500}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
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
}

export = Fieldset;
