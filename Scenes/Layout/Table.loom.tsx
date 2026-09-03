import React from "@rbxts/react";
import { Container } from "../../src/Components/Layout/Container";
import { Table } from "../../src/Components/Layout/Table";
import { LoomScene } from "../LoomScene";

export const preview = {
	render: () => (
		<LoomScene>
			<Container width="90%" height="240" center>
				<Table>
					<Table.Header>
						<Table.Row>
							<Table.Head>Invoice</Table.Head>
							<Table.Head>Status</Table.Head>
							<Table.Head>Method</Table.Head>
							<Table.Head align="Right">Amount</Table.Head>
						</Table.Row>
					</Table.Header>
					<Table.Body>
						<Table.Row>
							<Table.Cell>INV001</Table.Cell>
							<Table.Cell>Paid</Table.Cell>
							<Table.Cell>Credit Card</Table.Cell>
							<Table.Cell align="Right">$250.00</Table.Cell>
						</Table.Row>
						<Table.Row>
							<Table.Cell>INV002</Table.Cell>
							<Table.Cell>Pending</Table.Cell>
							<Table.Cell>PayPal</Table.Cell>
							<Table.Cell align="Right">$150.00</Table.Cell>
						</Table.Row>
						<Table.Row>
							<Table.Cell>INV003</Table.Cell>
							<Table.Cell>Unpaid</Table.Cell>
							<Table.Cell>Bank Transfer</Table.Cell>
							<Table.Cell align="Right">$350.00</Table.Cell>
						</Table.Row>
					</Table.Body>
				</Table>
			</Container>
		</LoomScene>
	),
	title: "Layout/Table",
} as const;
