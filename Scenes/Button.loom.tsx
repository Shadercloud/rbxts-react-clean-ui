import React from "@rbxts/react";
import { Button } from "../src/Components/Input/Button"
import { Container } from "../src/Components/Layout/Container";
import { Box } from "../src/Components/Surface/Box";

export const preview = {
    render: () => <frame Size={UDim2.fromOffset(300, 300)}>
        <Container Size={UDim2.fromOffset(200, 200)}>
            <Box>
                <Button text="Hello World" icon="check-square" intent="success" />
            </Box>
        </Container>
    </frame>,
    title: "Button",
} as const;
