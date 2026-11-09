import React from "@rbxts/react";
import { Number } from "@rbxts/ui-labs";
import { Box, Container, createStory, Text, VStack } from "@rbxts/react-clean-ui";
import PaginationCursor from "./PaginationCursor";

export = createStory((props) => (
    <Container center>
        <Box>
            <VStack>
                <Text text="Cursor paged" variant="heading" />
                <Text text="No totalPages: Next is enabled while hasNextPage is true." />
                <PaginationCursor lastPage={props.controls.LastPage} />
            </VStack>
        </Box>
    </Container>
), {
    LastPage: Number(5, 1, 20, 1),
});
