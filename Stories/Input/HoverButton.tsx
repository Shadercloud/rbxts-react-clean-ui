import React from "@rbxts/react";
import { Container, Corners, HoverButton as HoverButtonComponent, Text } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface HoverButtonProps {
    isSelected?: boolean;
    borderPosition?: "inner" | "outer";
    screenshot?: boolean;
}

function HoverButton(props: HoverButtonProps = {}) {
    const content = (
        <Container width={200} height={56}>
            <HoverButtonComponent
                isSelected={props.isSelected}
                borderThickness={2}
                borderPosition={props.borderPosition ?? "inner"}
                default={{
                    Size: UDim2.fromScale(1, 1),
                    BackgroundColor3: Color3.fromHex("#F4F5F7"),
                    BackgroundTransparency: 0,
                    AutoButtonColor: false,
                    borderColor: Color3.fromHex("#8A8F98"),
                }}
                hover={{
                    borderColor: Color3.fromHex("#4A7AC9"),
                }}
                focus={{
                    borderColor: Color3.fromHex("#2E9D63"),
                    borderThickness: 3,
                }}
            >
                <Corners radius="md" />
                <Text
                    text="Hover me"
                    AnchorPoint={new Vector2(0.5, 0.5)}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    TextColor3={Color3.fromHex("#1F2328")}
                />
            </HoverButtonComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = HoverButton;
