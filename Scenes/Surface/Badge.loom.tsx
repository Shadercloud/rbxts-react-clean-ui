import React from "@rbxts/react";
import { Badge } from "../../src/Components/Surface/Badge";
import { Box } from "../../src/Components/Surface/Box";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="100" center>
                <Box>
                    <HStack valign="Center" Wraps={false}>
                        <Badge LayoutOrder={1} text="Primary" intent="primary" />
                        <Badge LayoutOrder={2} text="Success" intent="success" />
                        <Badge LayoutOrder={3} text="Info" intent="info" />
                        <Badge LayoutOrder={4} text="Warning" intent="warning" />
                        <Badge LayoutOrder={5} text="Danger" intent="danger" />
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Badge",
} as const;
