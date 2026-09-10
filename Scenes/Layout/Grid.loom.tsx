import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { Grid } from "../../src/Components/Layout/Grid";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="90%" height="260" center>
                <Grid cols={{ xs: 1, sm: 2, md: 3 }} gap="md">
                    <Box name="TallCell">
                        <VStack spacing="sm">
                            <Text text="Tall cell" />
                            <Text text="This cell has extra lines of content," />
                            <Text text="which stretches every other cell to match" />
                            <Text text="its measured height." />
                        </VStack>
                    </Box>
                    <Box name="ShortCellOne">
                        <Text text="Short cell" />
                    </Box>
                    <Box name="ShortCellTwo">
                        <Text text="Short cell" />
                    </Box>
                    <Box name="ShortCellThree">
                        <Text text="Short cell" />
                    </Box>
                    <Box name="ShortCellFour">
                        <Text text="Short cell" />
                    </Box>
                    <Box name="ShortCellFive">
                        <Text text="Short cell" />
                    </Box>
                </Grid>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Grid",
} as const;
