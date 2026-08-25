import React from "@rbxts/react";
import { Tooltip } from "../../src/Components/Interaction/Tooltip";
import { Button } from "../../src/Components/Input/Button";
import { HStack } from "../../src/Components/Layout/HStack";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="160" center>
                <HStack spacing="lg" valign="Center">
                    <Tooltip content="Appears above the button" placement="Top">
                        <Button text="Hover me (Top)" />
                    </Tooltip>
                    <Tooltip content="Appears below the button" placement="Bottom" intent="success">
                        <Button text="Hover me (Bottom)" intent="success" />
                    </Tooltip>
                </HStack>
            </Container>
        </LoomScene>
    ),
    title: "Interaction/Tooltip",
} as const;
