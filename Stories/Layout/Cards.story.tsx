import React from "@rbxts/react";
import { Intent, Button, Card, Container, createStory, HStack, Text, Column, Row } from "@rbxts/react-clean-ui";

export = createStory((props) => (
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

));