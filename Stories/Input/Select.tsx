import React from "@rbxts/react";
import { Container, createTheme, HStack, Icon, Select as SelectComponent, Text, ThemeProvider, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const themeWithBackgroundImage = createTheme({
    components: {
        select: {
            backgroundImage: {
                image: 92016395170536,
                slice: "10 5 248 44",
                tintColor: Color3.fromHex("#295896"),
            },
        },
    },
});

function CountrySelect() {
    return (
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
    );
}

function Select(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={320}>
            <VStack>
                <Text text="Default Select" />
                <CountrySelect />
                <Text text="Select with theme.components.select.backgroundImage" />
                <ThemeProvider theme={themeWithBackgroundImage}>
                    <CountrySelect />
                </ThemeProvider>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Select;
