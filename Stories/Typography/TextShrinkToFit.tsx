import React from "@rbxts/react";
import { Container, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TextShrinkToFitProps {
    width?: number;
    minScale?: number;
    screenshot?: boolean;
}

const slotBorder = Color3.fromHex("#9AA5B1");

function TextShrinkToFit(props: TextShrinkToFitProps = {}) {
    const width = props.width ?? 220;
    const minScale = props.minScale ?? 0.6;

    const content = (
        <Container width={460}>
            <VStack spacing="md" HorizontalFlex={Enum.UIFlexAlignment.None}>
                <Text text={`shrinkToFit in a ${width}px slot`} variant="label" />
                <Container name="Slot" width={width} borderThickness={1} borderColor={slotBorder}>
                    <Text text="LEGENDARY LOOT" variant="title" letterSpacing={6} shrinkToFit />
                </Container>
                <Text text={`shrinkToFit, shrinkMinScale={${minScale}}`} variant="label" />
                <Container name="SlotWithFloor" width={width} borderThickness={1} borderColor={slotBorder}>
                    <Text text="LEGENDARY LOOT" variant="title" letterSpacing={6} shrinkToFit shrinkMinScale={minScale} />
                </Container>
                <Text text="Without shrinkToFit (overflows)" variant="label" />
                <Container name="SlotWithoutShrink" width={width} borderThickness={1} borderColor={slotBorder}>
                    <Text text="LEGENDARY LOOT" variant="title" letterSpacing={6} />
                </Container>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TextShrinkToFit;
