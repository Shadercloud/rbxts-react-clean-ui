import React from "@rbxts/react";
import { Container, createTheme, Input as InputComponent, ThemeProvider, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const flatFieldTheme = createTheme({
    components: {
        input: {
            backgroundColor: Color3.fromHex("#295896"),
            backgroundTransparency: 0,
            backgroundImage: { image: "" },
            borderColor: Color3.fromHex("#3D2712"),
            borderThickness: 3,
            cornerRadius: 0,
            typography: { color: Color3.fromHex("#FFF7CF") },
            placeholder: { color: Color3.fromHex("#8FA6C4") },
            iconColor: Color3.fromHex("#FFF7CF"),
        },
    },
});

function Input(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={360}>
            <VStack>
                <InputComponent placeholder="Type here..." value="" />
                <InputComponent placeholder="Small scale" value="" scale="sm" />
                <InputComponent placeholder="Large scale" value="" scale="xl" />
                <InputComponent value="Pre-filled value" />
                <ThemeProvider theme={flatFieldTheme}>
                    <VStack>
                        <InputComponent placeholder="Flat themed field" value="" icon="search" />
                        <InputComponent value="Flat themed value" icon="user" />
                    </VStack>
                </ThemeProvider>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Input;
