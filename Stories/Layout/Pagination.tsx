import React from "@rbxts/react";
import { Container, Pagination as PaginationComponent } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const TOTAL_PAGES = 12;

function Pagination(props: { screenshot?: boolean } = {}) {
    const [page, setPage] = React.useState(6);

    const content = (
        <Container>
            <PaginationComponent page={page} totalPages={TOTAL_PAGES} siblingCount={1} onPageChange={setPage} />
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Pagination;
