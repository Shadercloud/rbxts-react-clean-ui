import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { PinTextSize } from "../../../Components/Typography/PinTextSize";
import { UiScaleRoot } from "../../../Components/Layout/UiScaleRoot";
import {
	STUDIO_SKIP_MESSAGE,
	assertTextSizeNotPinned,
	assertTextSizePinned,
	settleFrames,
	waitForDescendant,
	withMounted,
} from "../../Helpers/layout";

function pinnedLabel(size: number) {
	return (
		<textlabel key="Label" Text="Pinned" TextSize={size} Size={UDim2.fromOffset(100, 30)}>
			<PinTextSize size={size} />
		</textlabel>
	);
}

function scaledLabel(scale: number, size: number) {
	return <UiScaleRoot scale={scale}>{pinnedLabel(size)}</UiScaleRoot>;
}

function nestedLabel(outer: number, inner: number, size: number) {
	return (
		<UiScaleRoot scale={outer} name="OuterRoot">
			<UiScaleRoot scale={inner} name="InnerRoot">
				{pinnedLabel(size)}
			</UiScaleRoot>
		</UiScaleRoot>
	);
}

function waitForLabel(host: Instance): TextLabel {
	return waitForDescendant<TextLabel>(host, "Label", () => true);
}

@Tag("Studio")
class PinTextSizeUiScale {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Under a UiScaleRoot the pin is the design size times the root scale")
	@Each([
		[1, 18, 18],
		[1.5, 18, 27],
		[3, 18, 54],
		[1.5, 24, 36],
		[3, 24, 72],
	])
	@Test
	public scalesPin(scale: number, size: number, expected: number) {
		withMounted(400, 300, scaledLabel(scale, size), (mounted) => {
			assertTextSizePinned(waitForLabel(mounted.host), expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Nested UiScaleRoots multiply, so 1.25 inside 1.2 pins at 1.5 times the size")
	@Each([
		[1.25, 1.2, 18, 27],
		[2, 1.5, 10, 30],
	])
	@Test
	public nestedMultiplies(outer: number, inner: number, size: number, expected: number) {
		withMounted(400, 300, nestedLabel(outer, inner, size), (mounted) => {
			assertTextSizePinned(waitForLabel(mounted.host), expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the root scale prop re-pins the existing label at the new screen size")
	@Test
	public tracksScale() {
		withMounted(400, 300, scaledLabel(1, 18), (mounted) => {
			const label = waitForLabel(mounted.host);
			assertTextSizePinned(label, 18);

			mounted.update(scaledLabel(1.5, 18));
			settleFrames(1);
			assertTextSizePinned(label, 27);

			mounted.update(scaledLabel(3, 18));
			settleFrames(1);
			assertTextSizePinned(label, 54);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A screen size above 100 renders no pin rather than a capped one")
	@Each([
		[3, 48],
		[3, 96],
		[2, 60],
	])
	@Test
	public overCapNoPin(scale: number, size: number) {
		withMounted(400, 300, scaledLabel(scale, size), (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A screen size of exactly 100 is still pinned")
	@Each([
		[1, 100],
		[2, 50],
		[2.5, 40],
	])
	@Test
	public exactCapPins(scale: number, size: number) {
		withMounted(400, 300, scaledLabel(scale, size), (mounted) => {
			assertTextSizePinned(waitForLabel(mounted.host), 100);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Scaling the root up past the cap removes the pin and scaling back down restores it")
	@Test
	public capToggles() {
		withMounted(400, 300, scaledLabel(1, 48), (mounted) => {
			const label = waitForLabel(mounted.host);
			assertTextSizePinned(label, 48);

			mounted.update(scaledLabel(3, 48));
			settleFrames(2);
			assertTextSizeNotPinned(label);

			mounted.update(scaledLabel(2, 48));
			settleFrames(1);
			assertTextSizePinned(label, 96);
		});
	}
}

export = PinTextSizeUiScale;
