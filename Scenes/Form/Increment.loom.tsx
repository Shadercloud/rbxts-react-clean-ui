import React from "@rbxts/react";
import { Increment } from "../../src/Components/Input/Increment";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="220" center>
                <Box>
                    <VStack>
                        <Increment value={5} />
                        <Increment value={0} min={0} max={10} intent="success" />
                        <Increment value={20} step={5} intent="warning" />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Increment",
} as const;
