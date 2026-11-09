import React from "@rbxts/react";
import { HoverButton } from "../../src/Components/Input/HoverButton";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="160">
                <HStack HorizontalFlex={Enum.UIFlexAlignment.SpaceEvenly} valign="Center">
                    <HoverButton
                        name="Plain"
                        default={{
                            Size: UDim2.fromOffset(150, 60),
                            BackgroundColor3: Color3.fromHex("#3B72E6"),
                            BackgroundTransparency: 0,
                            AutoButtonColor: false,
                            LayoutOrder: 1,
                        }}
                        hover={{ BackgroundColor3: Color3.fromHex("#5A8CF0") }}
                    >
                        <Text
                            text="Hover me"
                            TextColor3={Color3.fromHex("#FFFFFF")}
                            AnchorPoint={new Vector2(0.5, 0.5)}
                            Position={UDim2.fromScale(0.5, 0.5)}
                        />
                    </HoverButton>
                    <HoverButton
                        name="InnerBorder"
                        borderThickness={3}
                        borderColor={Color3.fromHex("#1D3F8A")}
                        borderPosition="inner"
                        default={{
                            Size: UDim2.fromOffset(150, 60),
                            BackgroundColor3: Color3.fromHex("#3B72E6"),
                            BackgroundTransparency: 0,
                            AutoButtonColor: false,
                            LayoutOrder: 2,
                        }}
                        hover={{ borderColor: Color3.fromHex("#F2C94C") }}
                    >
                        <Text
                            text="Inner border"
                            TextColor3={Color3.fromHex("#FFFFFF")}
                            AnchorPoint={new Vector2(0.5, 0.5)}
                            Position={UDim2.fromScale(0.5, 0.5)}
                        />
                    </HoverButton>
                    <HoverButton
                        name="OuterBorder"
                        isSelected
                        borderThickness={3}
                        borderColor={Color3.fromHex("#000000")}
                        borderTransparency={0.6}
                        borderPosition="outer"
                        default={{
                            Size: UDim2.fromOffset(150, 60),
                            BackgroundColor3: Color3.fromHex("#3B72E6"),
                            BackgroundTransparency: 0,
                            AutoButtonColor: false,
                            LayoutOrder: 3,
                        }}
                        focus={{
                            BackgroundColor3: Color3.fromHex("#2E9D63"),
                            borderColor: Color3.fromHex("#F2C94C"),
                            borderTransparency: 0,
                        }}
                    >
                        <Text
                            text="Selected (outer)"
                            TextColor3={Color3.fromHex("#FFFFFF")}
                            AnchorPoint={new Vector2(0.5, 0.5)}
                            Position={UDim2.fromScale(0.5, 0.5)}
                        />
                    </HoverButton>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Form/Hover Button",
} as const;
