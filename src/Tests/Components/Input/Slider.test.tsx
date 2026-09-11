import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Slider } from "../../../Components/Input/Slider";
import { SizeHelper } from "../../../Helpers";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertSizeApprox,
	assertStackedHorizontally,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

function waitForSlider(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "Slider");
}

function waitForHandleContainer(slider: Instance): Frame {
	return waitForGuiObject<Frame>(slider, "HandleContainer");
}

function waitForHandle(slider: Instance, index: 0 | 1): Frame {
	return waitForGuiObject<Frame>(slider, `Handle-${index}`);
}

function assertHandleAtFraction(handle: GuiObject, container: GuiObject, fraction: number, label: string) {
	const containerRect = rect(container);
	const expectedCenterX = containerRect.left + fraction * containerRect.width;
	const actualCenterX = rect(handle).centerX;

	Assert.true(
		math.abs(actualCenterX - expectedCenterX) <= 1,
		`${label}: expected ${handle.GetFullName()} centerX ${actualCenterX} to be within 1px of ${expectedCenterX} (fraction ${fraction} of the HandleContainer)`,
	);
}

@Tag("Studio")
class SliderMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A single-value slider fills the host width at the theme height and keeps the bar and handle inside itself")
	@Test
	public mountsContained() {
		withMounted(400, 100, <Slider max-value={100} value={50} />, (mounted) => {
			const slider = waitForSlider(mounted.host);
			waitForHandle(slider, 0);

			assertSizeApprox(slider, 400, SizeHelper.toUDim(DefaultTheme.components.slider.height).Offset, 1, "default size");
			assertAllDescendantsContained(slider, "single-value slider");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[0, 0],
		[50, 0.5],
		[100, 1],
	])
	@DisplayName("The handle's centre sits at the value's fraction of the min/max range across the HandleContainer")
	@Test
	public handleReflectsValue(value: number, fraction: number) {
		withMounted(400, 100, <Slider max-value={100} value={value} />, (mounted) => {
			const slider = waitForSlider(mounted.host);
			const container = waitForHandleContainer(slider);
			const handle = waitForHandle(slider, 0);

			assertHandleAtFraction(handle, container, fraction, `value=${value}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("min-value offsets the range so the handle fraction is measured from min-value, not zero")
	@Test
	public respectsMinValue() {
		withMounted(400, 100, <Slider min-value={20} max-value={60} value={30} />, (mounted) => {
			const slider = waitForSlider(mounted.host);
			const container = waitForHandleContainer(slider);
			const handle = waitForHandle(slider, 0);

			assertHandleAtFraction(handle, container, 0.25, "min-value=20");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[true, 0.75],
		[false, 0.25],
	])
	@DisplayName("Re-rendering with a new value moves the handle only when controlled; uncontrolled keeps the seeded value")
	@Test
	public controlledFollowsProp(controlled: boolean, expectedFraction: number) {
		withMounted(400, 100, <Slider max-value={100} value={25} controlled={controlled} />, (mounted) => {
			const slider = waitForSlider(mounted.host);
			const container = waitForHandleContainer(slider);
			const handle = waitForHandle(slider, 0);

			assertHandleAtFraction(handle, container, 0.25, "before re-render");

			mounted.update(<Slider max-value={100} value={75} controlled={controlled} />);

			if (controlled) {
				waitForLayout(
					() => (handle.Position.X.Scale === 0.75 ? true : undefined),
					"Timed out waiting for the controlled handle to move to the new value prop",
				);
			}

			assertHandleAtFraction(handle, container, expectedFraction, `controlled=${controlled} after re-render`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("range={true} renders two ordered handles at the Vector2 bounds, with a middle highlight spanning between them")
	@Test
	public rangeRendersTwoHandles() {
		withMounted(
			400,
			100,
			<Slider max-value={100} range={true} value={new Vector2(20, 80)} highlight="middle" />,
			(mounted) => {
				const slider = waitForSlider(mounted.host);
				const container = waitForHandleContainer(slider);
				const lower = waitForHandle(slider, 0);
				const upper = waitForHandle(slider, 1);
				const highlight = waitForGuiObject<Frame>(slider, "Highlight");

				assertHandleAtFraction(lower, container, 0.2, "range lower handle");
				assertHandleAtFraction(upper, container, 0.8, "range upper handle");
				assertStackedHorizontally([lower, upper], "range handles");

				const highlightRect = rect(highlight);
				Assert.true(
					math.abs(highlightRect.left - rect(lower).centerX) <= 1 && math.abs(highlightRect.right - rect(upper).centerX) <= 1,
					`Expected the middle highlight [${highlightRect.left}, ${highlightRect.right}] to span from the lower handle centre (${rect(lower).centerX}) to the upper handle centre (${rect(upper).centerX})`,
				);

				assertAllDescendantsContained(slider, "range slider");
			},
		);
	}
}

export = SliderMountValidation;
