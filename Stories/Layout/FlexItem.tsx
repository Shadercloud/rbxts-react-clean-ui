import React from "@rbxts/react";
import { Container, FlexItem as FlexItemComponent, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface FlexItemProps {
    direction?: "horizontal" | "vertical";
    screenshot?: boolean;
}

function Swatch(props: { color: string }) {
    return <Container width={40} height={40} cornerRadius="sm" BackgroundColor3={Color3.fromHex(props.color)} BackgroundTransparency={0} />;
}

function FlexItem(props: FlexItemProps = {}) {
    const content = (
        <Container width={420} height={200}>
            <HStack VerticalFlex={Enum.UIFlexAlignment.Fill} Wraps={false}>
                <FlexItemComponent
                    direction={props.direction ?? "vertical"}
                    padding="8"
                    cornerRadius="md"
                    borderThickness={1}
                    borderColor={Color3.fromHex("#8A8F98")}
                >
                    <Swatch color="#7A9E7E" />
                    <Swatch color="#C97A4A" />
                    <Swatch color="#4A7AC9" />
                </FlexItemComponent>
                <FlexItemComponent
                    layout={false}
                    padding="8"
                    cornerRadius="md"
                    borderThickness={1}
                    borderColor={Color3.fromHex("#8A8F98")}
                >
                    <VStack>
                        <Text text="layout={false} + VStack" />
                        <Swatch color="#7A9E7E" />
                        <Swatch color="#4A7AC9" />
                    </VStack>
                </FlexItemComponent>
            </HStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = FlexItem;
