import React from "@rbxts/react";
import { Container, Pagination as PaginationComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function PaginationCursor(props: { lastPage?: number; screenshot?: boolean } = {}) {
    const lastPage = props.lastPage ?? 5;
    const [page, setPage] = React.useState(2);

    const content = (
        <Container>
            <VStack spacing="sm" HorizontalAlignment={Enum.HorizontalAlignment.Center}>
                <Text text={`Page ${page}`} />
                <PaginationComponent page={page} hasNextPage={page < lastPage} onPageChange={setPage} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = PaginationCursor;
