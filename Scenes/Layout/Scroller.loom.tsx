import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { Scroller } from "../../src/Components/Layout/Scroller";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="240" center>
                <Box width="320">
                    <Scroller width="100%" height="200" spacing="sm">
                        <VStack spacing="sm">
                            <Text text="Item 1" />
                            <Text text="Item 2" />
                            <Text text="Item 3" />
                            <Text text="Item 4" />
                            <Text text="Item 5" />
                            <Text text="Item 6" />
                            <Text text="Item 7" />
                            <Text text="Item 8" />
                            <Text text="Item 9" />
                            <Text text="Item 10" />
                        </VStack>
                    </Scroller>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Scroller",
} as const;
