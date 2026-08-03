import React from "@rbxts/react";
import { Button, Card, Container, createStory, HStack, Text } from "@rbxts/react-clean-ui";

export = createStory((props) => (
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

));