import React from "@rbxts/react";
import { Container, Input as InputComponent, VStack } from "@rbxts/react-clean-ui";

function Input() {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={360}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack>
            <InputComponent placeholder="Type here..." value="" />
            <InputComponent placeholder="Small scale" value="" scale="sm" />
            <InputComponent placeholder="Large scale" value="" scale="xl" />
            <InputComponent value="Pre-filled value" />
        </VStack>
    </Container>
}

export = Input;
