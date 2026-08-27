import React from "@rbxts/react";
import { Fieldset, Input, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface InputValidationProps {
    min?: number;
    max?: number;
    screenshot?: boolean;
}

function InputValidation(props: InputValidationProps = {}) {
    const content = (
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
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = InputValidation;
