import React from "@rbxts/react";
import { Checkbox } from "../../src/Components/Input/Checkbox";
import { VStack } from "../../src/Components/Layout/VStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="140" center>
                <Box>
                    <VStack>
                        <Container name="RememberRow" LayoutOrder={1}>
                            <Checkbox label="Remember me" defaultChecked={true} />
                        </Container>
                        <Container name="SubscribeRow" LayoutOrder={2}>
                            <Checkbox label="Subscribe to updates" />
                        </Container>
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Checkbox Label",
} as const;
