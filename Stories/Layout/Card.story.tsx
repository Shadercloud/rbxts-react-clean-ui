import React from "@rbxts/react";
import { Intent, Button, Card, Container, createStory, HStack, Text } from "@rbxts/react-clean-ui";

const Intents = [
    "primary",
    "success",
    "warning",
    "danger",
    "info",
] as const;


export = createStory((props) => (
    <Container width="80%" center>
        <HStack>
            {Intents.map((intent) => {
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

));