import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Table } from "../../../Components/Layout/Table";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	assertStackedVertically,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const COLUMN_COUNT = 3;
const BODY_ROW_COUNT = 2;

function tableFixture(width?: number) {
	return (
		<Table width={width}>
			<Table.Header>
				<Table.Row>
					<Table.Head text="Name" />
					<Table.Head text="Role" />
					<Table.Head text="Score" />
				</Table.Row>
			</Table.Header>
			<Table.Body>
				<Table.Row>
					<Table.Cell text="Alice" />
					<Table.Cell text="Engineer" />
					<Table.Cell text="92" />
				</Table.Row>
				<Table.Row>
					<Table.Cell text="Bob" />
					<Table.Cell text="Designer" />
					<Table.Cell text="88" />
				</Table.Row>
			</Table.Body>
		</Table>
	);
}

function getCells(root: Instance): GuiObject[] {
	const cells: GuiObject[] = [];
	for (const descendant of root.GetDescendants()) {
		if (descendant.IsA("GuiObject") && (descendant.Name === "TableHead" || descendant.Name === "TableCell")) {
			cells.push(descendant);
		}
	}
	return cells;
}

function waitForColumnsMeasured(host: Instance): ImageLabel {
	const tableRoot = waitForGuiObject<ImageLabel>(host, "Table");

	waitForLayout(() => {
		const cells = getCells(tableRoot);
		const expected = COLUMN_COUNT * (BODY_ROW_COUNT + 1);
		if (cells.size() !== expected) return undefined;
		return cells.every((cell) => cell.AbsoluteSize.X > 0 && cell.AbsoluteSize.Y > 0) ? true : undefined;
	}, "Timed out waiting for every tableRoot cell to be measured with a non-zero size");

	task.wait();
	task.wait();

	return tableRoot;
}

function getRows(section: Instance): GuiObject[] {
	const rows: GuiObject[] = [];
	for (const child of section.GetChildren()) {
		if (child.IsA("GuiObject") && child.Name === "TableRow") rows.push(child);
	}
	return rows;
}

function firstCellText(row: Instance): string {
	const label = row.FindFirstChildWhichIsA("TextLabel", true);
	Assert.notUndefined(label, `Expected a TextLabel inside ${row.GetFullName()}`);
	return label!.Text;
}

@Tag("Studio")
class TableMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The header row sits above the body rows, which follow in declaration order")
	@Test
	public headerThenRowsInOrder() {
		withMounted(500, 300, tableFixture(), (mounted) => {
			const tableRoot = waitForColumnsMeasured(mounted.host);

			const header = findDescendant<ImageLabel>(tableRoot, "TableHeader");
			const body = findDescendant<ImageLabel>(tableRoot, "TableBody");
			const bodyRows = getRows(body);

			Assert.equal(bodyRows.size(), BODY_ROW_COUNT, "Expected two body rows");
			Assert.equal(firstCellText(bodyRows[0]), "Alice");
			Assert.equal(firstCellText(bodyRows[1]), "Bob");

			assertStackedVertically([header, ...bodyRows], "header then body rows");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every row renders exactly one cell per column of the data")
	@Test
	public columnCountMatchesData() {
		withMounted(500, 300, tableFixture(), (mounted) => {
			const tableRoot = waitForColumnsMeasured(mounted.host);

			const header = findDescendant<ImageLabel>(tableRoot, "TableHeader");
			const body = findDescendant<ImageLabel>(tableRoot, "TableBody");

			const headerRows = getRows(header);
			Assert.equal(headerRows.size(), 1, "Expected a single header row");
			Assert.equal(getCells(headerRows[0]).size(), COLUMN_COUNT, "Expected one TableHead per column");

			for (const row of getRows(body)) {
				Assert.equal(getCells(row).size(), COLUMN_COUNT, `Expected ${COLUMN_COUNT} cells in ${row.GetFullName()}`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no width the tableRoot hugs its columns and every visible descendant stays inside it")
	@Test
	public cellsContained() {
		withMounted(500, 300, tableFixture(), (mounted) => {
			const tableRoot = waitForColumnsMeasured(mounted.host);

			assertContained(tableRoot, mounted.host, "tableRoot vs host");
			assertAllDescendantsContained(tableRoot, "auto-width tableRoot");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An explicit width pins the tableRoot to that pixel width while cells stay inside it")
	@Test
	public explicitWidth() {
		withMounted(500, 300, tableFixture(300), (mounted) => {
			const tableRoot = waitForColumnsMeasured(mounted.host);

			assertSizeApprox(tableRoot, 300, undefined, 1, "explicit width tableRoot");
			assertAllDescendantsContained(tableRoot, "explicit width tableRoot");
		});
	}
}

export = TableMountValidation;
