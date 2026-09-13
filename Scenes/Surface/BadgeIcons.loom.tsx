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
                        <Badge LayoutOrder={1} text="3" icon="smile-o" intent="primary" />
                        <Badge LayoutOrder={2} text="Online" icon="check" intent="success" />
                        <Badge LayoutOrder={3} text="New" icon="info" intent="info" />
                        <Badge LayoutOrder={4} text="12" icon="exclamation" intent="warning" />
                        <Badge LayoutOrder={5} text="Banned" icon="times" intent="danger" />
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Badge Icons",
} as const;
