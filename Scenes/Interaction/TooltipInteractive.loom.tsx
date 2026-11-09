import React from "@rbxts/react";
import { Tooltip } from "../../src/Components/Interaction/Tooltip";
import { Button } from "../../src/Components/Input/Button";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Text } from "../../src/Components/Typography";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200" center>
                <HStack spacing="lg" valign="Center">
                    <Tooltip
                        interactive
                        placement="Top"
                        content={
                            <>
                                <VStack spacing="sm" />
                                <Text text="Move onto me" LayoutOrder={1} />
                                <Button text="Click me" intent="primary" LayoutOrder={2} />
                            </>
                        }
                    >
                        <Button text="Hover me (Interactive)" />
                    </Tooltip>
                    <Tooltip pinOnPress placement="Top" intent="info" content="Pinned. Click me or the button to close">
                        <Button text="Click me (Pin on press)" intent="info" />
                    </Tooltip>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Interaction/Tooltip Interactive",
} as const;
