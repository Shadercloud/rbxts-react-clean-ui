import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Row } from "../../../Components/Layout/Row";
import { Column } from "../../../Components/Layout/Column";
import { ResponsiveGridSpan } from "../../../Interfaces/";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	assertStackedHorizontally,
	findDescendant,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 600;
const HOST_HEIGHT = 300;

const DEFAULT_GAP = 12;

function column(name: string, span?: ResponsiveGridSpan | number) {
	return (
		<Column name={name} span={span}>
			<frame key={`${name}Content`} BackgroundTransparency={1} Size={new UDim2(1, 0, 0, 40)} />
		</Column>
	);
}

function expectedColumnWidth(rowWidth: number, span: number, gap: number) {
	const fraction = math.floor((span / 12) * 1000) / 1000;
	return fraction * rowWidth + (fraction - 1) * gap;
}

function waitForRow(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "Row");
}

@Tag("Studio")
class RowMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Columns are laid out left-to-right in JSX order, starting at the Row's left edge")
	@Test
	public columnsInOrder() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Row>
				{column("First")}
				{column("Second")}
				{column("Third")}
			</Row>,
			(mounted) => {
				const row = waitForRow(mounted.host);
				const first = waitForGuiObject<Frame>(row, "First");
				const second = findDescendant<Frame>(row, "Second");
				const third = findDescendant<Frame>(row, "Third");

				assertAlignedLeft(first, row, 1, "row order");
				assertStackedHorizontally([first, second, third], "row order");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Three Columns without a span each take a third of the Row, less their share of the default gap")
	@Test
	public equalSplitWithoutSpan() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Row>
				{column("First")}
				{column("Second")}
				{column("Third")}
			</Row>,
			(mounted) => {
				const row = waitForRow(mounted.host);
				const expected = expectedColumnWidth(HOST_WIDTH, 4, DEFAULT_GAP);

				for (const name of ["First", "Second", "Third"]) {
					const col = waitForGuiObject<Frame>(row, name);
					assertSizeApprox(col, expected, undefined, 1, `equal split ${name}`);
				}
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[4, 8],
		[3, 9],
	])
	@DisplayName("Explicit spans that sum to 12 size each Column by span/12 and keep both on one line inside the Row")
	@Test
	public spansSizeColumns(leftSpan: number, rightSpan: number) {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Row>
				{column("Left", leftSpan)}
				{column("Right", rightSpan)}
			</Row>,
			(mounted) => {
				const row = waitForRow(mounted.host);
				const left = waitForGuiObject<Frame>(row, "Left");
				const right = waitForGuiObject<Frame>(row, "Right");

				assertSizeApprox(left, expectedColumnWidth(HOST_WIDTH, leftSpan, DEFAULT_GAP), undefined, 1, `span ${leftSpan}`);
				assertSizeApprox(right, expectedColumnWidth(HOST_WIDTH, rightSpan, DEFAULT_GAP), undefined, 1, `span ${rightSpan}`);
				assertStackedHorizontally([left, right], `spans ${leftSpan}+${rightSpan}`);
				assertContained(right, row, `spans ${leftSpan}+${rightSpan}`);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A responsive span re-resolves against the Row's breakpoint when the host narrows from 600px to 250px")
	@Test
	public responsiveSpanFollowsWidth() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Row>{column("Responsive", { xs: 12, md: 6 })}</Row>, (mounted) => {
			const row = waitForRow(mounted.host);
			const wideExpected = expectedColumnWidth(HOST_WIDTH, 6, DEFAULT_GAP);
			const col = waitForGuiObject<Frame>(
				row,
				"Responsive",
				(gui) => math.abs(gui.AbsoluteSize.X - wideExpected) <= 1,
				`Timed out waiting for the responsive Column to resolve md=6 at ${HOST_WIDTH}px`,
			);

			assertSizeApprox(col, wideExpected, undefined, 1, "responsive span at 600px");

			mounted.resize(250, HOST_HEIGHT);

			const narrowExpected = expectedColumnWidth(250, 12, DEFAULT_GAP);
			waitForGuiObject<Frame>(
				row,
				"Responsive",
				(gui) => math.abs(gui.AbsoluteSize.X - narrowExpected) <= 1,
				"Timed out waiting for the responsive Column to resolve xs=12 at 250px",
			);

			assertSizeApprox(col, narrowExpected, undefined, 1, "responsive span at 250px");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every visible Column and its content stays inside the Row")
	@Test
	public allContained() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Row>
				{column("First", 4)}
				{column("Second", 4)}
				{column("Third", 4)}
			</Row>,
			(mounted) => {
				const row = waitForRow(mounted.host);
				waitForGuiObject<Frame>(row, "Third");

				assertAllDescendantsContained(row, "row columns");
			},
		);
	}
}

export = RowMountValidation;
