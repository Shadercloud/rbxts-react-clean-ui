import React from "@rbxts/react";
import { Workspace } from "@rbxts/services";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { UiScaleRoot } from "../../../Components/Layout/UiScaleRoot";
import { BreakpointProvider } from "../../../Components/Layout/BreakpointProvider";
import { Row } from "../../../Components/Layout/Row";
import { Column } from "../../../Components/Layout/Column";
import { Grid } from "../../../Components/Layout/Grid";
import { Fieldset } from "../../../Components/Layout/Fieldset";
import { VStack } from "../../../Components/Layout/VStack";
import { Text } from "../../../Components/Typography/Text";
import { BreakpointContext, BreakpointContextValue, useBreakpoint } from "../../../Contexts/breakpoint.context";
import { BreakpointHelper } from "../../../Helpers/breakpoint.helper";
import { Breakpoint } from "../../../Interfaces/responsive.types";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertSizeApprox,
	settleFrames,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const SCREEN_WIDTH = 420;
const HOST_HEIGHT = 300;
const DEFAULT_GAP = 12;

let latestBreakpoint: Breakpoint | undefined;
let latestContext: BreakpointContextValue | undefined;

function resetHarness() {
	latestBreakpoint = undefined;
	latestContext = undefined;
}

function BreakpointHarness() {
	latestBreakpoint = useBreakpoint();
	latestContext = React.useContext(BreakpointContext);
	return undefined;
}

function scaled(scale: number, children: React.ReactNode) {
	return <UiScaleRoot scale={scale}>{children}</UiScaleRoot>;
}

function assertFixturePredicts(scale: number, expected: Breakpoint) {
	const predicted = BreakpointHelper.getBreakpoint(SCREEN_WIDTH / scale, DefaultTheme.breakpoints);

	Assert.equal(
		predicted,
		expected,
		`Fixture out of date with DefaultTheme.breakpoints: ${SCREEN_WIDTH}px / ${scale} resolves to "${predicted}", not "${expected}"`,
	);
}

function screenBreakpoint(): Breakpoint {
	return BreakpointHelper.getBreakpoint(SCREEN_WIDTH, DefaultTheme.breakpoints);
}

function assertNotRoomier(resolved: Breakpoint, scale: number) {
	const unscaled = screenBreakpoint();

	Assert.true(
		BreakpointHelper.compare(resolved, "<=", unscaled),
		`Expected "${resolved}" at scale ${scale} not to be roomier than the unscaled "${unscaled}"`,
	);

	if (scale > 1) {
		Assert.true(
			BreakpointHelper.compare(resolved, "<", unscaled),
			`Expected "${resolved}" at scale ${scale} to be narrower than the unscaled "${unscaled}"`,
		);
	}
}

function waitForBreakpoint(expected: Breakpoint) {
	waitForLayout(
		() => (latestBreakpoint === expected ? true : undefined),
		`Timed out waiting for useBreakpoint to return "${expected}" (last value "${latestBreakpoint}")`,
	);
}

function waitForScreenWidth<T extends GuiObject>(host: Instance, name: string): T {
	return waitForGuiObject<T>(
		host,
		name,
		(gui) => math.abs(gui.AbsoluteSize.X - SCREEN_WIDTH) <= 1,
		`Timed out waiting for ${name} to span the ${SCREEN_WIDTH}px host on screen`,
	);
}

function expectedColumnWidth(rowWidth: number, span: number, gap: number) {
	const fraction = math.floor((span / 12) * 1000) / 1000;
	return fraction * rowWidth + (fraction - 1) * gap;
}

function viewportWidth(): number {
	const camera = Workspace.CurrentCamera;
	Assert.notUndefined(camera, "Expected Workspace.CurrentCamera to exist for the viewport fallback");
	return camera!.ViewportSize.X;
}

function fieldset(scale: number) {
	return scaled(
		scale,
		<frame key="Form" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<VStack>
				<Fieldset wrap="md">
					<Fieldset.Label>
						<Text text="Label" />
					</Fieldset.Label>
					<Fieldset.Control>
						<frame key="ControlContent" BackgroundTransparency={1} Size={UDim2.fromOffset(120, 32)} />
					</Fieldset.Control>
				</Fieldset>
			</VStack>
		</frame>,
	);
}

