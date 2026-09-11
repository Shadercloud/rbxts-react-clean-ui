import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { ProgressBar } from "../../../Components/Surface/ProgressBar";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	assertStackedVertically,
	findDescendant,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const DEFAULT_TRACK_HEIGHT = 16;

function waitForTrack(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "ProgressBar");
}

function waitForFillWidth(track: GuiObject, expectedWidth: number, tolerance: number): Frame {
	const fill = findDescendant<Frame>(track, "Fill");

	waitForLayout(
		() => (math.abs(fill.AbsoluteSize.X - expectedWidth) <= tolerance ? true : undefined),
		`Timed out waiting for the Fill width ${fill.AbsoluteSize.X} to settle within ${tolerance} of ${expectedWidth}`,
	);

	return fill;
}

@Tag("Studio")
class ProgressBarMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["half", 50, 100, 0.5],
		["empty", 0, 100, 0],
		["full", 100, 100, 1],
		["custom max", 25, 50, 0.5],
		["clamped above max", 150, 100, 1],
		["clamped below zero", -20, 100, 0],
	])
	@DisplayName("The Fill's width is value/max of the track width, clamped to the 0..1 range")
	@Test
	public fillFraction(variant: string, value: number, max: number, fraction: number) {
		withMounted(400, 100, <ProgressBar value={value} max={max} />, (mounted) => {
			const track = waitForTrack(mounted.host);
			const trackRect = rect(track);
			const fill = waitForFillWidth(track, trackRect.width * fraction, 1);

			assertSizeApprox(fill, trackRect.width * fraction, trackRect.height, 1, `${variant} fill`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a header the track spans the host width at the theme's md height")
	@Test
	public defaultTrackSize() {
		withMounted(400, 100, <ProgressBar value={50} />, (mounted) => {
			const track = waitForTrack(mounted.host);

			assertSizeApprox(track, 400, DEFAULT_TRACK_HEIGHT, 1, "default track");
			assertContained(track, mounted.host, "default track");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The Fill and everything under it stay inside the clipping track")
	@Test
	public fillContained() {
		withMounted(400, 100, <ProgressBar value={75} striped={false} />, (mounted) => {
			const track = waitForTrack(mounted.host);
			const fill = waitForFillWidth(track, rect(track).width * 0.75, 1);

			Assert.true(track.ClipsDescendants, "Expected the track to clip its descendants by default");
			assertContained(fill, track, "fill vs track");
			assertAllDescendantsContained(track, "progress bar");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("label and showValue render a header with the label text and a rounded percentage above the track")
	@Test
	public headerLabelAndValue() {
		withMounted(400, 100, <ProgressBar value={1} max={3} label="Loading" showValue={true} />, (mounted) => {
			const wrapper = waitForGuiObject<Frame>(mounted.host, "ProgressBar");
			const track = waitForGuiObject<ImageLabel>(wrapper, "ProgressBar");
			const header = findDescendant<Frame>(wrapper, "ProgressBarHeader");
			const label = findDescendant<TextLabel>(header, "ProgressBarLabel");
			const valueText = findDescendant<TextLabel>(header, "ProgressBarValue");

			Assert.equal(label.Text, "Loading", "Expected the label prop to be rendered verbatim");
			Assert.equal(valueText.Text, "33%", "Expected the default formatter to render math.round(value / max * 100)%");

			assertStackedVertically([header, track], "header above track");
			assertContained(header, wrapper, "header vs wrapper");
			assertContained(track, wrapper, "track vs wrapper");
		});
	}
}

export = ProgressBarMountValidation;
