import React from "@rbxts/react";
import { Input } from "../../src/Components/Input/Input";
import { Select } from "../../src/Components/Input/Select";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { ThemeProvider } from "../../src/Providers/theme.provider";
import { extendTheme } from "../../src/Theme/theme.factory";
import { WoodenTheme } from "../../src/Theme/themes/wooden.theme";
import { LoomScene } from "../LoomScene";

const sunkFieldTheme = extendTheme(WoodenTheme, {
    components: {
        box: {
            backgroundColor: Color3.fromHex("#6B4423"),
            backgroundTransparency: 0,
            backgroundImage: { image: "" },
            cornerRadius: 8,
            padding: "16px",
        },
        input: {
            borderColor: Color3.fromHex("#3D2712"),
            borderThickness: 2,
            cornerRadius: 8,
            backgroundColor: Color3.fromHex("#FFFFFF"),
            backgroundTransparency: 0,
            backgroundImage: { image: "" },
            backgroundGradient: { colors: [Color3.fromHex("#173A66"), Color3.fromHex("#214C84"), Color3.fromHex("#295896")], stops: [0, 0.45, 1], rotation: 90 },
            boxShadow: { shadow: "0px 1px 0px 0px", color: Color3.fromHex("#A87A45"), transparency: 0 },
            innerShadow: { color: Color3.fromHex("#000000"), transparency: 0.5, size: 8 },
            states: { focus: { borderColor: Color3.fromHex("#F2A65A") } },
        },
        select: {
            borderColor: Color3.fromHex("#3D2712"),
            borderThickness: 2,
            cornerRadius: 8,
            backgroundColor: Color3.fromHex("#FFFFFF"),
            backgroundTransparency: 0,
            backgroundImage: { image: "" },
            backgroundGradient: { colors: [Color3.fromHex("#173A66"), Color3.fromHex("#214C84"), Color3.fromHex("#295896")], stops: [0, 0.45, 1], rotation: 90 },
            boxShadow: { shadow: "0px 1px 0px 0px", color: Color3.fromHex("#A87A45"), transparency: 0 },
            innerShadow: { color: Color3.fromHex("#000000"), transparency: 0.5, size: 8 },
            states: { focus: { borderColor: Color3.fromHex("#F2A65A") } },
            caret: {
                size: 30,
                backgroundColor: Color3.fromHex("#173A66"),
                borderColor: Color3.fromHex("#3D2712"),
                borderThickness: 2,
                cornerRadius: 6,
                iconColor: Color3.fromHex("#FFF7CF"),
                margin: "0px -6px 0px 0px",
            },
            dropDownBackgroundColor: Color3.fromHex("#214C84"),
            dropDown: {
                cornerRadius: 8,
                borderThickness: 2,
                borderColor: Color3.fromHex("#3D2712"),
                boxShadow: { shadow: "0px 6px 14px 0px", color: Color3.fromHex("#000000"), transparency: 0.5 },
                gap: 6,
            },
            intents: { primary: { focus: { backgroundColor: Color3.fromHex("#3A6DB0") } } },
        },
    },
});

export const preview = {
    render: () => (
        <LoomScene>
            <ThemeProvider theme={sunkFieldTheme}>
                <Container width="80%" height="260" center>
                    <Box>
                        <VStack>
                            <Input placeholder="Name your settlement" value="" icon="search" />
                            <Select>
                                <Select.Option text="Oak" />
                                <Select.Option text="Pine" />
                                <Select.Option text="Birch" />
                            </Select>
                        </VStack>
                    </Box>
                </Container>
            </ThemeProvider>
        </LoomScene>
    ),
    title: "Form/Sunk Field",
} as const;
