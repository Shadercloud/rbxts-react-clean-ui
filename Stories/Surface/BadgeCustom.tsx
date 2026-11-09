import React from "@rbxts/react";
import { Badge, Container, HStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function BadgeCustom(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container>
            <HStack valign="Center" spacing="sm" Wraps={false}>
                <Badge
                    name="CustomColors"
                    LayoutOrder={1}
                    text="Custom colours"
                    icon="star"
                    BackgroundColor3={Color3.fromHex("#4B2A7B")}
                    textColor={Color3.fromHex("#F5E6FF")}
                    iconColor={Color3.fromHex("#FFD54A")}
                />
                <Badge
                    name="CustomBorder"
                    LayoutOrder={2}
                    text="Thick outer border"
                    intent="info"
                    borderThickness={3}
                    borderColor={Color3.fromHex("#1E3A8A")}
                    borderPosition="outer"
                />
                <Badge
                    name="TranslucentBorder"
                    LayoutOrder={3}
                    text="Faded border"
                    intent="success"
                    borderThickness={2}
                    borderTransparency={0.6}
                />
                <Badge
                    name="CustomPadding"
                    LayoutOrder={4}
                    text="Roomy padding"
                    intent="warning"
                    padding="10 20"
                />
                <Badge
                    name="TightPadding"
                    LayoutOrder={5}
                    text="Tight"
                    intent="danger"
                    padding="0 4"
                />
            </HStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = BadgeCustom;