@Tag("Studio")
class UiScaleBreakpointValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, "lg"],
		[1.25, "md"],
		[1.5, "sm"],
	])
	@DisplayName("BreakpointProvider resolves a 420px-wide screen area against its design width, screen width / scale")
	@Test
	public providerDesignWidth(scale: number, expected: Breakpoint) {
		assertFixturePredicts(scale, expected);
		resetHarness();

		const element = scaled(
			scale,
			<BreakpointProvider>
				<BreakpointHarness />
			</BreakpointProvider>,
		);

		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, (mounted) => {
			waitForScreenWidth<Frame>(mounted.host, "BreakpointProvider");
			settleFrames(2);
			waitForBreakpoint(expected);

			Assert.notUndefined(latestContext, "Expected the harness to read a BreakpointContext value");
			Assert.true(
				math.abs(latestContext!.width - SCREEN_WIDTH / scale) <= 1,
				`Expected the published width ${latestContext!.width} to be the design width ${SCREEN_WIDTH / scale}`,
			);
			assertNotRoomier(latestBreakpoint!, scale);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the root's scale re-resolves the provider's breakpoint without the screen width changing")
	@Test
	public providerRescales() {
		resetHarness();

		const element = (scale: number) =>
			scaled(
				scale,
				<BreakpointProvider>
					<BreakpointHarness />
				</BreakpointProvider>,
			);

		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element(1), (mounted) => {
			waitForScreenWidth<Frame>(mounted.host, "BreakpointProvider");
			waitForBreakpoint("lg");

			mounted.update(element(1.5));
			waitForBreakpoint("sm");
			settleFrames(3);
			Assert.equal(latestBreakpoint, "sm", "Expected the provider to stay at sm after rescaling to 1.5");

			mounted.update(element(1));
			waitForBreakpoint("lg");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, "lg"],
		[1.25, "md"],
		[1.5, "sm"],
	])
	@DisplayName("Without a provider, useBreakpoint resolves the camera viewport width divided by the effective scale")
	@Test
	public viewportDesignWidth(scale: number, expected: Breakpoint) {
		resetHarness();

		const width = viewportWidth();
		const theme = {
			...DefaultTheme,
			breakpoints: { xs: 0, sm: width / 1.5 - 1, md: width / 1.25 - 1, lg: width - 1, xl: width + 1 },
		};

		Assert.equal(
			BreakpointHelper.getBreakpoint(width / scale, theme.breakpoints),
			expected,
			`Fixture thresholds do not predict "${expected}" for viewport width ${width} at scale ${scale}`,
		);

		const element = scaled(
			scale,
			<ThemeProvider theme={theme}>
				<BreakpointHarness />
			</ThemeProvider>,
		);

		withMounted(100, HOST_HEIGHT, element, () => {
			waitForBreakpoint(expected);
			settleFrames(2);

			Assert.equal(latestBreakpoint, expected, `Expected the viewport fallback to stay at "${expected}"`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, "lg", 4],
		[1.25, "md", 6],
		[1.5, "sm", 9],
	])
	@DisplayName("A responsive Column span follows the Row's design-pixel breakpoint, giving fewer columns at higher scales")
	@Test
	public rowDesignWidth(scale: number, breakpoint: Breakpoint, span: number) {
		assertFixturePredicts(scale, breakpoint);

		const element = scaled(
			scale,
			<Row>
				<Column name="Responsive" span={{ xs: 12, sm: 9, md: 6, lg: 4 }}>
					<frame key="ResponsiveContent" BackgroundTransparency={1} Size={new UDim2(1, 0, 0, 40)} />
				</Column>
			</Row>,
		);

		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, (mounted) => {
			const row = waitForScreenWidth<Frame>(mounted.host, "Row");
			const expected = scale * expectedColumnWidth(SCREEN_WIDTH / scale, span, DEFAULT_GAP);
			const col = waitForGuiObject<Frame>(
				row,
				"Responsive",
				(gui) => math.abs(gui.AbsoluteSize.X - expected) <= 1.5,
				`Timed out waiting for the Column to resolve span ${span} (${expected}px on screen) at scale ${scale}`,
			);

			settleFrames(2);
			assertSizeApprox(col, expected, undefined, 1.5, `span ${span} at scale ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, "lg", 4],
		[1.25, "md", 3],
		[1.5, "sm", 2],
	])
	@DisplayName("Responsive Grid cols follow the Grid's design-pixel breakpoint, locking fewer columns at higher scales")
	@Test
	public gridDesignWidth(scale: number, breakpoint: Breakpoint, cols: number) {
		assertFixturePredicts(scale, breakpoint);

		const element = scaled(
			scale,
			<Grid cols={{ xs: 1, sm: 2, md: 3, lg: 4 }}>
				<frame Size={UDim2.fromOffset(10, 10)} />
				<frame Size={UDim2.fromOffset(10, 10)} />
				<frame Size={UDim2.fromOffset(10, 10)} />
				<frame Size={UDim2.fromOffset(10, 10)} />
			</Grid>,
		);

		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, (mounted) => {
			waitForScreenWidth<Frame>(mounted.host, "Grid");
			waitForDescendant<UIGridLayout>(
				mounted.host,
				"GridLayout",
				(layout) => layout.FillDirectionMaxCells === cols,
				`Timed out waiting for the Grid to lock ${cols} columns at scale ${scale}`,
			);

			settleFrames(3);
			const layout = waitForDescendant<UIGridLayout>(mounted.host, "GridLayout", () => true);
			Assert.equal(layout.FillDirectionMaxCells, cols, `Expected the Grid to stay at ${cols} columns at scale ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, "lg", false],
		[1.25, "md", true],
		[1.5, "sm", true],
	])
	@DisplayName("A Fieldset set to wrap at md starts wrapping once the root's scale brings its design width to md or below")
	@Test
	public fieldsetDesignWidth(scale: number, breakpoint: Breakpoint, expectedWraps: boolean) {
		assertFixturePredicts(scale, breakpoint);

		withMounted(SCREEN_WIDTH, HOST_HEIGHT, fieldset(1), (mounted) => {
			const root = waitForScreenWidth<ImageLabel>(mounted.host, "Fieldset");

			waitForDescendant<UIListLayout>(
				root,
				"HStack",
				(layout) => layout.Wraps === false,
				"Timed out waiting for the unscaled Fieldset to measure lg and stop wrapping",
			);

			mounted.update(fieldset(scale));

			const layout = waitForDescendant<UIListLayout>(
				root,
				"HStack",
				(candidate) => candidate.Wraps === expectedWraps,
				`Timed out waiting for the Fieldset's UIListLayout to report Wraps=${expectedWraps} at scale ${scale}`,
			);

			settleFrames(3);
			Assert.equal(layout.Wraps, expectedWraps, `Expected Wraps=${expectedWraps} to hold at scale ${scale}`);
		});
	}
}

export = UiScaleBreakpointValidation;
