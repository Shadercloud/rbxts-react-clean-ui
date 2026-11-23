import React from "@rbxts/react";
import { UiScaleRoot } from "../../src/Components/Layout/UiScaleRoot";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { Button } from "../../src/Components/Input/Button";
import { Text } from "../../src/Components/Typography/Text";
import { useUiScale } from "../../src/Contexts";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

function ScalePanel() {
    const scale = useUiScale();

    return (
        <Box>
            <VStack>
                <Text text={`useUiScale(): ${scale}`} />
                <Button text="Button" />
            </VStack>
        </Box>
    );
}

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200">
                <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill}>
                    <Container height="200">
                        <UiScaleRoot scale={1}>
                            <ScalePanel />
                        </UiScaleRoot>
                    </Container>
                    <Container height="200">
                        <UiScaleRoot scale={1.5}>
                            <ScalePanel />
                        </UiScaleRoot>
                    </Container>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Ui Scale Root",
} as const;
