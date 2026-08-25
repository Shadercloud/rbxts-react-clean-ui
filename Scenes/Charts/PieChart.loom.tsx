import React from "@rbxts/react";
import { Pie } from "../../src/Components/Chart/Pie";
import { Container } from "../../src/Components/Layout/Container";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container height="300" width="100%">
                <Pie
                    values={[
                        { value: 7, label: "Alpha" },
                        { value: 4, label: "Beta" },
                        { value: 6, label: "Gamma" },
                        { value: 5, label: "Delta" },
                    ]}
                />
            </Container>
        </LoomScene>
    ),
    title: "Charts/Pie Chart",
} as const;
