import React from "@rbxts/react";
import { Badge } from "../../src/Components/Surface/Badge";
import { Box } from "../../src/Components/Surface/Box";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { LoomScene } from "../LoomScene";

function ClickablePills() {
    const [likes, setLikes] = React.useState(0);
    const [follows, setFollows] = React.useState(0);

    return (
        <HStack valign="Center" Wraps={false}>
            <Badge
                LayoutOrder={1}
                text={`Likes ${likes}`}
                icon="thumbs-up"
                intent="info"
                onClick={() => setLikes(likes + 1)}
            />
            <Badge
                LayoutOrder={2}
                text={`Follow ${follows}`}
                intent="primary"
                hoverStyle={{ backgroundColor: Color3.fromHex("#2E9D63"), textColor: new Color3(1, 1, 1) }}
                pressStyle={{ backgroundColor: Color3.fromHex("#1F6E45") }}
                onClick={() => setFollows(follows + 1)}
            />
        </HStack>
    );
}

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="160" center>
                <Box>
                    <VStack>
                        <Container name="StyledRow" LayoutOrder={1}>
                            <HStack valign="Center" Wraps={false}>
                                <Badge
                                    LayoutOrder={1}
                                    text="Custom"
                                    BackgroundColor3={Color3.fromHex("#6B3FA0")}
                                    textColor={Color3.fromHex("#FFFFFF")}
                                    borderColor={Color3.fromHex("#C9A8F0")}
                                    borderThickness={2}
                                />
                                <Badge
                                    LayoutOrder={2}
                                    text="Outlined"
                                    icon="star"
                                    BackgroundTransparency={1}
                                    textColor={Color3.fromHex("#D4A017")}
                                    borderColor={Color3.fromHex("#D4A017")}
                                />
                                <Badge
                                    LayoutOrder={3}
                                    text="Roomy"
                                    intent="success"
                                    padding="6px 16px"
                                />
                            </HStack>
                        </Container>
                        <Container name="ClickableRow" LayoutOrder={2}>
                            <ClickablePills />
                        </Container>
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Badge Custom",
} as const;
