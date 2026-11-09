import React from "@rbxts/react";
import { Button, Container, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ButtonSizing(props: { screenshot?: boolean }) {
    const content = (
        <Container width={360}>
            <VStack HorizontalFlex={Enum.UIFlexAlignment.None}>
                <Text text="fill" />
                <Container width={360}>
                    <HStack>
                        <Button fill text="OK" intent="primary" />
                        <Button fill text="Cancel" intent="secondary" />
                        <Button fill icon="check" text="Save and continue" intent="success" />
                    </HStack>
                </Container>
                <Text text="width={120}" />
                <Button width={120} text="Play" intent="primary" />
                <Text text='width="50%"' />
                <Button width="50%" icon="smile-o" text="Half width" intent="info" />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ButtonSizing;
