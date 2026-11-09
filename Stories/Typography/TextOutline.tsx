import React from "@rbxts/react";
import { CleanThemeContext, Container, DeepPartial, extendTheme, Text, ThemeProvider, ThemeTemplate, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TextOutlineProps {
    thickness?: number;
    screenshot?: boolean;
}

const white = new Color3(1, 1, 1);

const sceneGradient = {
    colors: [Color3.fromHex("#8ED1FC"), Color3.fromHex("#FFF3B0"), Color3.fromHex("#F7B267"), Color3.fromHex("#7BC67E"), Color3.fromHex("#E9F5DB")],
    stops: [0, 0.3, 0.5, 0.75, 1],
    rotation: 35,
};

const outlinedHeadingOverrides: DeepPartial<ThemeTemplate> = {
    typography: {
        heading: {
            outline: { color: Color3.fromHex("#5A2A00"), thickness: 2 },
        },
    },
};

function TextOutline(props: TextOutlineProps = {}) {
    const activeTheme = React.useContext(CleanThemeContext);
    const outlinedTheme = React.useMemo(() => extendTheme(activeTheme, outlinedHeadingOverrides), [activeTheme]);
    const thickness = props.thickness ?? 2;

    const content = (
        <Container width={420}>
            <Container name="Scene" width="100%" backgroundGradient={sceneGradient} BackgroundColor3={white} BackgroundTransparency={0} padding="16px" cornerRadius="8px">
                <VStack spacing="sm">
                    <Text text="No outline (hard to read)" variant="heading" TextColor3={white} />
                    <Text text="outline={true}" variant="heading" TextColor3={white} outline />
                    <Text
                        text="Custom outline object"
                        variant="heading"
                        TextColor3={white}
                        outline={{ color: Color3.fromHex("#1B3A6B"), thickness, transparency: 0.1 }}
                    />
                    <Text text="Letter-spaced outline" variant="heading" letterSpacing={4} TextColor3={white} outline={{ thickness }} />
                    <ThemeProvider theme={outlinedTheme}>
                        <VStack spacing="sm">
                            <Text text="Theme typography.heading.outline" variant="heading" TextColor3={white} />
                            <Text text="Theme outline, outline={false}" variant="heading" TextColor3={white} outline={false} />
                        </VStack>
                    </ThemeProvider>
                </VStack>
            </Container>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TextOutline;
