import React from "@rbxts/react";
import { Button } from "../../src/Components/Input/Button";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="120">
                <VStack>
                    <Container width="100%" LayoutOrder={1}>
                        <HStack>
                            <Button fill LayoutOrder={1} text="Save" intent="primary" />
                            <Button fill LayoutOrder={2} text="Save and continue" intent="success" />
                            <Button fill LayoutOrder={3} text="Cancel" intent="danger" />
                        </HStack>
                    </Container>
                    <Button width={120} LayoutOrder={2} text="Fixed 120px" />
                </VStack>
            </Container>
        </LoomScene>
    ),
    title: "Form/Button Sizing",
} as const;
