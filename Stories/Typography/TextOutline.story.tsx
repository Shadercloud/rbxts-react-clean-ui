import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Card, createStory, Text } from "@rbxts/react-clean-ui";
import TextOutline from "./TextOutline";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <Text text="Text outline" variant="heading" />
        </Card.Header>
        <Card.Body>
            <TextOutline thickness={props.controls.Thickness} />
        </Card.Body>
    </Card>
), {
    Thickness: Number(2, 0, 6, 0.5),
});
