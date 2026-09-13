import React from "@rbxts/react";
import { Workspace } from "@rbxts/services";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { BreakpointProvider } from "../../Components/Layout/BreakpointProvider";
import { useBreakpoint, useBreakpointValue } from "../../Contexts/breakpoint.context";
import { BreakpointHelper } from "../../Helpers/breakpoint.helper";
import { Breakpoint, ResponsiveValue } from "../../Interfaces/responsive.types";
import { ThemeProvider } from "../../Providers/theme.provider";
import { DefaultTheme } from "../../Theme";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, waitForLayout, withMounted } from "../Helpers/layout";

let latestBreakpoint: Breakpoint | undefined;
let latestValue: string | undefined;
let harnessRendered = false;

function resetHarness() {
	latestBreakpoint = undefined;
	latestValue = undefined;
	harnessRendered = false;
}

function BreakpointHarness() {
	latestBreakpoint = useBreakpoint();
	harnessRendered = true;
	return undefined;
}

function ValueHarness(props: { value: ResponsiveValue<string> | undefined }) {
	latestBreakpoint = useBreakpoint();
	latestValue = useBreakpointValue(props.value);
	harnessRendered = true;
	return undefined;
}

function viewportWidth(): number {
	const camera = Workspace.CurrentCamera;
	Assert.notUndefined(camera, "Expected Workspace.CurrentCamera to exist for the viewport fallback");
	return camera!.ViewportSize.X;
}

function waitForBreakpoint(expected: Breakpoint) {
	waitForLayout(
		() => (latestBreakpoint === expected ? true : undefined),
		`Timed out waiting for useBreakpoint to return "${expected}" (last value "${latestBreakpoint}")`,
	);
}

function settle(frames: number) {
	for (let frame = 0; frame < frames; frame++) {
		task.wait();
	}
}

@Tag("Studio")
class BreakpointHookValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a provider the hook resolves the camera viewport width against the default theme breakpoints")
	@Test
	public viewportDefaultTheme() {
		resetHarness();

		const expected = BreakpointHelper.getBreakpoint(viewportWidth(), DefaultTheme.breakpoints);

		withMounted(50, 300, <BreakpointHarness />, () => {
			waitForLayout(() => (harnessRendered ? true : undefined), "Timed out waiting for the harness to render");
			settle(2);

			Assert.equal(latestBreakpoint, expected, `Expected the viewport breakpoint for width ${viewportWidth()}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a provider the hook uses the viewport and theme thresholds, not the width of its container")
	@Test
	public viewportIgnoresContainer() {
		resetHarness();

		const width = viewportWidth();
		const theme = { ...DefaultTheme, breakpoints: { xs: 0, sm: 1, md: width, lg: width + 1, xl: width + 2 } };

		const element = (
			<ThemeProvider theme={theme}>
				<BreakpointHarness />
			</ThemeProvider>
		);

		withMounted(100, 300, element, () => {
			waitForBreakpoint("md");
			settle(2);

			Assert.equal(latestBreakpoint, "md", "Expected the viewport width to land exactly on the md threshold");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A breakpoint object falls back to the nearest set entry at or below the current breakpoint")
	@Each([
		[450, "lg", "md-value"],
		[350, "md", "md-value"],
		[250, "sm", "xs-value"],
		[50, "xs", "xs-value"],
	])
	@Test
	public valueFallsBack(width: number, breakpoint: Breakpoint, expected: string) {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<ValueHarness value={{ xs: "xs-value", md: "md-value" }} />
			</BreakpointProvider>
		);

		withMounted(width, 300, element, (mounted) => {
			waitForGuiObject<Frame>(mounted.host, "BreakpointProvider", (frame) => frame.AbsoluteSize.X === width);
			settle(2);
			waitForBreakpoint(breakpoint);

			Assert.equal(latestValue, expected, `Expected ${breakpoint} to resolve to "${expected}"`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A breakpoint object with nothing set at or below the current breakpoint resolves to undefined")
	@Test
	public valueUndefinedBelow() {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<ValueHarness value={{ lg: "lg-value" }} />
			</BreakpointProvider>
		);

		withMounted(250, 300, element, () => {
			waitForBreakpoint("sm");
			settle(2);

			Assert.undefined(latestValue, "Expected no value when only lg is set and the breakpoint is sm");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A plain value is returned unchanged at any breakpoint")
	@Test
	public plainValue() {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<ValueHarness value="plain" />
			</BreakpointProvider>
		);

		withMounted(450, 300, element, () => {
			waitForBreakpoint("lg");

			Assert.equal(latestValue, "plain", "Expected a non-object value to pass straight through");
		});
	}
}

export = BreakpointHookValidation;
