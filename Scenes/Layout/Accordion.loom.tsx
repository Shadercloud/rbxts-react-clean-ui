import React from "@rbxts/react";
import { Accordion } from "../../src/Components/Layout/Accordion";
import { Container } from "../../src/Components/Layout/Container";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200" center>
                <Box>
                    <Accordion defaultValue="overview" animationDuration={0}>
                        <Accordion.Item value="overview">
                            <Accordion.Header><Text text="Overview" /></Accordion.Header>
                            <Accordion.Content><Text text="Accordion sections reveal related information on demand." /></Accordion.Content>
                        </Accordion.Item>
                        <Accordion.Item value="features">
                            <Accordion.Header><Text text="Features" /></Accordion.Header>
                            <Accordion.Content><Text text="Supports controlled state, collapsible sections, icons, and animation." /></Accordion.Content>
                        </Accordion.Item>
                        <Accordion.Item value="disabled" disabled>
                            <Accordion.Header><Text text="Unavailable" /></Accordion.Header>
                            <Accordion.Content><Text text="Disabled content." /></Accordion.Content>
                        </Accordion.Item>
                    </Accordion>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Accordion",
} as const;
