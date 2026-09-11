import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	findDescendant,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 150;
const SCROLLBAR_THICKNESS = 12;

function scrollerWithChild(childHeight: number) {
	return (
		<Scroller>
			<frame key="Content" Size={new UDim2(1, 0, 0, childHeight)} BackgroundTransparency={1} />
		</Scroller>
	);
}

function waitForScroller(host: Instance): ScrollingFrame {
	return waitForGuiObject<ScrollingFrame>(host, "Scroller");
}

@Tag("Studio")
class ScrollerMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no size props the Scroller fills its host and auto-sizes its canvas vertically")
	@Test
	public fillsHostByDefault() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);

			assertSizeApprox(scroller, HOST_WIDTH, HOST_HEIGHT, 1, "default size");
			Assert.equal(scroller.AutomaticCanvasSize, Enum.AutomaticSize.Y);
			Assert.equal(scroller.ScrollingDirection, Enum.ScrollingDirection.Y);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Content shorter than the window stays inside the frame, does not overflow the canvas and keeps the full width")
	@Test
	public shortContentContained() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");

			assertAllDescendantsContained(scroller, "short content");
			Assert.true(
				scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y,
				`Expected a 50px child not to overflow: canvas ${scroller.AbsoluteCanvasSize.Y} vs window ${scroller.AbsoluteWindowSize.Y}`,
			);
			assertSizeApprox(content, HOST_WIDTH, undefined, 1, "short content width");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Content taller than the window grows the canvas past the window and reserves width for the scrollbar")
	@Test
	public canvasGrowsWithContent() {
		const tallHeight = 400;

		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(tallHeight), (mounted) => {
			const scroller = waitForGuiObject<ScrollingFrame>(
				mounted.host,
				"Scroller",
				(gui) => gui.AbsoluteCanvasSize.Y >= tallHeight,
				`Timed out waiting for the canvas to grow to at least ${tallHeight}px`,
			);

			Assert.true(
				scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y,
				`Expected the canvas (${scroller.AbsoluteCanvasSize.Y}) to exceed the window (${scroller.AbsoluteWindowSize.Y})`,
			);

			const content = waitForGuiObject<Frame>(
				scroller,
				"ScrollerContent",
				(gui) => gui.AbsoluteSize.X <= scroller.AbsoluteSize.X - SCROLLBAR_THICKNESS,
				"Timed out waiting for ScrollerContent to reserve width for the scrollbar",
			);

			const child = findDescendant<Frame>(content, "Content");
			assertContained(child, content, "tall child vs content frame");
		});
	}
}

export = ScrollerMountValidation;
