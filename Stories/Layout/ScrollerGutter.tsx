import React from "@rbxts/react";
import { Box, Container, Scroller as ScrollerComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ScrollerGutter(props: { stableGutter?: boolean; itemCount?: number; screenshot?: boolean } = {}) {
    const itemCount = props.itemCount ?? 3;

    const rows: React.ReactElement[] = [];
    for (let index = 1; index <= itemCount; index++) {
        rows.push(
            <Box key={`Row${index}`} width="100%" spacing="sm" LayoutOrder={index}>
                <Text text={`Row ${index}`} />
            </Box>,
        );
    }

    const content = (
        <Container width={220} height={160}>
            <ScrollerComponent width="100%" height="160" spacing="sm" stableGutter={props.stableGutter ?? true}>
                <VStack spacing="sm">{rows}</VStack>
            </ScrollerComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ScrollerGutter;
