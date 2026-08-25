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
                        width="150"
                        height="120"
                        BackgroundColor3={Color3.fromHex("#3B72E6")}
                        BackgroundTransparency={0}
                        center
                    >
                        <Text text="Fixed 150x120" TextColor3={Color3.fromHex("#FFFFFF")} />
                    </Container>
                    <Container
                        height="80"
                        BackgroundColor3={Color3.fromHex("#3BE672")}
                        BackgroundTransparency={0}
                        center
                    >
                        <Text text="Auto width, fixed height" />
                    </Container>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Container",
} as const;
