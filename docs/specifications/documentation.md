# Documentation

When creating .mdx documentation files under `/docs/content/docs/components/`, if a component has an associated Loom demo file, then embed the demonstration and code using the `<Demo>` Fumadocs component, such as this:

```md
    <Demo previewHeight={300}>
    ```tsx
    import { Container, Box, Row, Column } from "@rbxts/react-clean-ui";

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
    ```
    </Demo>
```