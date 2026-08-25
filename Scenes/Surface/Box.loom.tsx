import React from "@rbxts/react";
import { Box } from "../../src/Components/Surface/Box";
import { Container } from "../../src/Components/Layout/Container";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="200" center>
                <Box>
                    <VStack>
                        <Text variant="heading" text="Box" />
                        <Text text="A Box is a bordered, padded surface with a background and shadow." />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Box",
} as const;
