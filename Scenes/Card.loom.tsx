import React from "@rbxts/react";
import { Button } from "../src/Components/Input/Button";
import { Container } from "../src/Components/Layout/Container";
import { HStack } from "../src/Components/Layout/HStack";
import { Text } from "../src/Components/Typography/Text";
import { LoomScene } from "./LoomScene";
import { Card } from "../src/Components/Surface/Card";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="90%" center>
                <Card intent="primary">
                    <Card.Header>
                        <Text variant="heading" text="Player Profile" />
                    </Card.Header>
                    <Card.Body>
                            <Text text="Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts." />
                    </Card.Body>
                    <Card.Footer>
                        <HStack>
                            <Button text="Cancel" />
                            <Button text="Save" intent="success" />
                        </HStack>
                    </Card.Footer>
                </Card>
            </Container>
        </LoomScene >
    ),

    title: "Card",
} as const;
