import React from "@rbxts/react";
import { Box, Container, Scroller as ScrollerComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ScrollerStory(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={320} height={240}>
            <Box>
                <ScrollerComponent width="100%" height="200" spacing="sm">
                    <VStack spacing="sm">
                        <Text text="Item 1" />
                        <Text text="Item 2" />
                        <Text text="Item 3" />
                        <Text text="Item 4" />
                        <Text text="Item 5" />
                        <Text text="Item 6" />
                        <Text text="Item 7" />
                        <Text text="Item 8" />
                        <Text text="Item 9" />
                        <Text text="Item 10" />
                    </VStack>
                </ScrollerComponent>
            </Box>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ScrollerStory;
