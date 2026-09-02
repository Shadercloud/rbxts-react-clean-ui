import React from "@rbxts/react";
import { Switch } from "../../src/Components/Input/Switch";
import { HStack } from "../../src/Components/Layout/HStack";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="140" center>
                <Box>
                    <HStack>
                        <Switch checked={false} />
                        <Switch checked={true} />
                        <Switch checked={true} intent="success" disabled />
                    </HStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Switch",
} as const;
