import React from "@rbxts/react";
import { Container, HStack, Icon, Select as SelectComponent, Text } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Select(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={320}>
            <SelectComponent max-height="200px">
                <SelectComponent.Option text="United Kingdom" />
                <SelectComponent.Option text="United States" />
                <SelectComponent.Option text="Canada">
                    <HStack>
                        <Icon icon="leaf" color={Color3.fromHex("#000000")} />
                        <Text text="Canada" />
                    </HStack>
                </SelectComponent.Option>
                <SelectComponent.Option text="Germany" />
                <SelectComponent.Option text="France" />
            </SelectComponent>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Select;
