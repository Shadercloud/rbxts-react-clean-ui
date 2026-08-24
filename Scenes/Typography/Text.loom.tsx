import React from "@rbxts/react";
import { Text } from "../../src/Components/Typography/Text";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="420" center>
                <Box>
                    <VStack spacing="sm">
                        <Text text="Display" variant="display" />
                        <Text text="Title" variant="title" />
                        <Text text="Heading" variant="heading" />
                        <Text text="Body (default variant)" variant="body" />
                        <Text text="Label" variant="label" />
                        <Text text="Caption" variant="caption" />
                        <Text text="Bold weight" weight="bold" />
                        <Text text="Custom color" TextColor3={Color3.fromHex("#3B72E6")} />
                        <Text text="Right aligned" align="Right" />
                        <Text text="Long paragraphs wrap across multiple lines by default so body copy stays readable inside narrow containers." />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Typography/Text",
} as const;
