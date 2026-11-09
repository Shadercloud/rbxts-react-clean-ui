import React from "@rbxts/react";
import { Box, CleanThemeContext, Container, DeepPartial, extendTheme, Scroller as ScrollerComponent, Text, ThemeProvider, ThemeTemplate, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const decoratedOverrides: DeepPartial<ThemeTemplate> = {
    components: {
        scroller: {
            trackColor: Color3.fromHex("#000000"),
            trackTransparency: 0.85,
            thumbBorderThickness: 2,
            thumbBorderColor: Color3.fromHex("#1B1B1B"),
        },
    },
};

function ScrollerStory(props: { maxHeight?: number; decorated?: boolean; screenshot?: boolean } = {}) {
    const activeTheme = React.useContext(CleanThemeContext);
    const decoratedTheme = React.useMemo(() => extendTheme(activeTheme, decoratedOverrides), [activeTheme]);

    const scroller = (
        <ScrollerComponent width="100%" height="200" maxHeight={props.maxHeight} spacing="sm">
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
    );

    const content = (
        <Container width={320} height={240}>
            <Box>
                {props.decorated ? <ThemeProvider theme={decoratedTheme}>{scroller}</ThemeProvider> : scroller}
            </Box>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ScrollerStory;
