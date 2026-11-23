import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import { SpacingHelper } from "../../../Helpers/spacing.helper";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	findDescendant,
	settleFrames,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForLayout,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 150;
const SCROLLBAR_THICKNESS = 12;
const DEFAULT_GUTTER = SCROLLBAR_THICKNESS + SpacingHelper.GetPadding(DefaultTheme, undefined);

function scrollerWithChild(childHeight: number) {
	return (
		<Scroller>
			<frame key="Content" Size={new UDim2(1, 0, 0, childHeight)} BackgroundTransparency={1} />
		</Scroller>
	);
}

function stableScroller(childHeight: number) {
	return (
		<Scroller stableGutter={true}>
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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[false], [true]])
	@DisplayName("The native inset is always None, so the canvas is as wide as the ScrollingFrame")
	@Test
	public insetNone(stable: boolean) {
		const element = stable ? stableScroller(50) : scrollerWithChild(50);

		withMounted(HOST_WIDTH, HOST_HEIGHT, element, (mounted) => {
			const scroller = waitForScroller(mounted.host);

			Assert.equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None);
			Assert.equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[false, 50, false],
		[false, 400, true],
		[true, 50, true],
		[true, 400, true],
	])
	@DisplayName("Content reserves the default gutter with stableGutter or while overflowing, and is full width otherwise")
	@Test
	public contentWidth(stable: boolean, childHeight: number, reserves: boolean) {
		const element = stable ? stableScroller(childHeight) : scrollerWithChild(childHeight);

		withMounted(HOST_WIDTH, HOST_HEIGHT, element, (mounted) => {
			const scroller = waitForScroller(mounted.host);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");
			const overflows = childHeight > HOST_HEIGHT;

			waitForLayout(
				() => ((scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y) === overflows ? true : undefined),
				`Expected the ${childHeight}px child ${overflows ? "to" : "not to"} overflow`,
			);

			const expected = scroller.AbsoluteSize.X - (reserves ? DEFAULT_GUTTER : 0);
			waitForWidth(content, expected, 0.5);
			settleFrames(3);
			assertSizeApprox(content, expected, undefined, 0.5, "content width");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("While overflowing, the gap is taken once from the full canvas width rather than twice")
	@Test
	public gutterCountedOnce() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(400), (mounted) => {
			const scroller = waitForGuiObject<ScrollingFrame>(
				mounted.host,
				"Scroller",
				(gui) => gui.AbsoluteCanvasSize.Y > gui.AbsoluteWindowSize.Y && gui.AbsoluteWindowSize.Y > 0,
				"Timed out waiting for the Scroller to overflow",
			);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");

			waitForWidth(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, 0.5);
			settleFrames(3);

			Assert.equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None);
			Assert.equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X);
			assertSizeApprox(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, undefined, 0.5, "single gutter");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("stableGutter narrows short content by exactly one gutter even though the bar is hidden")
	@Test
	public stableGutterNarrows() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");

			Assert.equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None);
			Assert.true(
				scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y,
				`Expected 50px of content not to overflow (canvas ${scroller.AbsoluteCanvasSize.Y}, window ${scroller.AbsoluteWindowSize.Y})`,
			);
			waitForWidth(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, 0.5);
			assertSizeApprox(content, HOST_WIDTH - DEFAULT_GUTTER, undefined, 0.5, "stable gutter width");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With stableGutter the content width does not change when the content starts to overflow")
	@Test
	public stableGutterSteady() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");
			const shortWidth = content.AbsoluteSize.X;

			mounted.update(stableScroller(400));
			waitForLayout(
				() => (scroller.AbsoluteCanvasSize.Y >= 400 ? true : undefined),
				"Timed out waiting for the canvas to grow to 400px",
			);
			waitForLayout(() => (scroller.AbsoluteWindowSize.X > 0 ? true : undefined), "Expected a laid-out window");

			assertSizeApprox(content, shortWidth, undefined, 0.5, "overflowing content width");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An object ref and a callback ref both receive the root ScrollingFrame of the plain tree")
	@Test
	public plainRef() {
		const objectRef = React.createRef<ScrollingFrame>();
		let callbackInstance: ScrollingFrame | undefined;

		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<frame key="Refs" Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1}>
				<Scroller name="ObjectRef" ref={objectRef} />
				<Scroller name="CallbackRef" ref={(instance: ScrollingFrame | undefined) => (callbackInstance = instance)} />
			</frame>,
			(mounted) => {
				const objectTarget = waitForGuiObject<ScrollingFrame>(mounted.host, "ObjectRef");
				const callbackTarget = waitForGuiObject<ScrollingFrame>(mounted.host, "CallbackRef");

				Assert.true(objectTarget.IsA("ScrollingFrame"));
				Assert.equal(objectRef.current, objectTarget);
				Assert.equal(callbackInstance, callbackTarget);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without min or max props the plain ScrollingFrame has no UISizeConstraint")
	@Test
	public noConstraintWhenUnset() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), (mounted) => {
			Assert.equal(sizeConstraintsOf(waitForScroller(mounted.host)).size(), 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A maxWidth wraps the ScrollingFrame in a Frame that holds the only SizeConstraint and caps the inner window")
	@Test
	public wrapperClamped() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Scroller maxWidth={180}>
				<frame key="Content" Size={new UDim2(1, 0, 0, 50)} BackgroundTransparency={1} />
			</Scroller>,
			(mounted) => {
				const wrapper = waitForGuiObject<GuiObject>(mounted.host, "Scroller");
				Assert.true(wrapper.IsA("Frame"), `Expected a maxWidth Scroller root to be a wrapper Frame, got ${wrapper.ClassName}`);
				const scroller = waitForGuiObject<ScrollingFrame>(wrapper, "ScrollingFrame");

				Assert.equal(scroller.Parent, wrapper);
				Assert.equal(soleSizeConstraint(wrapper).MaxSize.X, 180);
				Assert.equal(sizeConstraintsOf(scroller).size(), 0);
				Assert.equal(sizeConstraintsOf(waitForGuiObject<Frame>(scroller, "ScrollerContent")).size(), 0);
				waitForWidth(wrapper, 180);
				waitForWidth(scroller, 180);
			},
		);
	}
}

export = ScrollerMountValidation;
