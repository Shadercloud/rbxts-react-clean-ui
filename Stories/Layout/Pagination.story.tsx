import React from "@rbxts/react";
import { Container, Box, createStory, Pagination as PaginationComponent, Text, VStack } from "@rbxts/react-clean-ui";
import Pagination from "./Pagination";

const TOTAL_PAGES = 12;

function PaginationExamples() {
	const [customPage, setCustomPage] = React.useState(6);

	return (
		<Container center width="75%">
			<Box>
				<VStack>
					<VStack>
						<Text text="Simple" variant="heading" />
						<Pagination />
					</VStack>

					<VStack>
						<Text text="Customized" variant="heading" />
						<PaginationComponent page={customPage} totalPages={TOTAL_PAGES} onPageChange={setCustomPage}>
							<VStack spacing="sm" HorizontalAlignment={Enum.HorizontalAlignment.Center}>
								<PaginationComponent.Prev />
								<Text text={`Page ${customPage} of ${TOTAL_PAGES}`} />
								<PaginationComponent.Next />
							</VStack>
						</PaginationComponent>
					</VStack>
				</VStack>
			</Box>
		</Container>
	);
}

export = createStory(() => <PaginationExamples />);
