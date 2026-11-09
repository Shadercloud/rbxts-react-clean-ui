import React from "@rbxts/react";
import { Container, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TextMaxWidthProps {
    maxWidth?: number;
    screenshot?: boolean;
}

const longText = "This long sentence auto-sizes to its text, but once it reaches maxWidth it wraps onto more lines and grows taller instead.";

function TextMaxWidth(props: TextMaxWidthProps = {}) {
    const maxWidth = props.maxWidth ?? 240;

    const content = (
        <Container width={760}>
            <VStack spacing="md">
                <Text text="Without maxWidth" variant="label" />
                <Text text={longText} />
                <Text text={`maxWidth={${maxWidth}}`} variant="label" />
                <Text text={longText} maxWidth={maxWidth} />
                <Text text={`Short text, same maxWidth={${maxWidth}}`} variant="label" />
                <Text text="Stays natural width" maxWidth={maxWidth} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TextMaxWidth;
