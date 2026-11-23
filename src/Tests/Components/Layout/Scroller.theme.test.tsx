import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Scroller } from "../../../Components/Layout/Scroller";
import { SpacingHelper } from "../../../Helpers/spacing.helper";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertSizeApprox,
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
const BAR_COLOR = Color3.fromRGB(0, 255, 0);

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

function stableChild(childHeight: number, spacing?: "xl" | "None") {
	return (
		<Scroller stableGutter={true} spacing={spacing}>
			<frame key="Content" Size={new UDim2(1, 0, 0, childHeight)} BackgroundTransparency={1} />
		</Scroller>
	);
}

function waitForPlain(host: Instance): ScrollingFrame {
	const scroller = waitForGuiObject<GuiObject>(host, "Scroller");
	Assert.true(scroller.IsA("ScrollingFrame"), `Expected a plain ScrollingFrame root, got ${scroller.ClassName}`);
	return scroller as ScrollingFrame;
}

function assertContentWidth(scroller: ScrollingFrame, gutter: number) {
	const content = waitForGuiObject<Frame>(scroller, "ScrollerContent");
	const expected = scroller.AbsoluteSize.X - gutter;

	waitForWidth(content, expected, 0.5);
	settleFrames(3);
	Assert.equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X);
	assertSizeApprox(content, expected, undefined, 0.5, `content width with a ${gutter}px gutter`);
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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Theme thickness sizes the native bar and theme gutter sets the reserved gap on its own")
	@Test
	public themeThicknessGutter() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ barColor: BAR_COLOR, thickness: 8, gutter: 12 }, 0, stableChild(50)),
			(mounted) => {
				const scroller = waitForPlain(mounted.host);

				Assert.equal(scroller.ScrollBarThickness, 8);
				Assert.equal(scroller.ScrollBarImageColor3, BAR_COLOR);
				assertContentWidth(scroller, 12);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["xl"], ["None"]])
	@DisplayName("Once the theme sets a gutter, the spacing prop no longer changes the reserved gap")
	@Test
	public gutterIgnoresSpacing(spacing: "xl" | "None") {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			themed({ thickness: 8, gutter: 12 }, 0, stableChild(50, spacing)),
			(mounted) => {
				assertContentWidth(waitForPlain(mounted.host), 12);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without thickness or gutter keys the bar is 12px and the gap is 12px plus the default spacing padding")
	@Test
	public defaultFallback() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({}, 0, stableChild(50)), (mounted) => {
			const scroller = waitForPlain(mounted.host);

			Assert.equal(scroller.ScrollBarThickness, 12);
			assertContentWidth(scroller, 12 + SpacingHelper.GetPadding(DefaultTheme, undefined));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["xl"], ["None"]])
	@DisplayName("Without a theme gutter the spacing prop widens or removes the padding part of the gap")
	@Test
	public spacingDrivesGutter(spacing: "xl" | "None") {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({ thickness: 8 }, 0, stableChild(50, spacing)), (mounted) => {
			assertContentWidth(waitForPlain(mounted.host), 8 + SpacingHelper.GetPadding(DefaultTheme, spacing));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Negative thickness and gutter are treated as zero, leaving no bar and full-width content")
	@Test
	public negativeClamped() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({ thickness: -4, gutter: -6 }, 0, stableChild(50)), (mounted) => {
			const scroller = waitForPlain(mounted.host);

			Assert.equal(scroller.ScrollBarThickness, 0);
			assertContentWidth(scroller, 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("barColor, thickness and gutter alone keep the plain ScrollingFrame tree with no track or thumb")
	@Test
	public sizingKeysPlain() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({ barColor: BAR_COLOR, thickness: 8, gutter: 12 }, 400), (mounted) => {
			const scroller = waitForPlain(mounted.host);

			Assert.equal(scroller.Parent, mounted.host);
			Assert.undefined(mounted.host.FindFirstChild("ScrollerTrack", true));
			Assert.undefined(mounted.host.FindFirstChild("ScrollerThumb", true));
			Assert.undefined(mounted.host.FindFirstChild("ScrollingFrame", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["theme"], ["default"]])
	@DisplayName("The decorated ScrollerTrack and native bar are as wide as the theme thickness, or 12px by default")
	@Test
	public trackThickness(source: "theme" | "default") {
		const expected = source === "theme" ? 8 : 12;
		const theme: ScrollerTheme = source === "theme" ? { trackColor: TRACK_COLOR, thickness: 8 } : { trackColor: TRACK_COLOR };

		withMounted(HOST_WIDTH, HOST_HEIGHT, themed(theme, 400), (mounted) => {
			const wrapper = waitForWrapper(mounted.host);
			const scroller = waitForOverflow(wrapper);
			const track = waitForDescendant<Frame>(wrapper, "ScrollerTrack", () => true);

			Assert.equal(track.Size.X.Offset, expected);
			Assert.equal(track.Size.X.Scale, 0);
			Assert.equal(scroller.ScrollBarThickness, expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The custom ScrollerThumb is as wide as the theme thickness and sits flush with the right edge")
	@Test
	public thumbThickness() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({ thumbBorderThickness: 2, thickness: 8 }, 400), (mounted) => {
			const wrapper = waitForWrapper(mounted.host);
			waitForOverflow(wrapper);
			const thumb = waitForDescendant<Frame>(
				wrapper,
				"ScrollerThumb",
				(gui) => gui.Visible,
				"Timed out waiting for the custom thumb to show while overflowing",
			);

			Assert.equal(thumb.Size.X.Offset, 8);
			Assert.equal(thumb.Position.X.Scale, 1);
			Assert.equal(thumb.Position.X.Offset, -8);
		});
	}
}

export = ScrollerThemeDecoration;
