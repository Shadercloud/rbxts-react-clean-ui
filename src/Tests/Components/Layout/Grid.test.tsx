import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Grid } from "../../../Components/Layout/Grid";
import { Container } from "../../../Components/Layout/Container";
import { ScaleSize } from "../../../Interfaces/";
import { STUDIO_SKIP_MESSAGE, mountInScreenGui, waitForDescendant, waitForGuiObject, waitForLayout } from "../../Helpers/layout";

function mountGrid(width: number, element: React.ReactElement) {
	const { host, root, update } = mountInScreenGui(width, 600, element);

	return { host, root, update };
}

function unmount(root: ReactRoblox.Root, host: Instance) {
	const gui = host.Parent;

	root.unmount();
	host.Destroy();
	if (gui !== undefined && gui.IsA("ScreenGui")) gui.Destroy();
}

function waitForFillDirectionMaxCells(host: Instance, expectedCols: number): UIGridLayout {
	return waitForDescendant<UIGridLayout>(
		host,
		"GridLayout",
		(layout) => layout.FillDirectionMaxCells === expectedCols,
		`Timed out waiting for Grid to lock with cols=${expectedCols}`,
	);
}

function waitForFreshLock(host: Instance, previous: UIGridLayout | undefined, expectedCols: number): UIGridLayout {
	return waitForDescendant<UIGridLayout>(
		host,
		"GridLayout",
		(layout) => layout.FillDirectionMaxCells === expectedCols && (previous === undefined || layout !== previous),
		`Timed out waiting for Grid to relock (cols=${expectedCols}) with a fresh GridLayout instance`,
	);
}

function waitForGridWidth(host: Instance, expectedWidth: number): Frame {
	return waitForGuiObject<Frame>(
		host,
		"Grid",
		(gridFrame) => gridFrame.AbsoluteSize.X === expectedWidth,
		`Timed out waiting for Grid's root frame to reach an AbsoluteSize.X of ${expectedWidth}`,
	);
}

function getGridCells(host: Instance): GuiObject[] {
	const gridFrame = host.FindFirstChild("Grid", true);
	Assert.notUndefined(gridFrame, "Expected to find the Grid's root frame");

	const cells: GuiObject[] = [];
	for (const child of gridFrame!.GetChildren()) {
		if (child.IsA("GuiObject") && child.Name === "GridCell") cells.push(child);
	}
	cells.sort((a, b) => a.LayoutOrder < b.LayoutOrder);

	return cells;
}

function firstGuiObjectName(instance: Instance): string | undefined {
	for (const child of instance.GetChildren()) {
		if (child.IsA("GuiObject")) return child.Name;
	}
	return undefined;
}

