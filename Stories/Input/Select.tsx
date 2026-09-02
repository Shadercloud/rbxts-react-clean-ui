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

function CountrySelect(props: { searchable?: boolean; grouped?: boolean }) {
    return (
        <SelectComponent max-height="200px" searchable={props.searchable}>
            {props.grouped ? (
                <>
                    <SelectComponent.OptGroup label="Europe">
                        <SelectComponent.Option text="United Kingdom" />
                        <SelectComponent.Option text="Germany" />
                        <SelectComponent.Option text="France" />
                    </SelectComponent.OptGroup>
                    <SelectComponent.OptGroup label="North America">
                        <SelectComponent.Option text="United States" />
                        <SelectComponent.Option text="Canada">
                            <HStack>
                                <Icon icon="leaf" color={Color3.fromHex("#000000")} />
                                <Text text="Canada" />
                            </HStack>
                        </SelectComponent.Option>
                    </SelectComponent.OptGroup>
                </>
            ) : (
                <>
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
                </>
            )}
        </SelectComponent>
    );
}

function Select(props: { screenshot?: boolean; searchable?: boolean; grouped?: boolean } = {}) {
    const searchable = props.searchable ?? false;
    const grouped = props.grouped ?? false;

    const content = (
        <Container width={320}>
            <VStack>
                <Text text="Default Select" />
                <CountrySelect searchable={searchable} grouped={grouped} />
                <Text text="Select with theme.components.select.backgroundImage" />
                <ThemeProvider theme={themeWithBackgroundImage}>
                    <CountrySelect searchable={searchable} grouped={grouped} />
                </ThemeProvider>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Select;
