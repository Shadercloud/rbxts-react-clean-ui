import React from "@rbxts/react";
import { Container } from "../src/Components/Layout/Container";
import { Row } from "../src/Components/Layout/Row";
import { Column } from "../src/Components/Layout/Column";
import { LoomScene } from "./LoomScene";
import { Box } from "../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="75%" center="50%">
                <Box>
                    <Row>
                        <Column span={{
                            md: 6,
                            lg: 3
                        }}>
                            <frame Size={new UDim2(1, 0, 0, 100)} BackgroundColor3={Color3.fromHex("#FF0000")} />
                        </Column>
                        <Column span={{
                            md: 6,
                            lg: 3
                        }}>
                            <frame Size={new UDim2(1, 0, 0, 100)} BackgroundColor3={Color3.fromHex("#FFFF00")} />
                        </Column>
                        <Column span={{
                            md: 6,
                            lg: 3
                        }}>
                            <frame Size={new UDim2(1, 0, 0, 100)} BackgroundColor3={Color3.fromHex("#FF00FF")} />
                        </Column>
                        <Column span={{
                            md: 6,
                            lg: 3
                        }}>
                            <frame Size={new UDim2(1, 0, 0, 100)} BackgroundColor3={Color3.fromHex("#0000FF")} />
                        </Column>
                    </Row>
                </Box>
            </Container>
        </LoomScene >
    ),

    title: "Card",
} as const;
