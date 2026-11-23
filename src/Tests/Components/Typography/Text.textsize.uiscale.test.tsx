import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import { UiScaleRoot } from "../../../Components/Layout/UiScaleRoot";
import { TextVariant } from "../../../Interfaces";
import { CleanUiProvider } from "../../../Providers/app.provider";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertTextSizeNotPinned,
	assertTextSizePinned,
	settleFrames,
	textSizeConstraintsOf,
	waitForDescendant,
	withMounted,
} from "../../Helpers/layout";

const SPACED_TEXT = "Hey";
const SCALE_EPSILON = 0.01;

function app(ignore: boolean, child: React.ReactElement) {
	return (
		<CleanUiProvider theme={DefaultTheme} toasts={false} ignorePreferredTextSize={ignore}>
			{child}
		</CleanUiProvider>
	);
}

function scaled(scale: number, child: React.ReactElement, ignore = true) {
	return app(ignore, <UiScaleRoot scale={scale}>{child}</UiScaleRoot>);
}

function waitForText<T extends Instance>(host: Instance): T {
	return waitForDescendant<T>(host, "Text", () => true);
}

function characterLabels(frame: Instance): TextLabel[] {
	const labels: TextLabel[] = [];
	for (const child of frame.GetChildren()) {
		if (child.IsA("TextLabel")) labels.push(child);
	}
	return labels;
}

function assertBoundsConstraint(label: TextLabel, expectedMin: number, expectedMax: number) {
	const found = textSizeConstraintsOf(label);
	Assert.equal(found.size(), 1, "Expected exactly one UITextSizeConstraint");
	Assert.equal(found[0].Name, "TextSizeConstraint", "Expected the bounds constraint, not a pin");
	Assert.equal(found[0].MinTextSize, expectedMin, "Unexpected MinTextSize");
	Assert.equal(found[0].MaxTextSize, expectedMax, "Unexpected MaxTextSize");
}

@Tag("Studio")
class TextPreferredTextSizeUiScale {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Under a UiScaleRoot the pin is the label's own TextSize times the root scale")
	@Each([
		[1, "body", 18],
		[1.5, "body", 18],
		[3, "body", 18],
		[1, "heading", 24],
		[1.5, "heading", 24],
		[3, "heading", 24],
	])
	@Test
	public pinsScaled(scale: number, variant: TextVariant, size: number) {
		withMounted(400, 300, scaled(scale, <Text text="Hello" variant={variant} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			Assert.equal(label.TextSize, size, "Expected the label's TextSize to stay at the design size");
			assertTextSizePinned(label, label.TextSize * scale);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text under a 1.5 root pins every character label at 1.5 times the size")
	@Test
	public pinsSpacedScaled() {
		withMounted(400, 300, scaled(1.5, <Text text={SPACED_TEXT} letterSpacing={2} variant="heading" />), (mounted) => {
			const frame = waitForText<Frame>(mounted.host);
			settleFrames(1);

			Assert.equal(textSizeConstraintsOf(frame).size(), 0, "Expected no UITextSizeConstraint on the frame itself");

			const labels = characterLabels(frame);
			Assert.equal(labels.size(), SPACED_TEXT.size(), "Expected one character label per character");
			for (const label of labels) {
				assertTextSizePinned(label, 36);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Nested roots of 1.25 and 1.2 multiply into a 1.5 times pin")
	@Test
	public nestedMultiplies() {
		const tree = app(
			true,
			<UiScaleRoot scale={1.25} name="OuterRoot">
				<UiScaleRoot scale={1.2} name="InnerRoot">
					<Text text="Hello" />
				</UiScaleRoot>
			</UiScaleRoot>,
		);

		withMounted(400, 300, tree, (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertTextSizePinned(label, 27);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Changing the root scale prop re-pins the same label at each new screen size")
	@Test
	public tracksScale() {
		withMounted(400, 300, scaled(1, <Text text="Hello" />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);
			assertTextSizePinned(label, 18);

			mounted.update(scaled(1.5, <Text text="Hello" />));
			settleFrames(1);
			assertTextSizePinned(label, 27);

			mounted.update(scaled(3, <Text text="Hello" />));
			settleFrames(1);
			assertTextSizePinned(label, 54);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A pin that would exceed 100 on screen is dropped and no other constraint takes its place")
	@Each([
		["display", 3],
		["title", 3.5],
	])
	@Test
	public overCapNoPin(variant: TextVariant, scale: number) {
		withMounted(400, 300, scaled(scale, <Text text="Hello" variant={variant} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
			Assert.equal(textSizeConstraintsOf(label).size(), 0, "Expected no UITextSizeConstraint without min/max bounds");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A 96 typography override at scale 3 renders no PinTextSize")
	@Test
	public overrideOverCap() {
		const typography = { ...DefaultTheme.typography.body, size: Enum.FontSize.Size96 };

		withMounted(400, 300, scaled(3, <Text text="Hi" typography={typography} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A pin landing on exactly 100 on screen is still emitted")
	@Test
	public exactCapPins() {
		withMounted(400, 300, scaled(5, <Text text="Hello" minTextSize={20} maxTextSize={20} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertTextSizePinned(label, 100);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Above the cap, minTextSize/maxTextSize fall back to a TextSizeConstraint scaled and clamped to 1-100")
	@Each([
		[3, 10, 40, 30, 100],
		[3, 12, 50, 36, 100],
		[2.5, 20, 60, 50, 100],
	])
	@Test
	public overCapBounds(scale: number, minTextSize: number, maxTextSize: number, expectedMin: number, expectedMax: number) {
		withMounted(
			400,
			300,
			scaled(scale, <Text text="Hello" variant="display" minTextSize={minTextSize} maxTextSize={maxTextSize} />),
			(mounted) => {
				const label = waitForText<TextLabel>(mounted.host);
				settleFrames(2);

				assertTextSizeNotPinned(label);
				assertBoundsConstraint(label, expectedMin, expectedMax);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch off, minTextSize/maxTextSize under a 1.5 root render a 1.5 times TextSizeConstraint")
	@Test
	public offBoundsScaled() {
		withMounted(400, 300, scaled(1.5, <Text text="Hello" minTextSize={10} maxTextSize={30} />, false), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertBoundsConstraint(label, 15, 45);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("shrinkToFit under a 1.5 root pins at the size times the root scale times the ShrinkScale")
	@Test
	public shrinkScaledPin() {
		withMounted(400, 300, scaled(1.5, <Text text="A long title" shrinkToFit={true} maxWidth={40} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			const shrink = waitForDescendant<UIScale>(mounted.host, "ShrinkScale", () => true);
			settleFrames(3);

			Assert.true(shrink.Scale < 1 - SCALE_EPSILON, `Expected the text to shrink (ShrinkScale is ${shrink.Scale})`);

			const found = textSizeConstraintsOf(label);
			Assert.equal(found.size(), 1, "Expected exactly one UITextSizeConstraint");
			Assert.equal(found[0].Name, "PinTextSize", "Expected the pin constraint");
			Assert.equal(found[0].MinTextSize, found[0].MaxTextSize, "Expected MinTextSize to equal MaxTextSize");

			const expected = 18 * 1.5 * shrink.Scale;
			Assert.true(
				math.abs(found[0].MinTextSize - expected) <= 1,
				`Expected the pin to be about ${expected}, got ${found[0].MinTextSize}`,
			);
		});
	}
}

export = TextPreferredTextSizeUiScale;
