import React from "@rbxts/react";
import { Badge, Container, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function BadgeClickable(props: { screenshot?: boolean } = {}) {
    const [themeClicks, setThemeClicks] = React.useState(0);
    const [styledClicks, setStyledClicks] = React.useState(0);

    const content = (
        <Container>
            <VStack spacing="sm">
                <Container name="ThemeShading" LayoutOrder={1}>
                    <HStack valign="Center" spacing="sm" Wraps={false}>
                        <Badge
                            name="ThemePill"
                            LayoutOrder={1}
                            text={`Clicked ${themeClicks}`}
                            icon="hand-pointer-o"
                            intent="info"
                            onClick={() => setThemeClicks((count) => count + 1)}
                        />
                        <Text LayoutOrder={2} text="Theme hover/press shading" TextWrap={false} />
                    </HStack>
                </Container>
                <Container name="CustomStateStyles" LayoutOrder={2}>
                    <HStack valign="Center" spacing="sm" Wraps={false}>
                        <Badge
                            name="StyledPill"
                            LayoutOrder={1}
                            text={`Clicked ${styledClicks}`}
                            icon="star"
                            intent="primary"
                            onClick={() => setStyledClicks((count) => count + 1)}
                            hoverStyle={{
                                backgroundColor: Color3.fromHex("#FFD54A"),
                                textColor: Color3.fromHex("#3A2A00"),
                                borderColor: Color3.fromHex("#B8860B"),
                            }}
                            pressStyle={{
                                backgroundColor: Color3.fromHex("#B8860B"),
                                textColor: Color3.fromHex("#FFFFFF"),
                                iconColor: Color3.fromHex("#FFF3C4"),
                            }}
                        />
                        <Text LayoutOrder={2} text="Custom hoverStyle / pressStyle" TextWrap={false} />
                    </HStack>
                </Container>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = BadgeClickable;
