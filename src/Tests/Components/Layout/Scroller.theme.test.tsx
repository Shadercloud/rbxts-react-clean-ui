import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	settleFrames,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForDescendant,
	waitForGuiObject,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 150;
const TRACK_COLOR = Color3.fromRGB(255, 0, 0);
const BORDER_COLOR = Color3.fromRGB(0, 0, 255);

type ScrollerTheme = Partial<typeof DefaultTheme.components.scroller>;

function themed(scroller: ScrollerTheme, childHeight: number, extra?: React.ReactElement) {
	return (
		<ThemeProvider theme={extendTheme(DefaultTheme, { components: { scroller } })}>
			{extra ?? (
				<Scroller>
					<frame key="Content" Size={new UDim2(1, 0, 0, childHeight)} BackgroundTransparency={1} />
				</Scroller>
			)}
		</ThemeProvider>
	);
}

function waitForWrapper(host: Instance): Frame {
	const wrapper = waitForGuiObject<GuiObject>(host, "Scroller");
	Assert.true(wrapper.IsA("Frame"), `Expected the decorated Scroller root to be a Frame, got ${wrapper.ClassName}`);
	return wrapper as Frame;
}

function waitForOverflow(wrapper: Instance): ScrollingFrame {
	return waitForGuiObject<ScrollingFrame>(
		wrapper,
		"ScrollingFrame",
		(gui) => gui.AbsoluteCanvasSize.Y > gui.AbsoluteWindowSize.Y && gui.AbsoluteWindowSize.Y > 0,
		"Timed out waiting for the decorated ScrollingFrame to overflow",
	);
}

@Tag("Studio")
class ScrollerThemeDecoration {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no optional theme keys the root stays the plain ScrollingFrame with the native bar and no overlays")
	@Test
	public plainTreeUnchanged() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({}, 400), (mounted) => {
			const scroller = waitForGuiObject<GuiObject>(mounted.host, "Scroller");

			Assert.true(scroller.IsA("ScrollingFrame"), `Expected a ScrollingFrame root, got ${scroller.ClassName}`);
			Assert.equal(scroller.Parent, mounted.host);
			Assert.equal((scroller as ScrollingFrame).ScrollBarImageTransparency, 0);
			Assert.undefined(mounted.host.FindFirstChild("ScrollerTrack", true));
			Assert.undefined(mounted.host.FindFirstChild("ScrollerThumb", true));
			Assert.undefined(mounted.host.FindFirstChild("ScrollingFrame", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("trackTransparency alone or a zero thumbBorderThickness keeps the plain tree")
	@Test
	public inertKeysPlain() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ trackTransparency: 0.5, thumbBorderThickness: 0, thumbBorderColor: BORDER_COLOR }, 400),
			(mounted) => {
				const scroller = waitForGuiObject<GuiObject>(mounted.host, "Scroller");

				Assert.true(scroller.IsA("ScrollingFrame"), `Expected a ScrollingFrame root, got ${scroller.ClassName}`);
				Assert.undefined(mounted.host.FindFirstChild("ScrollerTrack", true));
				Assert.undefined(mounted.host.FindFirstChild("ScrollerThumb", true));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A trackColor draws a themed ScrollerTrack that is hidden for short content and shown once it overflows")
	@Test
	public trackWhileOverflowing() {
		const theme: ScrollerTheme = { trackColor: TRACK_COLOR, trackTransparency: 0.25 };

		withMounted(HOST_WIDTH, HOST_HEIGHT, themed(theme, 50), (mounted) => {
			const wrapper = waitForWrapper(mounted.host);
			const track = waitForDescendant<Frame>(wrapper, "ScrollerTrack", () => true);
			settleFrames(3);

			Assert.false(track.Visible, "Expected the track to stay hidden while the content fits");
			Assert.equal(track.BackgroundColor3, TRACK_COLOR);
			Assert.equal(track.BackgroundTransparency, 0.25);
			Assert.undefined(wrapper.FindFirstChild("ScrollerThumb"));

			mounted.update(themed(theme, 400));
			waitForOverflow(wrapper);
			waitForDescendant<Frame>(
				wrapper,
				"ScrollerTrack",
				(gui) => gui.Visible,
				"Timed out waiting for the track to show once the content overflows",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A positive thumbBorderThickness hides the native thumb and draws ScrollerThumb with a ThumbBorder stroke")
	@Test
	public customThumb() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ thumbBorderThickness: 2, thumbBorderColor: BORDER_COLOR }, 400),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);
				const scroller = waitForOverflow(wrapper);
				const thumb = waitForDescendant<Frame>(
					wrapper,
					"ScrollerThumb",
					(gui) => gui.Visible,
					"Timed out waiting for the custom thumb to show while overflowing",
				);
				const border = thumb.FindFirstChild("ThumbBorder");

				Assert.equal(scroller.ScrollBarImageTransparency, 1);
				Assert.equal(thumb.Parent, wrapper);
				Assert.notUndefined(border, "Expected a ThumbBorder stroke on the thumb");
				Assert.true(border!.IsA("UIStroke"));
				Assert.equal((border as UIStroke).Thickness, 2);
				Assert.equal((border as UIStroke).Color, BORDER_COLOR);
				Assert.undefined(wrapper.FindFirstChild("ScrollerTrack"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The custom thumb is hidden when the content does not overflow")
	@Test
	public thumbHiddenShort() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({ thumbBorderThickness: 2 }, 50), (mounted) => {
			const wrapper = waitForWrapper(mounted.host);
			const thumb = waitForDescendant<Frame>(wrapper, "ScrollerThumb", () => true);
			settleFrames(3);

			Assert.false(thumb.Visible, "Expected no visible custom thumb for short content");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In the decorated tree the forwarded ref receives the inner ScrollingFrame, not the wrapper")
	@Test
	public decoratedRef() {
		const ref = React.createRef<ScrollingFrame>();

		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ trackColor: TRACK_COLOR }, 0, <Scroller ref={ref} />),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);
				const scroller = waitForGuiObject<ScrollingFrame>(wrapper, "ScrollingFrame");

				Assert.equal(ref.current, scroller);
				Assert.true(ref.current!.IsA("ScrollingFrame"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In the decorated tree the SizeConstraint moves to the wrapper and the window follows its clamp")
	@Test
	public decoratedConstraint() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ trackColor: TRACK_COLOR }, 0, <Scroller maxWidth={180} />),
			(mounted) => {
				const wrapper = waitForWrapper(mounted.host);
				const scroller = waitForGuiObject<ScrollingFrame>(wrapper, "ScrollingFrame");

				Assert.equal(soleSizeConstraint(wrapper).MaxSize.X, 180);
				Assert.equal(sizeConstraintsOf(scroller).size(), 0);
				waitForWidth(wrapper, 180);
				waitForWidth(scroller, 180);
			},
		);
	}
}

export = ScrollerThemeDecoration;
