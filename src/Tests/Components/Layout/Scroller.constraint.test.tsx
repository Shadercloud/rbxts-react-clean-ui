import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import {
	STUDIO_SKIP_MESSAGE,
	assertSizeApprox,
	soleSizeConstraint,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 400;
const WINDOW_HEIGHT = 200;
const CONTENT_HEIGHT = 600;
const SCROLLBAR_THICKNESS = 12;

function waitForWrapper(host: Instance): Frame {
	const wrapper = waitForGuiObject<GuiObject>(host, "Scroller");
	Assert.true(wrapper.IsA("Frame"), `Expected a min/max Scroller root to be a wrapper Frame, got ${wrapper.ClassName}`);
	return wrapper as Frame;
}

function waitForOverflow(wrapper: Instance): ScrollingFrame {
	return waitForGuiObject<ScrollingFrame>(
		wrapper,
		"ScrollingFrame",
		(gui) => gui.AbsoluteWindowSize.Y > 0 && gui.AbsoluteCanvasSize.Y >= CONTENT_HEIGHT,
		`Timed out waiting for the inner ScrollingFrame canvas to grow to ${CONTENT_HEIGHT}px`,
	);
}

function assertNoConstraintUnder(scroller: ScrollingFrame) {
	for (const descendant of scroller.GetDescendants()) {
		Assert.false(
			descendant.IsA("UISizeConstraint"),
			`Expected no UISizeConstraint under the ScrollingFrame, found ${descendant.GetFullName()}`,
		);
	}
}

function assertScrolls(wrapper: Frame) {
	const scroller = waitForOverflow(wrapper);

	assertNoConstraintUnder(scroller);
	assertSizeApprox(scroller, undefined, WINDOW_HEIGHT, 1, "ScrollingFrame window");
	Assert.true(
		scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y,
		`Expected the canvas (${scroller.AbsoluteCanvasSize.Y}) to exceed the window (${scroller.AbsoluteWindowSize.Y})`,
	);
	waitForGuiObject<Frame>(
		scroller,
		"ScrollerContent",
		(gui) => gui.AbsoluteSize.X <= scroller.AbsoluteSize.X - SCROLLBAR_THICKNESS,
		"Timed out waiting for ScrollerContent to reserve width for the scrollbar",
	);
}

function tallScroller(props: { height: number; minHeight?: number; maxHeight?: number }) {
	return (
		<Scroller height={props.height} minHeight={props.minHeight} maxHeight={props.maxHeight}>
			<frame key="Content" Size={new UDim2(1, 0, 0, CONTENT_HEIGHT)} BackgroundTransparency={1} />
		</Scroller>
	);
}

@Tag("Studio")
class ScrollerSizeConstraint {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A maxHeight on a plain-theme Scroller clamps the wrapper while tall content still overflows and scrolls")
	@Test
	public maxHeightScrolls() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			tallScroller({ height: WINDOW_HEIGHT, maxHeight: WINDOW_HEIGHT }),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);

				Assert.equal(soleSizeConstraint(wrapper).MaxSize.Y, WINDOW_HEIGHT);
				assertScrolls(wrapper);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A minHeight raises the wrapper to its floor and tall content inside still overflows and scrolls")
	@Test
	public minHeightScrolls() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			tallScroller({ height: 120, minHeight: WINDOW_HEIGHT }),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);

				Assert.equal(soleSizeConstraint(wrapper).MinSize.Y, WINDOW_HEIGHT);
				assertScrolls(wrapper);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A min or max prop alone wraps the plain theme without drawing ScrollerTrack or ScrollerThumb")
	@Test
	public noChromeWithoutTheme() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			tallScroller({ height: WINDOW_HEIGHT, maxHeight: WINDOW_HEIGHT }),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);
				const scroller = waitForOverflow(wrapper);

				Assert.equal(scroller.Parent, wrapper);
				Assert.equal(scroller.ScrollBarImageTransparency, 0);
				Assert.undefined(wrapper.FindFirstChild("ScrollerTrack"));
				Assert.undefined(wrapper.FindFirstChild("ScrollerThumb"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With a min or max prop the forwarded ref receives the inner ScrollingFrame, not the wrapper Frame")
	@Test
	public constrainedRef() {
		const ref = React.createRef<ScrollingFrame>();

		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Scroller ref={ref} maxHeight={WINDOW_HEIGHT} />,
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);
				const scroller = waitForGuiObject<ScrollingFrame>(wrapper, "ScrollingFrame");

				Assert.equal(ref.current, scroller);
			},
		);
	}
}

export = ScrollerSizeConstraint;
