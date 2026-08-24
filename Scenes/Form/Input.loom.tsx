import React from "@rbxts/react";
import { Input } from "../../src/Components/Input/Input";
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
                        <Input placeholder="Enter your email address" value="" validation="Email" />
                        <Input placeholder="Enter your phone number" value="" validation="Telephone" />
                        <Input placeholder="Enter a percentage" value="" validation="Number" min={0} max={100} />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Input",
} as const;
