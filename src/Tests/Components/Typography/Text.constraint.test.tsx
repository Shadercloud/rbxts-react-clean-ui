import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	assertTextFits,
	rect,
	settleFrames,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const SHORT_TEXT = "Hello";
const LONG_TEXT = "The quick brown fox jumps over the lazy dog again and again until it wraps.";
const MAX_WIDTH = 120;
const SPACED_TEXT = "Hey";

function waitForLabel(host: Instance): TextLabel {
	return waitForGuiObject<TextLabel>(host, "Text");
}

function textSizeConstraintsOf(instance: Instance): UITextSizeConstraint[] {
	const found: UITextSizeConstraint[] = [];
	for (const child of instance.GetChildren()) {
		if (child.IsA("UITextSizeConstraint")) found.push(child);
	}
	return found;
}

function soleTextSizeConstraint(instance: Instance): UITextSizeConstraint {
	const found = textSizeConstraintsOf(instance);
	Assert.equal(found.size(), 1, `Expected exactly one UITextSizeConstraint directly on ${instance.GetFullName()}`);
	Assert.equal(found[0].Name, "TextSizeConstraint", `Expected the UITextSizeConstraint on ${instance.Name} to be named TextSizeConstraint`);
	return found[0];
}

function boundsFor(kind: string, value: number): { minTextSize?: number; maxTextSize?: number } {
	return kind === "min" ? { minTextSize: value } : { maxTextSize: value };
}

function scaledLabel(maxTextSize?: number) {
	return (
		<Text
			text="Hi"
			TextScaled={true}
			Size={UDim2.fromOffset(300, 200)}
			AutomaticSize={Enum.AutomaticSize.None}
			maxTextSize={maxTextSize}
		/>
	);
}

