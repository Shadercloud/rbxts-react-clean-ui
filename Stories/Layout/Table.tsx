import React from "@rbxts/react";
import { Container, Table as TableComponent } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

interface TableProps {
	compact?: boolean;
	fixedWidth?: boolean;
	screenshot?: boolean;
}

function Table(props: TableProps = {}) {
	const verticalSpacing = props.compact ? "xs" : "sm";
	const content = (
		<Container width={props.fixedWidth ? "100%" : undefined} height={180}>
			<TableComponent width={props.fixedWidth ? "100%" : undefined}>
				<TableComponent.Header>
					<TableComponent.Row>
						<TableComponent.Head text="Invoice" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Head text="Status" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Head text="Method" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Head
							text="Amount"
							top={verticalSpacing}
							bottom={verticalSpacing}
							align="Right"
						/>
					</TableComponent.Row>
				</TableComponent.Header>
				<TableComponent.Body>
					<TableComponent.Row>
						<TableComponent.Cell text="INV001" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="Paid" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="Credit Card" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell
							text="$250.00"
							top={verticalSpacing}
							bottom={verticalSpacing}
							align="Right"
						/>
					</TableComponent.Row>
					<TableComponent.Row>
						<TableComponent.Cell text="INV-2026-002" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="Awaiting approval" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="PayPal" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell
							text="$150.00"
							top={verticalSpacing}
							bottom={verticalSpacing}
							align="Right"
						/>
					</TableComponent.Row>
					<TableComponent.Row>
						<TableComponent.Cell text="INV003" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="Unpaid" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell text="Bank Transfer" top={verticalSpacing} bottom={verticalSpacing} />
						<TableComponent.Cell
							text="$350.00"
							top={verticalSpacing}
							bottom={verticalSpacing}
							align="Right"
						/>
					</TableComponent.Row>
				</TableComponent.Body>
			</TableComponent>
		</Container>
	);

	return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Table;
