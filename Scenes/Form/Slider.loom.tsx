import React from "@rbxts/react";
import { Slider } from "../../src/Components/Input/Slider";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="180" center>
                <Box>
                    <VStack>
                        <Slider max-value={100} value={40} width="100%" />
                        <Slider max-value={100} value={new Vector2(20, 70)} range highlight="middle" width="100%" />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Slider",
} as const;
