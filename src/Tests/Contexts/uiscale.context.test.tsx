import React from "@rbxts/react";
import { Workspace } from "@rbxts/services";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { UiScaleRoot } from "../../Components/Layout/UiScaleRoot";
import { useDesignViewportSize, useUiScale } from "../../Contexts/uiscale.context";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForLayout, withMounted } from "../Helpers/layout";

const EPSILON = 1e-6;
const VIEWPORT_EPSILON = 0.01;

let latestScale: number | undefined;
let latestViewport: Vector2 | undefined;

function resetHarness() {
	latestScale = undefined;
	latestViewport = undefined;
}

function ScaleHarness() {
	latestScale = useUiScale();
	latestViewport = useDesignViewportSize();
	return undefined;
}

function cameraViewport(): Vector2 {
	const camera = Workspace.CurrentCamera;
	Assert.notUndefined(camera, "Expected Workspace.CurrentCamera to exist for useDesignViewportSize");
	return camera!.ViewportSize;
}

function waitForScale(expected: number): number {
	return waitForLayout(
		() => (latestScale !== undefined && math.abs(latestScale - expected) <= EPSILON ? latestScale : undefined),
		`Timed out waiting for useUiScale to return ${expected} (last value ${latestScale})`,
	);
}

function waitForDesignViewport(scale: number): Vector2 {
	const viewport = cameraViewport();
	const expected = viewport.div(scale);

	return waitForLayout(
		() =>
			latestViewport !== undefined &&
			math.abs(latestViewport.X - expected.X) <= VIEWPORT_EPSILON &&
			math.abs(latestViewport.Y - expected.Y) <= VIEWPORT_EPSILON
				? latestViewport
				: undefined,
		`Timed out waiting for useDesignViewportSize to return (${expected.X}, ${expected.Y}) at scale ${scale} (last value ${latestViewport})`,
	);
}

function scaled(scale: number) {
	return (
		<UiScaleRoot scale={scale}>
			<ScaleHarness />
		</UiScaleRoot>
	);
}

@Tag("Studio")
class UiScaleHookValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Outside any UiScaleRoot the effective scale is the context default of 1")
	@Test
	public defaultScale() {
		resetHarness();

		withMounted(200, 200, <ScaleHarness />, () => {
			waitForLayout(() => latestScale, "Timed out waiting for the harness to render");

			Assert.equal(latestScale, 1, "Expected useUiScale to default to 1 with no root");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1], [1.25], [1.5]])
	@DisplayName("Inside a single UiScaleRoot the effective scale is that root's scale prop")
	@Test
	public rootScale(scale: number) {
		resetHarness();

		withMounted(200, 200, scaled(scale), () => {
			waitForScale(scale);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1.25, 1.2, 1.5],
		[1.5, 1, 1.5],
		[2, 0.5, 1],
	])
	@DisplayName("Nested roots publish the product of every scale above the caller")
	@Test
	public nestedMultiply(outer: number, inner: number, expected: number) {
		resetHarness();

		const element = (
			<UiScaleRoot scale={outer}>
				<UiScaleRoot name="InnerRoot" scale={inner}>
					<ScaleHarness />
				</UiScaleRoot>
			</UiScaleRoot>
		);

		withMounted(200, 200, element, () => {
			waitForScale(expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no root the design viewport size equals the camera's ViewportSize")
	@Test
	public viewportUnscaled() {
		resetHarness();

		withMounted(200, 200, <ScaleHarness />, () => {
			waitForDesignViewport(1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1.25], [1.5]])
	@DisplayName("Inside a root the design viewport size is the camera's ViewportSize divided by the effective scale")
	@Test
	public viewportDivided(scale: number) {
		resetHarness();

		withMounted(200, 200, scaled(scale), () => {
			waitForDesignViewport(scale);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the root's scale prop re-renders consumers with the new design viewport size")
	@Test
	public viewportFollowsScale() {
		resetHarness();

		withMounted(200, 200, scaled(1), (mounted) => {
			waitForDesignViewport(1);

			mounted.update(scaled(1.5));
			waitForScale(1.5);
			waitForDesignViewport(1.5);

			mounted.update(scaled(1.25));
			waitForScale(1.25);
			waitForDesignViewport(1.25);
			settleFrames(2);

			waitForDesignViewport(1.25);
		});
	}
}

export = UiScaleHookValidation;
