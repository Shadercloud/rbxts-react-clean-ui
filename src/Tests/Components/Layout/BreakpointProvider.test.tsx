import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { BreakpointProvider } from "../../../Components/Layout/BreakpointProvider";
import { BreakpointContext, BreakpointContextValue, useBreakpoint } from "../../../Contexts/breakpoint.context";
import { Breakpoint } from "../../../Interfaces/responsive.types";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, waitForLayout, withMounted } from "../../Helpers/layout";

let renderCount = 0;
let latestBreakpoint: Breakpoint | undefined;
let latestContext: BreakpointContextValue | undefined;

function resetHarness() {
	renderCount = 0;
	latestBreakpoint = undefined;
	latestContext = undefined;
}

function BreakpointHarness() {
	renderCount += 1;
	latestBreakpoint = useBreakpoint();
	latestContext = React.useContext(BreakpointContext);
	return undefined;
}

function waitForProviderWidth(host: Instance, width: number): Frame {
	return waitForGuiObject<Frame>(
		host,
		"BreakpointProvider",
		(frame) => frame.AbsoluteSize.X === width,
		`Timed out waiting for the BreakpointProvider frame to measure ${width}px wide`,
	);
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
class BreakpointProviderMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A consumer receives the breakpoint matching the provider's measured width against the theme breakpoints")
	@Each([
		[50, "xs"],
		[250, "sm"],
		[350, "md"],
		[450, "lg"],
		[600, "xl"],
	])
	@Test
	public measuredBreakpoint(width: number, expected: Breakpoint) {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<BreakpointHarness />
			</BreakpointProvider>
		);

		withMounted(width, 300, element, (mounted) => {
			waitForProviderWidth(mounted.host, width);
			settle(2);
			waitForBreakpoint(expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The context publishes the width measured when the breakpoint was resolved")
	@Test
	public publishesWidth() {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<BreakpointHarness />
			</BreakpointProvider>
		);

		withMounted(250, 300, element, (mounted) => {
			waitForProviderWidth(mounted.host, 250);
			waitForBreakpoint("sm");

			Assert.notUndefined(latestContext, "Expected the consumer to read a BreakpointContext value under the provider");
			Assert.equal(latestContext!.width, 250, "Expected the context width to be the provider's measured width");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A breakpoints prop overrides the theme thresholds")
	@Test
	public breakpointsProp() {
		resetHarness();

		const element = (
			<BreakpointProvider breakpoints={{ xs: 0, sm: 50, md: 100, lg: 150, xl: 1000 }}>
				<BreakpointHarness />
			</BreakpointProvider>
		);

		withMounted(150, 300, element, (mounted) => {
			waitForProviderWidth(mounted.host, 150);
			waitForBreakpoint("lg");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Resizing within a breakpoint leaves consumers alone, crossing a threshold re-renders them once")
	@Test
	public rerendersOnCrossing() {
		resetHarness();

		const element = (
			<BreakpointProvider>
				<BreakpointHarness />
			</BreakpointProvider>
		);

		withMounted(250, 300, element, (mounted) => {
			waitForProviderWidth(mounted.host, 250);
			waitForBreakpoint("sm");
			settle(3);

			const baseline = renderCount;

			mounted.resize(280, 300);
			waitForProviderWidth(mounted.host, 280);
			settle(3);

			Assert.equal(latestBreakpoint, "sm", "Expected a 280px provider to stay at sm");
			Assert.equal(renderCount, baseline, `Expected no consumer renders while resizing within sm (baseline ${baseline}, now ${renderCount})`);

			mounted.resize(290, 300);
			waitForProviderWidth(mounted.host, 290);
			settle(3);

			Assert.equal(renderCount, baseline, `Expected no consumer renders after a second resize within sm (baseline ${baseline}, now ${renderCount})`);

			mounted.resize(350, 300);
			waitForProviderWidth(mounted.host, 350);
			waitForBreakpoint("md");
			settle(3);

			Assert.equal(renderCount, baseline + 1, `Expected exactly one consumer render when crossing into md (baseline ${baseline}, now ${renderCount})`);
		});
	}
}

export = BreakpointProviderMountValidation;
