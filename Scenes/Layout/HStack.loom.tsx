import React from "@rbxts/react";
import { Accordion } from "../../src/Components/Layout/Accordion";
import { Container } from "../../src/Components/Layout/Container";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";
import { HStack } from "../../src/Components/Layout";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" center>
                <Box>
                    <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill}>
                        <Container>
                            <Text text="Left" />
                        </Container>
                        <Container>
                            <Text text="Center" />
                        </Container>
                        <Container>
                            <Text text="Right" />
                        </Container>
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Layout/HStack",
} as const;
