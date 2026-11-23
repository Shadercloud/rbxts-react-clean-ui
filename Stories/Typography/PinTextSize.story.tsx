import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Card, createStory, Text } from "@rbxts/react-clean-ui";
import PinTextSize from "./PinTextSize";

export = createStory((props) => (
    <Card width="Auto" center>
        <Card.Header>
            <Text text="Pin text size" variant="heading" />
        </Card.Header>
        <Card.Body>
            <PinTextSize ignorePreferredTextSize={props.controls.IgnorePreferredTextSize} />
        </Card.Body>
    </Card>
), {
    IgnorePreferredTextSize: Boolean(false),
});
