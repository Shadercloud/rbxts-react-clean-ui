import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { Scroller } from "../../src/Components/Layout/Scroller";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { Box } from "../../src/Components/Surface/Box";
import { CleanThemeContext } from "../../src/Contexts";
import { ThemeProvider } from "../../src/Providers/theme.provider";
import { extendTheme } from "../../src/Theme/theme.factory";
import { LoomScene } from "../LoomScene";

function DecoratedScrollerTheme(props: { children?: React.ReactNode }) {
    const theme = React.useContext(CleanThemeContext);
    const decoratedTheme = React.useMemo(
        () =>
            extendTheme(theme, {
                components: {
                    scroller: {
                        trackColor: Color3.fromHex("#888888"),
                        trackTransparency: 0.7,
                        thumbBorderThickness: 2,
                        thumbBorderColor: Color3.fromHex("#FFFFFF"),
                    },
                },
            }),
        [theme],
    );

    return <ThemeProvider theme={decoratedTheme}>{props.children}</ThemeProvider>;
}

function Items(props: { count: number }) {
    const items: React.ReactElement[] = [];
    for (let i = 1; i <= props.count; i++) {
        items.push(<Text key={`Item${i}`} text={`Item ${i}`} LayoutOrder={i} />);
    }

    return <VStack spacing="sm">{items}</VStack>;
}

function GutterRows() {
    return (
        <VStack spacing="sm">
            <Container name="Row1" width="100%" height="24" BackgroundColor3={Color3.fromHex("#3B72E6")} BackgroundTransparency={0} LayoutOrder={1} />
            <Container name="Row2" width="100%" height="24" BackgroundColor3={Color3.fromHex("#3B72E6")} BackgroundTransparency={0} LayoutOrder={2} />
        </VStack>
    );
}

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="260" center>
                <HStack HorizontalFlex={Enum.UIFlexAlignment.SpaceEvenly} valign="Center">
                    <Box width="190" LayoutOrder={1}>
                        <VStack spacing="sm">
                            <Text text="Plain" weight="bold" LayoutOrder={1} />
                            <Container width="100%" height="160" LayoutOrder={2}>
                                <Scroller spacing="sm">
                                    <Items count={10} />
                                </Scroller>
                            </Container>
                        </VStack>
                    </Box>
                    <Box width="190" LayoutOrder={2}>
                        <VStack spacing="sm">
                            <Text text="Track + thumb border" weight="bold" LayoutOrder={1} />
                            <Container width="100%" height="160" LayoutOrder={2}>
                                <DecoratedScrollerTheme>
                                    <Scroller width="100%" height="160" spacing="sm">
                                        <Items count={10} />
                                    </Scroller>
                                </DecoratedScrollerTheme>
                            </Container>
                        </VStack>
                    </Box>
                    <Box width="190" LayoutOrder={3}>
                        <VStack spacing="sm">
                            <Text text="stableGutter" weight="bold" LayoutOrder={1} />
                            <Container width="100%" height="160" LayoutOrder={2}>
                                <Scroller spacing="sm" stableGutter>
                                    <GutterRows />
                                </Scroller>
                            </Container>
                        </VStack>
                    </Box>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Scroller Theme",
} as const;
