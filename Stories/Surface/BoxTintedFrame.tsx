import React from "@rbxts/react";
import { Box as BoxComponent, Container, createTheme, Text, ThemeProvider } from "@rbxts/react-clean-ui";

// backgroundImage is theme-only (theme.components.box.backgroundImage), not a Box prop,
// so it's demonstrated here via a themed subtree rather than a per-instance control.
//
// Unlike Box.tsx's tiled wood-grain photo, this uses a plain white 9-sliceable shape
// (a rounded-square with a soft edge) and recolors it entirely with tintColor, so the
// wooden look here comes from tint + slice rather than a pre-colored texture.
const themeWithTintedFrame = createTheme({
    colors: {
        intents: {
            primary: {
                default: {
                    textColor: new Color3(1, 0.97, 0.81),
                }
            }
        }
    },
    components: {
        box: {
            borderThickness: 0,
            boxShadow: 0,
            cornerRadius: 0,
            padding: "35px 40px 40px 40px",
            backgroundImage: {
                image: 89050878990049,
                slice: "54 55 969 565",
                sliceScale: 1,
                // tintColor: new Color3(0.55, 0.35, 0.18),
            },
        },
    },
});

function BoxTintedFrame() {
    return <Container
        BackgroundColor3={new Color3(1, 1, 1)}
        BackgroundTransparency={0} BorderSizePixel={0}
        width="100%"
        height="100%">
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <ThemeProvider theme={themeWithTintedFrame}>
            <BoxComponent>
                <Text text="This wooden border comes from a plain white 9-sliced image recolored with theme.components.box.backgroundImage.tintColor, instead of an already-brown photographic texture." />
            </BoxComponent>
        </ThemeProvider>
    </Container>
}

export = BoxTintedFrame;
