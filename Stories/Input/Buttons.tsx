import React from "@rbxts/react";
import { Button, Container, VStack } from "@rbxts/react-clean-ui";

function Buttons() {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack>
            <Button icon="smile-o" text="Primary" intent="primary" />
            <Button icon="check" text="Success" intent="success" />
            <Button icon="info" text="Info" intent="info" />
            <Button icon="exclamation" text="Warning" intent="warning" />
            <Button icon="times" text="Danger" intent="danger" />
        </VStack>
    </Container>
}

export = Buttons;