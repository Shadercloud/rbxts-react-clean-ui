import React from "@rbxts/react";
import { Select } from "../../src/Components/Input/Select";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="180" center>
                <Box>
                    <Select>
                        <Select.Option text="United Kingdom" />
                        <Select.Option text="United States" />
                        <Select.Option text="Canada" />
                    </Select>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Form/Select",
} as const;
