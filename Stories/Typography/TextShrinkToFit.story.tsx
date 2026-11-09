import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Card, createStory, Text } from "@rbxts/react-clean-ui";
import TextShrinkToFit from "./TextShrinkToFit";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <Text text="Text shrinkToFit" variant="heading" />
        </Card.Header>
        <Card.Body>
            <TextShrinkToFit width={props.controls.Width} minScale={props.controls.MinScale} />
        </Card.Body>
    </Card>
), {
    Width: Number(220, 60, 460),
    MinScale: Number(0.6, 0, 1, 0.05),
});
