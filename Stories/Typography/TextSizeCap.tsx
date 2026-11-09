import React from "@rbxts/react";
import { Container, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TextSizeCapProps {
    maxTextSize?: number;
    screenshot?: boolean;
}

const boxBorder = Color3.fromHex("#9AA5B1");
const fill = UDim2.fromScale(1, 1);

function TextSizeCap(props: TextSizeCapProps = {}) {
    const maxTextSize = props.maxTextSize ?? 24;

    const content = (
        <Container width={540}>
            <HStack spacing="md">
                <VStack spacing="sm">
                    <Text text="TextScaled, uncapped" variant="label" />
                    <Container name="Uncapped" width={260} height={160} borderThickness={1} borderColor={boxBorder}>
                        <Text text="Scaled text" TextScaled Size={fill} AutomaticSize={Enum.AutomaticSize.None} align="Center" />
                    </Container>
                </VStack>
                <VStack spacing="sm">
                    <Text text={`maxTextSize={${maxTextSize}}`} variant="label" />
                    <Container name="Capped" width={260} height={160} borderThickness={1} borderColor={boxBorder}>
                        <Text text="Scaled text" TextScaled Size={fill} AutomaticSize={Enum.AutomaticSize.None} align="Center" minTextSize={8} maxTextSize={maxTextSize} />
                    </Container>
                </VStack>
            </HStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TextSizeCap;
