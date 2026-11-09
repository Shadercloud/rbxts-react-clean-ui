import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200" padding="12">
                <VStack
                    HorizontalFlex={Enum.UIFlexAlignment.None}
                    HorizontalAlignment={Enum.HorizontalAlignment.Left}
                    valign="Center"
                >
                    <Container
                        name="Uncapped"
                        width="100%"
                        height="40"
                        BackgroundColor3={Color3.fromHex("#3B72E6")}
                        BackgroundTransparency={0}
                        cornerRadius="md"
                        center
                        LayoutOrder={1}
                    >
                        <Text text='width="100%"' TextColor3={Color3.fromHex("#FFFFFF")} />
                    </Container>
                    <Container
                        name="MaxWidth"
                        width="100%"
                        maxWidth={320}
                        height="40"
                        BackgroundColor3={Color3.fromHex("#3BE672")}
                        BackgroundTransparency={0}
                        cornerRadius="md"
                        center
                        LayoutOrder={2}
                    >
                        <Text text='width="100%" maxWidth={320}' />
                    </Container>
                    <Container
                        name="MinWidth"
                        width="10%"
                        minWidth={220}
                        height="40"
                        BackgroundColor3={Color3.fromHex("#F2C94C")}
                        BackgroundTransparency={0}
                        cornerRadius="md"
                        center
                        LayoutOrder={3}
                    >
                        <Text text='width="10%" minWidth={220}' />
                    </Container>
                </VStack>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Container Min Max",
} as const;
