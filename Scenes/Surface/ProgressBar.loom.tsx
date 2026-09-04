import React from "@rbxts/react";
import { Box } from "../../src/Components/Surface/Box";
import { ProgressBar } from "../../src/Components/Surface/ProgressBar";
import { Container } from "../../src/Components/Layout/Container";
import { VStack } from "../../src/Components/Layout/VStack";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="560" center>
                <Box>
                    <VStack>
                        <ProgressBar value={25} />
                        <ProgressBar value={60} intent="success" />
                        <ProgressBar value={90} intent="danger" scale="lg" />
                        <ProgressBar value={40} intent="warning" />
                        <ProgressBar value={50} scale="sm" intent="info" />
                        <ProgressBar value={70} label="Uploading" showValue intent="success" />
                        <ProgressBar
                            value={3}
                            max={5}
                            label="Storage used"
                            showValue
                            valueFormatter={(value, max) => `${value} of ${max} GB`}
                        />
                        <ProgressBar value={65} striped label="Processing" showValue intent="info" />
                        <ProgressBar
                            value={45}
                            striped
                            stripeDirection={-1}
                            intent="warning"
                        />
                        <ProgressBar value={80} striped stripeDuration={2} intent="success" />
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Progress Bar",
} as const;
