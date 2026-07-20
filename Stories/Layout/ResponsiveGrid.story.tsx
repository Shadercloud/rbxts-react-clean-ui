import React from "@rbxts/react";
import { Box, Column, Container, createStory, Row } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <Container
        width="75%"
        center="50%">
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
));