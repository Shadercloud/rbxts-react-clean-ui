import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Text } from "../../../Components/Typography/Text";
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
const SHRINK_EPSILON = 0.01;

function app(ignore: boolean, child: React.ReactElement) {
	return (
		<CleanUiProvider theme={DefaultTheme} toasts={false} ignorePreferredTextSize={ignore}>
			{child}
		</CleanUiProvider>
	);
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

function boundsFor(minTextSize: number, maxTextSize: number): { minTextSize?: number; maxTextSize?: number } {
	return {
		minTextSize: minTextSize > 0 ? minTextSize : undefined,
		maxTextSize: maxTextSize > 0 ? maxTextSize : undefined,
	};
}

@Tag("Studio")
class TextPreferredTextSize {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch on, each variant's label is pinned to its theme size in pixels")
	@Each([
		["display", 48],
		["title", 32],
		["heading", 24],
		["body", 18],
		["label", 14],
		["caption", 10],
	])
	@Test
	public pinsVariant(variant: TextVariant, expected: number) {
		withMounted(400, 300, app(true, <Text text="Hello" variant={variant} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertTextSizePinned(label, expected);
			Assert.equal(label.TextSize, expected, "Expected the pin to match the label's own TextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch off, a plain label has no PinTextSize and no other text size constraint")
	@Test
	public offNoPin() {
		withMounted(400, 300, app(false, <Text text="Hello" />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
			Assert.equal(textSizeConstraintsOf(label).size(), 0, "Expected no UITextSizeConstraint with the switch off");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without any CleanUiProvider the label is never pinned")
	@Test
	public noProviderNoPin() {
		withMounted(400, 300, <Text text="Hello" />, (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(2);

			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A typography override's size is the one pinned, not the variant's")
	@Test
	public pinsTypographyOverride() {
		const typography = { ...DefaultTheme.typography.body, size: Enum.FontSize.Size12 };

		withMounted(400, 300, app(true, <Text text="Hello" typography={typography} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertTextSizePinned(label, 12);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text pins every character label and leaves the frame without a constraint")
	@Test
	public pinsSpacedChars() {
		withMounted(400, 300, app(true, <Text text={SPACED_TEXT} letterSpacing={2} variant="heading" />), (mounted) => {
			const frame = waitForText<Frame>(mounted.host);
			settleFrames(1);

			Assert.true(frame.IsA("Frame"), "Expected the letter-spaced root to be a Frame");
			Assert.equal(textSizeConstraintsOf(frame).size(), 0, "Expected no UITextSizeConstraint on the frame itself");

			const labels = characterLabels(frame);
			Assert.equal(labels.size(), SPACED_TEXT.size(), "Expected one character label per character");
			for (const label of labels) {
				assertTextSizePinned(label, 24);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text with the switch off leaves every character label unpinned")
	@Test
	public spacedOffNoPin() {
		withMounted(400, 300, app(false, <Text text={SPACED_TEXT} letterSpacing={2} />), (mounted) => {
			const frame = waitForText<Frame>(mounted.host);
			settleFrames(2);

			for (const label of characterLabels(frame)) {
				assertTextSizeNotPinned(label);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Re-rendering with a different variant updates the pin to the new size")
	@Test
	public tracksVariant() {
		withMounted(400, 300, app(true, <Text text="Hello" variant="body" />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);
			assertTextSizePinned(label, 18);

			mounted.update(app(true, <Text text="Hello" variant="title" />));
			settleFrames(1);

			assertTextSizePinned(label, 32);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Turning the switch on and off at runtime adds and removes the pin")
	@Test
	public tracksSwitch() {
		withMounted(400, 300, app(false, <Text text="Hello" />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);
			assertTextSizeNotPinned(label);

			mounted.update(app(true, <Text text="Hello" />));
			settleFrames(1);
			assertTextSizePinned(label, 18);

			mounted.update(app(false, <Text text="Hello" />));
			settleFrames(1);
			assertTextSizeNotPinned(label);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TextScaled={true} text is never pinned even with the switch on")
	@Test
	public scaledSkipped() {
		withMounted(
			400,
			300,
			app(true, <Text text="Hi" TextScaled={true} Size={UDim2.fromOffset(300, 200)} AutomaticSize={Enum.AutomaticSize.None} />),
			(mounted) => {
				const label = waitForText<TextLabel>(mounted.host);
				settleFrames(2);

				assertTextSizeNotPinned(label);
				Assert.equal(textSizeConstraintsOf(label).size(), 0, "Expected no UITextSizeConstraint on scaled text");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TextScaled={true} with maxTextSize keeps the plain TextSizeConstraint instead of a pin")
	@Test
	public scaledKeepsBounds() {
		withMounted(
			400,
			300,
			app(true, <Text text="Hi" TextScaled={true} maxTextSize={24} Size={UDim2.fromOffset(300, 200)} AutomaticSize={Enum.AutomaticSize.None} />),
			(mounted) => {
				const label = waitForText<TextLabel>(mounted.host);
				settleFrames(1);

				const found = textSizeConstraintsOf(label);
				Assert.equal(found.size(), 1, "Expected exactly one UITextSizeConstraint");
				Assert.equal(found[0].Name, "TextSizeConstraint", "Expected the bounds constraint, not a pin");
				Assert.equal(found[0].MaxTextSize, 24, "Unexpected MaxTextSize");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A TextScaled binding opens the pin to 1-100 while true and pins the style size while false")
	@Test
	public scaledBinding() {
		const [scaled, setScaled] = React.createBinding(true);

		withMounted(400, 300, app(true, <Text text="Hi" TextScaled={scaled} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			const pin = label.FindFirstChild("PinTextSize") as UITextSizeConstraint | undefined;
			Assert.notUndefined(pin, "Expected a PinTextSize constraint driven by the binding");
			Assert.equal(textSizeConstraintsOf(label).size(), 1, "Expected only the binding-driven constraint");
			Assert.equal(pin!.MinTextSize, 1, "Expected MinTextSize 1 while scaled");
			Assert.equal(pin!.MaxTextSize, 100, "Expected MaxTextSize 100 while scaled");

			setScaled(false);
			settleFrames(1);

			assertTextSizePinned(label, 18);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With minTextSize/maxTextSize the pin replaces TextSizeConstraint, at the body size clamped into the range")
	@Each([
		[0, 12, 12],
		[24, 0, 24],
		[10, 30, 18],
		[18, 18, 18],
		[0, 150, 18],
	])
	@Test
	public boundsReplaced(minTextSize: number, maxTextSize: number, expected: number) {
		withMounted(400, 300, app(true, <Text text="Hello" {...boundsFor(minTextSize, maxTextSize)} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			assertTextSizePinned(label, expected);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the switch off, minTextSize/maxTextSize still render the plain TextSizeConstraint")
	@Test
	public boundsKeptWhenOff() {
		withMounted(400, 300, app(false, <Text text="Hello" minTextSize={10} maxTextSize={30} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			settleFrames(1);

			const found = textSizeConstraintsOf(label);
			Assert.equal(found.size(), 1, "Expected exactly one UITextSizeConstraint");
			Assert.equal(found[0].Name, "TextSizeConstraint", "Expected the bounds constraint");
			Assert.equal(found[0].MinTextSize, 10, "Unexpected MinTextSize");
			Assert.equal(found[0].MaxTextSize, 30, "Unexpected MaxTextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text with maxTextSize pins each character to the clamped size with no leftover bounds constraint")
	@Test
	public spacedBoundsReplaced() {
		withMounted(400, 300, app(true, <Text text={SPACED_TEXT} letterSpacing={2} maxTextSize={12} />), (mounted) => {
			const frame = waitForText<Frame>(mounted.host);
			settleFrames(1);

			for (const label of characterLabels(frame)) {
				assertTextSizePinned(label, 12);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("shrinkToFit pins at the style size times the ShrinkScale so the pin follows the shrink")
	@Test
	public shrinkScalesPin() {
		withMounted(400, 300, app(true, <Text text="A long title" shrinkToFit={true} maxWidth={40} />), (mounted) => {
			const label = waitForText<TextLabel>(mounted.host);
			const shrink = waitForDescendant<UIScale>(mounted.host, "ShrinkScale", () => true);
			settleFrames(3);

			Assert.true(shrink.Scale < 1 - SHRINK_EPSILON, `Expected the text to shrink (ShrinkScale is ${shrink.Scale})`);

			const found = textSizeConstraintsOf(label);
			Assert.equal(found.size(), 1, "Expected exactly one UITextSizeConstraint");
			Assert.equal(found[0].Name, "PinTextSize", "Expected the pin constraint");
			Assert.equal(found[0].MinTextSize, found[0].MaxTextSize, "Expected MinTextSize to equal MaxTextSize");

			const expected = 18 * shrink.Scale;
			Assert.true(
				math.abs(found[0].MinTextSize - expected) <= 1,
				`Expected the pin to be about ${expected}, got ${found[0].MinTextSize}`,
			);
		});
	}
}

export = TextPreferredTextSize;
