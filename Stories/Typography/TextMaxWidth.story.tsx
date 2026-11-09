import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Card, createStory, Text } from "@rbxts/react-clean-ui";
import TextMaxWidth from "./TextMaxWidth";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <Text text="Text maxWidth" variant="heading" />
        </Card.Header>
        <Card.Body>
            <TextMaxWidth maxWidth={props.controls.MaxWidth} />
        </Card.Body>
    </Card>
), {
    MaxWidth: Number(240, 80, 700),
});
