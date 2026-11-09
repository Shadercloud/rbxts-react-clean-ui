import React from "@rbxts/react";
import { Button, Container, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function isPointer(input: InputObject) {
    return input.UserInputType === Enum.UserInputType.MouseButton1 || input.UserInputType === Enum.UserInputType.Touch;
}

function ButtonPressDown(props: { screenshot?: boolean }) {
    const [holding, setHolding] = React.useState(false);
    const [presses, setPresses] = React.useState(0);

    const content = (
        <Container width={240}>
            <VStack HorizontalFlex={Enum.UIFlexAlignment.None}>
                <Button
                    icon="bolt"
                    text="Hold to sprint"
                    intent="primary"
                    pressOn="down"
                    Event={{
                        Activated: (button, input) => {
                            setPresses((count) => count + 1);

                            if (isPointer(input)) {
                                setHolding(true);
                            }
                        },
                    }}
                    onRelease={() => setHolding(false)}
                />
                <Text text={holding ? "Holding" : "Released"} />
                <Text text={`Presses: ${presses}`} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ButtonPressDown;
