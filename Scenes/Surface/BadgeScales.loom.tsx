import React from "@rbxts/react";
import { Badge } from "../../src/Components/Surface/Badge";
import { Box } from "../../src/Components/Surface/Box";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="120" center>
                <Box>
                    <HStack valign="Center" Wraps={false}>
                        <Badge LayoutOrder={1} text="Extra small" scale="xs" intent="info" />
                        <Badge LayoutOrder={2} text="Small" scale="sm" intent="info" />
                        <Badge LayoutOrder={3} text="Medium" scale="md" intent="info" />
                        <Badge LayoutOrder={4} text="Large" scale="lg" intent="info" />
                        <Badge LayoutOrder={5} text="Extra large" scale="xl" intent="info" />
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Badge Scales",
} as const;
