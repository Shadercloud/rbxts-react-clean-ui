import React from "@rbxts/react";
import { Box as BoxComponent, Container, createTheme, Text, ThemeProvider, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

// backgroundImage is theme-only (theme.components.box.backgroundImage), not a Box prop,
// so it's demonstrated here via a themed subtree rather than a per-instance control.
const themeWithBackgroundImage = createTheme({
    colors: {
        intents: {
            primary: {
                default: {
                    textColor: new Color3(0.97, 0.95, 0.84),
                }
            }
        }
    },
    components: {
        box: {
            backgroundImage: {
                image: 128862403914906,
                size: "Tile",
                tileSize: "300"
            },
        },
    },
});

function Box(props: { screenshot?: boolean } = {}) {
    const content = (
        <Container width={360}>
            <VStack>
                <BoxComponent>
                    <Text text="Boxes give content a bordered, shadowed surface to sit on." />
                </BoxComponent>
                <ThemeProvider theme={themeWithBackgroundImage}>
                    <BoxComponent>
                        <Text text="theme.components.box.backgroundImage layers a 9-sliced image under Box's existing border, shadow, and corner radius, which still draw on top." />
                    </BoxComponent>
                </ThemeProvider>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Box;
