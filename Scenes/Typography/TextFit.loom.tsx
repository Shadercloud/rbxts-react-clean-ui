import React from "@rbxts/react";
import { Text } from "../../src/Components/Typography/Text";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="240" padding="12">
                <VStack
                    spacing="sm"
                    HorizontalFlex={Enum.UIFlexAlignment.None}
                    HorizontalAlignment={Enum.HorizontalAlignment.Left}
                >
                    <Text
                        text="With maxWidth this label stays auto-sized but wraps onto new lines once it reaches 260 pixels."
                        maxWidth={260}
                        LayoutOrder={1}
                    />
                    <Container
                        name="OutlineBackground"
                        width="100%"
                        height="48"
                        padding="12"
                        BackgroundColor3={Color3.fromHex("#F2C94C")}
                        BackgroundTransparency={0}
                        cornerRadius="md"
                        LayoutOrder={2}
                    >
                        <Text
                            text="Outlined label"
                            variant="heading"
                            TextColor3={Color3.fromHex("#FFFFFF")}
                            outline={{ color: Color3.fromHex("#1B1B1B"), thickness: 2 }}
                        />
                    </Container>
                    <Container
                        name="ShrinkBox"
                        width="180"
                        height="44"
                        padding="8"
                        BackgroundColor3={Color3.fromHex("#3B72E6")}
                        BackgroundTransparency={0}
                        cornerRadius="md"
                        LayoutOrder={3}
                    >
                        <Text
                            text="SHRINK TO FIT"
                            variant="title"
                            letterSpacing={4}
                            shrinkToFit
                            TextColor3={Color3.fromHex("#FFFFFF")}
                        />
                    </Container>
                </VStack>
            </Container>
        </LoomScene>
    ),
    title: "Typography/Text Fit",
} as const;
