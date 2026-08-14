import React from "@rbxts/react";
import { Accordion } from "../../src/Components/Layout/Accordion";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="200" center>
                <Box>
                    <Accordion defaultValue="sections" animationDuration={0}>
                        <Accordion.Item value="sections">
                            <Accordion.Header text="How many sections can be open at once?" />
                            <Accordion.Content text="Only one section opens at a time by default." />
                        </Accordion.Item>
                        <Accordion.Item value="icons">
                            <Accordion.Header icon="info-circle" text="Can a header include an icon?" />
                            <Accordion.Content text="Yes, pass an icon prop to Accordion.Header to pair it with the label." />
                        </Accordion.Item>
                        <Accordion.Item value="disabled" disabled>
                            <Accordion.Header text="Why is this section disabled?" />
                            <Accordion.Content text="Disabled items cannot be expanded." />
                        </Accordion.Item>
                    </Accordion>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Accordion",
} as const;
