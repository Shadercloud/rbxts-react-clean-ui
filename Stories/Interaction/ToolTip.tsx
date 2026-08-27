import React from "@rbxts/react";
import { Button, Container, HStack, Icon, Text, Tooltip as TooltipComponent, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function ToolTip(props: { screenshot?: boolean } = {}) {
    const content = (
        <VStack>
            <TooltipComponent
                content="Tooltip text goes here"
                intent="primary"
                spacing="md"
                placement="Top"
            >
                <Button text="Tooltip Above" />

            </TooltipComponent>
            <TooltipComponent
                content="Tooltip text goes here"
                intent="success"
                spacing="md"
                placement="Bottom"
            >
                <Button intent="success" text="Tooltip Below (success intent)" />

            </TooltipComponent>
            <TooltipComponent
                content={
                    <Container>
                        <VStack spacing="None">
                            <Container>
                                <HStack>
                                    <Icon icon="hand-peace-o" />
                                    <Text text="With an Icon!" variant="heading" />
                                </HStack>
                            </Container>
                            <Text text="Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. " />

                        </VStack>
                    </Container>
                }
                intent="warning"
                spacing="md"
                placement="Right"
            >
                <Button intent="primary" text="Tooltip to Right (warning intent / custom content)" />

            </TooltipComponent>
            <TooltipComponent content="Hello World" placement="Left">
                <Text text="Testing" />
            </TooltipComponent>
        </VStack>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = ToolTip;
