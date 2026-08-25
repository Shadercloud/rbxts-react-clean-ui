import React from "@rbxts/react";
import { Container, HStack, Icon, Select as SelectComponent, Text } from "@rbxts/react-clean-ui";

function Select() {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={320}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
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
}

export = Select;