@Tag("Studio")
class TextSizeLimits {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("maxWidth on a plain label adds a single SizeConstraint capped at that width")
	@Test
	public maxWidthConstraint() {
		withMounted(400, 300, <Text text={LONG_TEXT} maxWidth={MAX_WIDTH} />, (mounted) => {
			const constraint = soleSizeConstraint(waitForLabel(mounted.host));

			Assert.equal(constraint.MaxSize.X, MAX_WIDTH, "Expected MaxSize.X to be the maxWidth");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Long text under maxWidth wraps onto several lines within that width and grows in height")
	@Test
	public maxWidthWraps() {
		withMounted(400, 300, <Text text={LONG_TEXT} maxWidth={MAX_WIDTH} />, (mounted) => {
			const label = waitForGuiObject<TextLabel>(
				mounted.host,
				"Text",
				(gui) => gui.AbsoluteSize.X > 0 && gui.TextBounds.Y > gui.TextSize * 1.5,
				"Timed out waiting for the maxWidth Text to wrap onto more than one line",
			);

			Assert.true(
				rect(label).width <= MAX_WIDTH + 1,
				`Expected the wrapped label width ${rect(label).width} to stay within ${MAX_WIDTH}px`,
			);
			Assert.true(
				rect(label).height > label.TextSize * 1.5,
				`Expected the label height ${rect(label).height} to grow past one line of ${label.TextSize}px`,
			);
			assertTextFits(label, "maxWidth text");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Short text under a wider maxWidth keeps its natural single-line width")
	@Test
	public shortKeepsNatural() {
		withMounted(400, 300, <Text text={SHORT_TEXT} />, (mounted) => {
			const label = waitForLabel(mounted.host);
			const natural = rect(label);

			Assert.true(natural.width < MAX_WIDTH, `Expected the short text width ${natural.width} to be under ${MAX_WIDTH}px`);

			mounted.update(<Text text={SHORT_TEXT} maxWidth={MAX_WIDTH} />);
			settleFrames(2);

			Assert.true(
				math.abs(rect(label).width - natural.width) <= 1,
				`Expected width ${rect(label).width} to stay at the natural ${natural.width}`,
			);
			Assert.true(
				math.abs(rect(label).height - natural.height) <= 1,
				`Expected height ${rect(label).height} to stay at the natural ${natural.height}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("shrinkToFit with maxWidth leaves maxWidth out, so no SizeConstraint is rendered")
	@Test
	public shrinkDropsMaxWidth() {
		withMounted(400, 300, <Text text={SHORT_TEXT} shrinkToFit={true} maxWidth={MAX_WIDTH} />, (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			Assert.equal(sizeConstraintsOf(label).size(), 0, "Expected no UISizeConstraint while shrinkToFit uses maxWidth");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("shrinkToFit with maxWidth and minWidth keeps only the minimum in the SizeConstraint")
	@Test
	public shrinkKeepsMinWidth() {
		withMounted(
			400,
			300,
			<Text text={SHORT_TEXT} shrinkToFit={true} maxWidth={MAX_WIDTH} minWidth={10} />,
			(mounted) => {
				const constraint = soleSizeConstraint(waitForLabel(mounted.host));

				Assert.equal(constraint.MinSize.X, 10, "Expected the minWidth to stay in the constraint");
				Assert.equal(constraint.MaxSize.X, math.huge, "Expected the maxWidth to be left out of the constraint");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("minTextSize and maxTextSize are clamped to 1-100 and a maximum below the minimum is raised to it")
	@Each([
		[10, 40, 10, 40],
		[0, 50, 1, 50],
		[20, 200, 20, 100],
		[40, 20, 40, 40],
		[150, 150, 100, 100],
	])
	@Test
	public textSizeClamped(minTextSize: number, maxTextSize: number, expectedMin: number, expectedMax: number) {
		withMounted(400, 300, <Text text={SHORT_TEXT} minTextSize={minTextSize} maxTextSize={maxTextSize} />, (mounted) => {
			const constraint = soleTextSizeConstraint(waitForLabel(mounted.host));

			Assert.equal(constraint.MinTextSize, expectedMin, "Unexpected MinTextSize");
			Assert.equal(constraint.MaxTextSize, expectedMax, "Unexpected MaxTextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Setting only one text size bound defaults the other to 1 or 100")
	@Each([
		["max", 30, 1, 30],
		["min", 30, 30, 100],
	])
	@Test
	public textSizeDefaults(kind: string, value: number, expectedMin: number, expectedMax: number) {
		withMounted(400, 300, <Text text={SHORT_TEXT} {...boundsFor(kind, value)} />, (mounted) => {
			const constraint = soleTextSizeConstraint(waitForLabel(mounted.host));

			Assert.equal(constraint.MinTextSize, expectedMin, "Unexpected MinTextSize");
			Assert.equal(constraint.MaxTextSize, expectedMax, "Unexpected MaxTextSize");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text puts a TextSizeConstraint on every character label and none on the frame")
	@Test
	public spacedConstraintPerCharacter() {
		withMounted(400, 300, <Text text={SPACED_TEXT} letterSpacing={2} maxTextSize={30} />, (mounted) => {
			const frame = waitForGuiObject<Frame>(mounted.host, "Text");
			let count = 0;

			Assert.equal(textSizeConstraintsOf(frame).size(), 0, "Expected no UITextSizeConstraint on the frame itself");
			for (const child of frame.GetChildren()) {
				if (!child.IsA("TextLabel")) continue;
				count++;
				Assert.equal(soleTextSizeConstraint(child).MaxTextSize, 30, `Unexpected MaxTextSize on ${child.Name}`);
			}
			Assert.equal(count, SPACED_TEXT.size(), "Expected one character label per character");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TextScaled text in a 300x200 box grows past 48px uncapped but stays about 24px with maxTextSize={24}")
	@Test
	public scaledCapped() {
		withMounted(400, 300, scaledLabel(), (mounted) => {
			const label = waitForLabel(mounted.host);

			const uncapped = waitForLayout(
				() => (label.TextBounds.Y > 48 ? label.TextBounds.Y : undefined),
				`Timed out waiting for uncapped TextScaled text to exceed 48px (TextBounds.Y is ${label.TextBounds.Y})`,
			);

			mounted.update(scaledLabel(24));

			const capped = waitForLayout(
				() => (label.TextBounds.Y <= 24 * 1.5 ? label.TextBounds.Y : undefined),
				`Timed out waiting for maxTextSize={24} to cap the text (TextBounds.Y is ${label.TextBounds.Y}, uncapped was ${uncapped})`,
			);

			Assert.true(capped >= 12, `Expected the capped text to stay near 24px, got TextBounds.Y=${capped}`);
		});
	}
}

export = TextSizeLimits;
