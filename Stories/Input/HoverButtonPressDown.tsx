import React from "@rbxts/react";
import { Container, Corners, HoverButton, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function isPointer(input: InputObject) {
    return input.UserInputType === Enum.UserInputType.MouseButton1 || input.UserInputType === Enum.UserInputType.Touch;
}

function HoverButtonPressDown(props: { screenshot?: boolean }) {
    const [holding, setHolding] = React.useState(false);
    const [presses, setPresses] = React.useState(0);

    const content = (
        <Container width={200}>
            <VStack HorizontalFlex={Enum.UIFlexAlignment.None}>
                <Container width={200} height={56}>
                    <HoverButton
                        borderThickness={2}
                        pressOn="down"
                        onRelease={() => setHolding(false)}
                        default={{
                            Size: UDim2.fromScale(1, 1),
                            BackgroundColor3: Color3.fromHex("#F4F5F7"),
                            BackgroundTransparency: 0,
                            AutoButtonColor: false,
                            borderColor: Color3.fromHex("#8A8F98"),
                            Event: {
                                Activated: (button, input) => {
                                    setPresses((count) => count + 1);

                                    if (isPointer(input)) {
                                        setHolding(true);
                                    }
                                },
                            },
                        }}
                        hover={{
                            borderColor: Color3.fromHex("#4A7AC9"),
                        }}
                    >
                        <Corners radius="md" />
                        <Text
                            text="Hold me"
                            AnchorPoint={new Vector2(0.5, 0.5)}
                            Position={UDim2.fromScale(0.5, 0.5)}
                            TextColor3={Color3.fromHex("#1F2328")}
                        />
                    </HoverButton>
                </Container>
                <Text text={holding ? "Holding" : "Released"} />
                <Text text={`Presses: ${presses}`} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = HoverButtonPressDown;
