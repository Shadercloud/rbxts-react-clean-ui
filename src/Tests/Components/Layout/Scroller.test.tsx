import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import { SpacingHelper } from "../../../Helpers/spacing.helper";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertSizeApprox,
	findDescendant,
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

function gutterWidth(scroller: ScrollingFrame) {
	return scroller.AbsoluteWindowSize.X - SCROLLBAR_THICKNESS - SpacingHelper.GetPadding(DefaultTheme, undefined);
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
	@DisplayName("Without stableGutter the scrollbar inset only applies while the bar is shown")
	@Test
	public defaultInset() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);

			Assert.equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.ScrollBar);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("stableGutter always insets the bar and narrows short content as if it overflowed")
	@Test
	public stableGutterNarrows() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), (mounted) => {
			const scroller = waitForScroller(mounted.host);
			const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");

			Assert.equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.Always);
			Assert.true(
				scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y,
				`Expected 50px of content not to overflow (canvas ${scroller.AbsoluteCanvasSize.Y}, window ${scroller.AbsoluteWindowSize.Y})`,
			);
			waitForWidth(content, gutterWidth(scroller));
			Assert.true(
				content.AbsoluteSize.X < HOST_WIDTH - SCROLLBAR_THICKNESS,
				`Expected the content (${content.AbsoluteSize.X}) to leave the gutter free`,
			);
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
