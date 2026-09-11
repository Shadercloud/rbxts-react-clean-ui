import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertNonZeroSize,
	assertTextFits,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const SHORT_TEXT = "Hello";
const LONG_TEXT = "The quick brown fox jumps over the lazy dog again and again until it wraps.";
const NARROW_WIDTH = 120;

function narrowText(text: string, wrap: boolean) {
	return (
		<Text text={text} TextWrap={wrap}>
			<uisizeconstraint key="MaxWidth" MaxSize={new Vector2(NARROW_WIDTH, math.huge)} />
		</Text>
	);
}

function waitForText(host: Instance): TextLabel {
	return waitForGuiObject<TextLabel>(host, "Text");
}

@Tag("Studio")
class TextMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Renders the text prop verbatim in an auto-sized TextLabel that fits its content")
	@Test
	public rendersText() {
		withMounted(400, 300, <Text text={SHORT_TEXT} />, (mounted) => {
			const label = waitForText(mounted.host);

			Assert.equal(label.Text, SHORT_TEXT, "Expected the text prop to be rendered verbatim");
			assertNonZeroSize(label, "short text");
			assertTextFits(label, "short text");
			assertContained(label, mounted.host, "short text");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Long text bounded to 120px wraps onto multiple lines and still fits its label")
	@Test
	public wrapsAtNarrowWidth() {
		withMounted(400, 300, narrowText(LONG_TEXT, true), (mounted) => {
			const label = waitForGuiObject<TextLabel>(
				mounted.host,
				"Text",
				(gui) => gui.AbsoluteSize.X > 0 && gui.TextBounds.Y > gui.TextSize * 1.5,
				"Timed out waiting for the bounded Text to wrap onto more than one line",
			);

			Assert.true(label.TextWrapped, "Expected TextWrapped to be on by default");
			Assert.true(
				rect(label).width <= NARROW_WIDTH + 1,
				`Expected the wrapped label width ${rect(label).width} to stay within ${NARROW_WIDTH}px`,
			);
			assertTextFits(label, "wrapped text");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TextWrap={false} keeps long text on a single line instead of wrapping")
	@Test
	public noWrapStaysSingleLine() {
		withMounted(400, 300, narrowText(LONG_TEXT, false), (mounted) => {
			const label = waitForText(mounted.host);

			Assert.false(label.TextWrapped, "Expected TextWrap={false} to turn TextWrapped off on the instance");
			Assert.true(
				label.TextBounds.Y <= label.TextSize * 1.5,
				`Expected a single line of text, got TextBounds.Y=${label.TextBounds.Y} for TextSize=${label.TextSize}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Updating to a longer text prop grows the auto-sized label's width")
	@Test
	public growsWithContent() {
		withMounted(600, 300, <Text text={SHORT_TEXT} />, (mounted) => {
			const label = waitForText(mounted.host);
			const shortWidth = rect(label).width;

			mounted.update(<Text text={LONG_TEXT} />);

			const longWidth = waitForLayout(
				() => (label.AbsoluteSize.X > shortWidth ? label.AbsoluteSize.X : undefined),
				`Timed out waiting for the label to grow past its short-text width of ${shortWidth}`,
			);

			Assert.equal(label.Text, LONG_TEXT, "Expected the label to show the updated text");
			Assert.true(longWidth > shortWidth, `Expected long text width ${longWidth} to exceed short text width ${shortWidth}`);
		});
	}
}

export = TextMountValidation;
