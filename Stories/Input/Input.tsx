import React from "@rbxts/react";
import { Container, Input as InputComponent, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Input(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={360}>
            <VStack>
                <InputComponent placeholder="Type here..." value="" />
                <InputComponent placeholder="Small scale" value="" scale="sm" />
                <InputComponent placeholder="Large scale" value="" scale="xl" />
                <InputComponent value="Pre-filled value" />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Input;
