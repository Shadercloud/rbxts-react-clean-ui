import React from "@rbxts/react";
import { Button, Container, Intent, Text, Tooltip as TooltipComponent, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ToolTipInteractive(props: { screenshot?: boolean; intent?: Intent; pinOnPress?: boolean } = {}) {
    const [clicks, setClicks] = React.useState(0);

    const content = (
        <VStack>
            <TooltipComponent
                content={
                    <Container>
                        <VStack>
                            <Text text={`Clicked ${clicks} times`} />
                            <Button
                                intent={props.intent}
                                text="Click me"
                                Event={{ Activated: () => setClicks((value) => value + 1) }}
                            />
                        </VStack>
                    </Container>
                }
                intent={props.intent}
                spacing="md"
                placement="Right"
                interactive
                pinOnPress={props.pinOnPress}
            >
                <Button text="Interactive (move onto the popup)" />
            </TooltipComponent>
            <TooltipComponent
                content="Pinned until you press the button or this popup again"
                intent={props.intent}
                spacing="md"
                placement="Right"
                pinOnPress
            >
                <Button text="Pin on press (click to pin)" />
            </TooltipComponent>
            <TooltipComponent
                content="Open while your finger is held down"
                intent={props.intent}
                spacing="md"
                placement="Right"
                longPress
                pinOnPress={props.pinOnPress}
            >
                <Button text="Long press (touch emulation)" />
            </TooltipComponent>
            <TooltipComponent
                content={
                    <Container>
                        <VStack>
                            <Text text="Hover the button below for a nested tooltip" />
                            <TooltipComponent
                                content={
                                    <Container>
                                        <VStack>
                                            <Text text="Nested popup keeps its parent open" />
                                            <Button intent={props.intent} text="Nested button" />
                                        </VStack>
                                    </Container>
                                }
                                intent={props.intent}
                                spacing="md"
                                placement="Right"
                                interactive
                            >
                                <Button text="Nested trigger" />
                            </TooltipComponent>
                        </VStack>
                    </Container>
                }
                intent={props.intent}
                spacing="md"
                placement="Bottom"
                interactive
                pinOnPress={props.pinOnPress}
            >
                <Button text="Nested (opens below)" />
            </TooltipComponent>
            <TooltipComponent content="Only opens when no interactive popup covers it" spacing="md" placement="Right">
                <Button text="Covered trigger (under the nested popup)" />
            </TooltipComponent>
            <TooltipComponent content="Also hidden while covered" spacing="md" placement="Right">
                <Button text="Another covered trigger" />
            </TooltipComponent>
        </VStack>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ToolTipInteractive;
