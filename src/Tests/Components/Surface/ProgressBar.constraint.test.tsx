import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { ProgressBar } from "../../../Components/Surface/ProgressBar";
import {
	STUDIO_SKIP_MESSAGE,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 100;

@Tag("Studio")
class ProgressBarSizeConstraint {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without min or max props a labelled bar renders no UISizeConstraint on the wrapper or the track")
	@Test
	public noConstraintWhenUnset() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <ProgressBar value={50} label="Loading" striped={false} />, (mounted) => {
			const header = waitForGuiObject<Frame>(mounted.host, "ProgressBar");
			const track = waitForGuiObject<ImageLabel>(header, "ProgressBar");

			Assert.equal(sizeConstraintsOf(header).size(), 0);
			Assert.equal(sizeConstraintsOf(track).size(), 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An unlabelled bar puts the constraint on its track and clamps it")
	@Test
	public trackClamped() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <ProgressBar value={50} maxWidth={150} striped={false} />, (mounted) => {
			const track = waitForGuiObject<ImageLabel>(mounted.host, "ProgressBar");

			Assert.true(track.IsA("ImageLabel"), "Expected the unlabelled ProgressBar root to be the track");
			Assert.equal(soleSizeConstraint(track).MaxSize.X, 150);
			waitForWidth(track, 150);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A labelled bar clamps both the header wrapper and the track so the header row matches the track width")
	@Test
	public headerWrapperClamped() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<ProgressBar value={50} label="Loading" showValue={true} maxWidth={200} striped={false} />,
			(mounted) => {
				const header = waitForGuiObject<Frame>(mounted.host, "ProgressBar");
				const track = waitForGuiObject<ImageLabel>(header, "ProgressBar");

				Assert.true(header.IsA("Frame"), "Expected the labelled ProgressBar root to be the header wrapper");
				Assert.equal(soleSizeConstraint(header).MaxSize.X, 200);
				Assert.equal(soleSizeConstraint(track).MaxSize.X, 200);
				waitForWidth(header, 200);
				waitForWidth(track, 200);
			},
		);
	}
}

export = ProgressBarSizeConstraint;
