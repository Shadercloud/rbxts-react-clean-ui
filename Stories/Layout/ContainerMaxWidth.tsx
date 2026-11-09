import React from "@rbxts/react";
import { Container, Text } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface ContainerMaxWidthProps {
    pageWidth?: number;
    maxWidth?: number;
    screenshot?: boolean;
}

function ContainerMaxWidth(props: ContainerMaxWidthProps = {}) {
    const content = (
        <Container
            width={props.pageWidth ?? 800}
            padding="12"
            borderThickness={2}
            borderColor={Color3.fromHex("#8A8F98")}
        >
            <Container
                width="100%"
                maxWidth={props.maxWidth ?? 600}
                padding="12"
                cornerRadius="md"
                BackgroundColor3={Color3.fromHex("#4A7AC9")}
                BackgroundTransparency={0}
            >
                <Text text={`width="100%" maxWidth={${props.maxWidth ?? 600}}`} />
            </Container>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ContainerMaxWidth;
