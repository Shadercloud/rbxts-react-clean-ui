import React from "@rbxts/react";
import { Container, Fieldset, Input, Text, VStack } from "@rbxts/react-clean-ui";

interface InputValidationProps {
    min?: number;
    max?: number;
}

function InputValidation(props: InputValidationProps = {}) {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack>
            <Fieldset>
                <Fieldset.Label>
                    <Text text="Telephone:" />
                </Fieldset.Label>
                <Fieldset.Control>
                    <Input placeholder="+1 (555) 123-4567" value="" validation="Telephone" />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text="Alphanumeric:" />
                </Fieldset.Label>
                <Fieldset.Control>
                    <Input placeholder="abc123" value="" validation="Alphanumeric" />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text="Email:" />
                </Fieldset.Label>
                <Fieldset.Control>
                    <Input placeholder="name@example.com" value="" validation="Email" />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Number (min ${props.min ?? 0}, max ${props.max ?? 100}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <Input placeholder="Enter a number" value="" validation="Number" min={props.min ?? 0} max={props.max ?? 100} />
                </Fieldset.Control>
            </Fieldset>
        </VStack>
    </Container>
}

export = InputValidation;
