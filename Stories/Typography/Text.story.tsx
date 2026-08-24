import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Card, createStory, Text as TextComponent } from "@rbxts/react-clean-ui";
import Text from "./Text";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <TextComponent text="Text" variant="heading" />
        </Card.Header>
        <Card.Body>
            <Text wrap={props.controls.Wrap} />
        </Card.Body>
    </Card>
), {
    Wrap: Boolean(true),
});
