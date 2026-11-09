import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Card, createStory, Text } from "@rbxts/react-clean-ui";
import TextSizeCap from "./TextSizeCap";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <Text text="Text size cap" variant="heading" />
        </Card.Header>
        <Card.Body>
            <TextSizeCap maxTextSize={props.controls.MaxTextSize} />
        </Card.Body>
    </Card>
), {
    MaxTextSize: Number(24, 8, 100),
});
