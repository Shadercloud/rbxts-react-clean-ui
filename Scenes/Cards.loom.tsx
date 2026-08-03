import React from "@rbxts/react";
import { Button } from "../src/Components/Input/Button";
import { Container } from "../src/Components/Layout/Container";
import { HStack } from "../src/Components/Layout/HStack";
import { Text } from "../src/Components/Typography/Text";
import { LoomScene } from "./LoomScene";
import { Intent } from "../src/Interfaces/clean.element.props";
import { Card } from "../src/Components/Surface/Card";
import { Row } from "../src/Components/Layout/Row";
import { Column } from "../src/Components/Layout/Column";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" center>
                <Row>
                    {[
                        "primary",
                        "success",
                        "warning",
                        "danger",
                        "info",
                    ].map((intent) => {
                        return <Column span={6}>
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
                        </Column>
                    })}
                </Row>
            </Container>
        </LoomScene>
    ),

    title: "Cards",
} as const;