@Tag("Studio")
class GridMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A plain numeric cols value locks that column count even in a tiny container")
	@Test
	public numericCols() {
		const { host, root } = mountGrid(
			50,
			<Grid cols={3}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 3);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Cols falls back to one when the breakpoint object has no value at or below the active breakpoint")
	@Test
	public defaultCols() {
		const { host, root } = mountGrid(
			150,
			<Grid cols={{ lg: 3 }}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 1);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Resizing the host across sm, md and xl picks the nearest lower breakpoint's cols value")
	@Test
	public breakpointCols() {
		const { host, root } = mountGrid(
			250,
			<Grid cols={{ xs: 1, md: 3, xl: 5 }}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 1);

		host.Size = UDim2.fromOffset(350, 600);
		task.wait();

		waitForFillDirectionMaxCells(host, 3);

		host.Size = UDim2.fromOffset(550, 600);
		task.wait();

		waitForFillDirectionMaxCells(host, 5);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Passing custom thresholds moves a 120px container from xs to md without changing its size")
	@Test
	public customBreakpoints() {
		const { host, root, update } = mountGrid(
			120,
			<Grid cols={{ xs: 2, md: 4 }}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 2);

		update(
			<Grid cols={{ xs: 2, md: 4 }} breakpoints={{ xs: 0, sm: 50, md: 100, lg: 150, xl: 200 }}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 4);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[2, "md", 12, 0.5, -6],
		[4, "lg", 16, 0.25, -12],
		[3, "xl", 24, 1 / 3, -16],
		[5, "sm", 8, 0.2, -7],
		[3, "None", 0, 1 / 3, 0],
	])
	@DisplayName("Each cell is 1/cols wide minus a floored share of the gap, with CellPadding set to the gap in pixels")
	@Test
	public cellSizing(
		cols: number,
		gapKey: ScaleSize | "None",
		gapPixels: number,
		expectedScale: number,
		expectedOffset: number,
	) {
		const { host, root } = mountGrid(
			600,
			<Grid cols={cols} gap={gapKey}>
				<frame Size={UDim2.fromOffset(10, 10)} />
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		const layout = waitForFillDirectionMaxCells(host, cols);

		Assert.approximately(layout.CellSize.X.Scale, expectedScale, 1e-6);
		Assert.approximately(layout.CellSize.X.Offset, expectedOffset, 1e-6);
		Assert.equal(layout.CellPadding, new UDim2(0, gapPixels, 0, gapPixels));

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Native and custom children each get their own GridCell, numbered in source order from zero")
	@Test
	public childOrder() {
		const { host, root } = mountGrid(
			600,
			<Grid cols={2} gap="None">
				<textlabel key="Alpha" Text="Alpha" Size={UDim2.fromOffset(20, 20)} />
				<Container name="CustomCard" width={20} height={20} />
				<frame key="Gamma" Size={UDim2.fromOffset(20, 20)} />
			</Grid>,
		);

		waitForFillDirectionMaxCells(host, 2);

		const cells = waitForLayout(() => {
			const found = getGridCells(host);
			return found.size() === 3 ? found : undefined;
		}, "Timed out waiting for all three cells to render");

		const names: string[] = [];
		const orders: number[] = [];
		for (const cell of cells) {
			names.push(firstGuiObjectName(cell) ?? "");
			orders.push(cell.LayoutOrder);
		}

		Assert.deepEqual(names, ["Alpha", "CustomCard", "Gamma"]);
		Assert.deepEqual(orders, [0, 1, 2]);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Appending a child with cols, gap and width unchanged still invalidates and rebuilds the locked layout")
	@Test
	public relockOnChildAdded() {
		const { host, root, update } = mountGrid(
			600,
			<Grid cols={2} gap="None">
				<frame key="Alpha" Size={UDim2.fromOffset(10, 10)} />
				<frame key="Beta" Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		const initialLayout = waitForFillDirectionMaxCells(host, 2);
		Assert.equal(getGridCells(host).size(), 2);

		update(
			<Grid cols={2} gap="None">
				<frame key="Alpha" Size={UDim2.fromOffset(10, 10)} />
				<frame key="Beta" Size={UDim2.fromOffset(10, 10)} />
				<frame key="Gamma" Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForFreshLock(host, initialLayout, 2);
		Assert.equal(getGridCells(host).size(), 3);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Wrapped text grows the locked row height when the host narrows and shrinks it back when it widens")
	@Test
	public relockOnWidthChange() {
		const prose =
			"The quick brown fox jumps over the lazy dog while the grid measures every cell, " +
			"locks the tallest height it saw, and must let that height go again once the " +
			"container widens back out and the very same text wraps onto fewer lines.";

		const { host, root } = mountGrid(
			600,
			<Grid cols={1} gap="None">
				<textlabel
					key="Prose"
					Text={prose}
					TextSize={14}
					TextWrapped={true}
					Size={new UDim2(1, 0, 0, 0)}
					AutomaticSize={Enum.AutomaticSize.Y}
				/>
			</Grid>,
		);

		const wideLayout = waitForFillDirectionMaxCells(host, 1);
		const wideHeight = wideLayout.CellSize.Y.Offset;
		Assert.greaterThan(wideHeight, 0, "Expected the initial lock to capture a non-zero wrapped text height");

		host.Size = UDim2.fromOffset(150, 600);
		task.wait();

		const narrowLayout = waitForFreshLock(host, wideLayout, 1);
		const narrowHeight = narrowLayout.CellSize.Y.Offset;
		Assert.greaterThan(
			narrowHeight,
			wideHeight,
			"Expected the text to wrap taller once the cell became narrower",
		);

		host.Size = UDim2.fromOffset(600, 600);
		task.wait();

		const restoredLayout = waitForFreshLock(host, narrowLayout, 1);
		Assert.equal(
			restoredLayout.CellSize.Y.Offset,
			wideHeight,
			"Expected the row height to drop back to the wide-width measurement after widening the container",
		);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A pixel width of 300 lands at exactly 300 inside an 800px host")
	@Test
	public pixelWidth() {
		const { host, root } = mountGrid(
			800,
			<Grid width={300} cols={2}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForGridWidth(host, 300);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[800, 400],
		[240, 120],
	])
	@DisplayName("A 50% width scales with the host, yielding different pixel sizes at different host widths")
	@Test
	public percentWidth(hostWidth: number, expectedGridWidth: number) {
		const { host, root } = mountGrid(
			hostWidth,
			<Grid width="50%" cols={2}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForGridWidth(host, expectedGridWidth);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Leaving width unset keeps the legacy full-parent fill behavior")
	@Test
	public defaultWidth() {
		const { host, root } = mountGrid(
			500,
			<Grid cols={2}>
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		waitForGridWidth(host, 500);

		unmount(root, host);
	}
}

export = GridMountValidation;
