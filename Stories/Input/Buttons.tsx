import React from "@rbxts/react";
import { Button, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Buttons(props: {disabled?: boolean; screenshot?: boolean}) {
    const content = (
        <VStack>
            <Button icon="smile-o" text="Primary" intent="primary" disabled={props.disabled} />
            <Button icon="check" text="Success" intent="success" disabled={props.disabled} />
            <Button icon="info" text="Info" intent="info" disabled={props.disabled} />
            <Button icon="exclamation" text="Warning" intent="warning" disabled={props.disabled} />
            <Button icon="times" text="Danger" intent="danger" disabled={props.disabled} />
        </VStack>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Buttons;