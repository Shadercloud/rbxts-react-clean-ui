import React from "@rbxts/react";
import { Button, Card, createStory, HStack, Text } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <Card intent="primary" width="Auto" center>
        <Card.Header>
            <Text variant="heading" text="Player Profile" />
        </Card.Header>
        <Card.Body>
            <frame Size={UDim2.fromOffset(600, 400)} />
        </Card.Body>
        <Card.Footer>
            <HStack>
                <Button text="Cancel" />
                <Button text="Save" intent="success" />
            </HStack>
        </Card.Footer>
    </Card>

));