import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200">
                <HStack HorizontalFlex={Enum.UIFlexAlignment.SpaceEvenly} valign="Center">
                    <Container
                        name="InnerBorder"
                        width="150"
                        height="90"
                        BackgroundColor3={Color3.fromHex("#3B72E6")}
                        BackgroundTransparency={0}
                        borderThickness={4}
                        borderColor={Color3.fromHex("#F2C94C")}
                        borderPosition="inner"
                        padding="12"
                        cornerRadius="md"
                        LayoutOrder={1}
                    >
                        <Text text="Inner border" TextColor3={Color3.fromHex("#FFFFFF")} />
                    </Container>
                    <Container
                        name="OuterBorder"
                        width="150"
                        height="90"
                        BackgroundColor3={Color3.fromHex("#3B72E6")}
                        BackgroundTransparency={0}
                        borderThickness={4}
                        borderColor={Color3.fromHex("#F2C94C")}
                        borderPosition="outer"
                        padding="12"
                        cornerRadius="md"
                        LayoutOrder={2}
                    >
                        <Text text="Outer border" TextColor3={Color3.fromHex("#FFFFFF")} />
                    </Container>
                    <Container
                        name="TransparentBorder"
                        width="150"
                        height="90"
                        BackgroundColor3={Color3.fromHex("#3BE672")}
                        BackgroundTransparency={0}
                        borderThickness={6}
                        borderColor={Color3.fromHex("#000000")}
                        borderTransparency={0.6}
                        padding="24 8"
                        cornerRadius="16"
                        LayoutOrder={3}
                    >
                        <Text text="Faded border" />
                    </Container>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Container Borders",
} as const;
