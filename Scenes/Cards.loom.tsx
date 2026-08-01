import React from "@rbxts/react";
import { Button } from "../src/Components/Input/Button";
import { Container } from "../src/Components/Layout/Container";
import { HStack } from "../src/Components/Layout/HStack";
import { Text } from "../src/Components/Typography/Text";
import { LoomScene } from "./LoomScene";
import { Intent } from "../src/Interfaces/clean.element.props";
import { Card } from "../src/Components/Surface/Card";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="90%" center>
                <HStack>
                    {[
                        "primary",
                        "success",
                        "warning",
                        "danger",
                        "info",
                    ].map((intent) => {
                        return <Container width="45%">
                            <Card intent={intent as Intent}>
                                <Card.Header>
                                    <Text variant="heading" text="Player Profile" />
                                </Card.Header>
                                <Card.Body>
                                    <Text text="View player information, statistics, and recent activity." />
                                </Card.Body>
                                <Card.Footer>
                                    <HStack>
                                        <Button text="Cancel" />
                                        <Button text="Save" intent="success" />
                                    </HStack>
                                </Card.Footer>
                            </Card>
                        </Container>
                    })}
                </HStack>
            </Container>
        </LoomScene>
    ),

    title: "Button",
} as const;
