import React from "@rbxts/react";
import { VStack } from "../../src/Components/Layout/VStack";
import { Button } from "../../src/Components/Input/Button";
import { LoomScene } from "../LoomScene";
import { Container } from "../../src/Components/Layout";

export const preview = {
    render: () => (
        <LoomScene>
            <Container>
                <VStack>
                    <Button icon="smile-o" text="Primary" intent="primary" />
                    <Button icon="check" text="Success" intent="success" />
                    <Button icon="info" text="Info" intent="info" />
                    <Button icon="exclamation" text="Warning" intent="warning" />
                    <Button icon="times" text="Danger" intent="danger" />
                </VStack>
            </Container>
        </LoomScene>
    ),
    title: "Form/Buttons",
} as const;
