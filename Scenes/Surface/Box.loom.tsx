import React from "@rbxts/react";
import { Box } from "../../src/Components/Surface/Box";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { createTheme } from "../../src/Theme";
import { ThemeProvider } from "../../src/Providers/theme.provider";

// Placeholder asset — swap for a real 9-slice panel image.
const PLACEHOLDER_PANEL_IMAGE = "rbxassetid://0";

// backgroundImage is theme-only (theme.components.box.backgroundImage), not a Box prop,
// so it's demonstrated here via a themed subtree rather than a per-instance control.
const themeWithBackgroundImage = createTheme({
    components: {
        box: {
            backgroundImage: {
                image: PLACEHOLDER_PANEL_IMAGE,
                slice: "12 60",
            },
        },
    },
});

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="200" center>
                <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill}>
                    <Box>
                        <VStack>
                            <Text variant="heading" text="Box" />
                            <Text text="A Box is a bordered, padded surface with a background and shadow." />
                        </VStack>
                    </Box>
                    <ThemeProvider theme={themeWithBackgroundImage}>
                        <Box border-color={Color3.fromRGB(255, 255, 255)} border-thickness={2}>
                            <VStack>
                                <Text variant="heading" text="Background Image" />
                                <Text text="theme.components.box.backgroundImage layers a 9-sliced image under the border, corner radius, and shadow." />
                            </VStack>
                        </Box>
                    </ThemeProvider>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Box",
} as const;
