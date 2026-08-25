import React from "@rbxts/react";
import { Choose } from "@rbxts/ui-labs";
import { Card, Container, createStory, HStack, Intent, Text } from "@rbxts/react-clean-ui";
import Toast from "./Toast";

export = createStory((props) => (
    <Container center>
        <Card>
            <Card.Header>
                <HStack valign="Center">
                    <Text text="Toast Demo" variant="heading" />
                </HStack>
            </Card.Header>
            <Card.Body>
                <Toast intent={props.controls.Intent as Intent} />
            </Card.Body>
        </Card>
    </Container>
), {
    Intent: Choose(["primary", "success", "info", "warning", "danger"]),
});
