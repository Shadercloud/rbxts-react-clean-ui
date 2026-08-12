import React from "@rbxts/react";
import { Button, Container, VStack } from "@rbxts/react-clean-ui";

export function Buttons() {
    return <Container>
        <VStack>
            <Button icon="smile-o" text="Primary" intent="primary" />
            <Button icon="check" text="Success" intent="success" />
            <Button icon="info" text="Info" intent="info" />
            <Button icon="exclamation" text="Warning" intent="warning" />
            <Button icon="times" text="Danger" intent="danger" />
        </VStack>
    </Container>
}