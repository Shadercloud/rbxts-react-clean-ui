import React from "@rbxts/react";
import { Box, Container, CssSize, Grid as GridComponent, ScaleSize, Text } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface GridProps {
    width?: CssSize;
    gap?: ScaleSize | "None";
    screenshot?: boolean;
}

function Grid(props: GridProps = {}) {
    const content = (
        <GridComponent
            name="ResponsiveGrid"
            width={props.width ?? "100%"}
            cols={{ xs: 2, sm: 3, md: 4, lg: 5, xl: 6 }}
            breakpoints={{ xs: 0, sm: 250, md: 400, lg: 550, xl: 700 }}
            gap={props.gap ?? "sm"}
        >
            <Text text="Item 1" />
            <Text text="Item 2" />
            <Box AutomaticSize={Enum.AutomaticSize.Y}>
                <Text text="Taller card content that wraps across a couple of lines." />
            </Box>
            <Text text="Item 4" />
            <Box AutomaticSize={Enum.AutomaticSize.Y}>
                <Text text="Item 5" />
            </Box>
            <Text text="Item 6" />
            <Text text="Item 7" />
            <Box AutomaticSize={Enum.AutomaticSize.Y}>
                <Text text="The tallest cell in the grid — every other cell locks to this height." />
            </Box>
        </GridComponent>
    );

    // Screenshot mode captures a single static image for the docs site, so it
    // needs a concrete pixel-bounded frame for the capture tool to crop to -
    // that's a static-doc-image concern only, not something the live/
    // interactive story below should be anchored to.
    if (props.screenshot) {
        return (
            <ScreenshotFrame>
                <Container width={650}>{content}</Container>
            </ScreenshotFrame>
        );
    }

    return content;
}

export = Grid;
