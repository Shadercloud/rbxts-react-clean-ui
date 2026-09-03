import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { Pagination } from "../../src/Components/Layout/Pagination";
import { LoomScene } from "../LoomScene";

function PaginationPreview() {
	const [page, setPage] = React.useState(5);

	return <Pagination page={page} totalPages={10} siblingCount={1} onPageChange={setPage} />;
}

export const preview = {
	render: () => (
		<LoomScene>
			<Container width="100%" height="120" center>
				<PaginationPreview />
			</Container>
		</LoomScene>
	),
	title: "Layout/Pagination",
} as const;
