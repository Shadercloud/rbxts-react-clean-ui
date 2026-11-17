import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import { STUDIO_SKIP_MESSAGE, rect, settleFrames, waitForDescendant, waitForGuiObject, waitForLayout, withMounted } from "../../Helpers/layout";

const SEPARATOR = "|";
const ASCII_TEXT = "Hello";
const SPACING = 3;
const GRINNING_FACE = "\u{1F600}";
const FLAG = "\u{1F1EF}\u{1F1F5}";
const FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}";
const HEBREW = "\u{5E9}\u{5DC}\u{5D5}\u{5DD}";
const ARABIC = "\u{645}\u{631}\u{62D}\u{628}\u{627}";
const DEVANAGARI = "\u{928}\u{92E}\u{938}\u{94D}\u{924}\u{947}";

function waitForRoot(host: Instance): GuiObject {
	return waitForDescendant<GuiObject>(host, "Text", () => true);
}

function characterLabels(frame: Instance): TextLabel[] {
	const found: TextLabel[] = [];
	for (const child of frame.GetChildren()) {
		if (child.IsA("TextLabel")) found.push(child);
	}
	found.sort((a, b) => a.LayoutOrder < b.LayoutOrder);
	return found;
}

function letterSpacingLayout(frame: Instance): UIListLayout {
	const layout = frame.FindFirstChild("LetterSpacing");
	Assert.notUndefined(layout, `Expected a LetterSpacing layout directly under ${frame.GetFullName()}`);
	Assert.true(layout!.IsA("UIListLayout"), `Expected LetterSpacing to be a UIListLayout, got ${layout!.ClassName}`);
	return layout as UIListLayout;
}

@Tag("Studio")
class TextLetterSpacing {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["Año", "A|ñ|o"],
		["Über", "Ü|b|e|r"],
		["cafe\u{301}", "c|a|f|e\u{301}"],
		["Привет", "П|р|и|в|е|т"],
		["日本語", "日|本|語"],
		[GRINNING_FACE, GRINNING_FACE],
		[`a${FLAG}b`, `a|${FLAG}|b`],
		[`a${FAMILY}b`, `a|${FAMILY}|b`],
	])
	@DisplayName("Letter-spaced non-English text renders one label per whole grapheme, in order, that together spell the input")
	@Test
	public labelPerGrapheme(text: string, expected: string) {
		const clusters = expected.split(SEPARATOR);

		withMounted(400, 200, <Text text={text} letterSpacing={SPACING} />, (mounted) => {
			const frame = waitForRoot(mounted.host);
			settleFrames(2);

			Assert.true(frame.IsA("Frame"), `Expected a Frame root for splittable text, got ${frame.ClassName}`);
			letterSpacingLayout(frame);

			const labels = characterLabels(frame);
			const texts = labels.map((label) => label.Text);

			Assert.equal(texts.join(SEPARATOR), expected, "Expected each label to hold exactly one whole grapheme");
			Assert.equal(labels.size(), clusters.size(), "Expected one TextLabel per grapheme");
			Assert.equal(texts.join(""), text, "Expected the labels in LayoutOrder to concatenate back to the input");
			Assert.equal(frame.GetChildren().size(), clusters.size() + 1, "Expected only the list layout plus the character labels");
			for (let index = 0; index < labels.size(); index++) {
				Assert.equal(labels[index].Name, `${index}`, "Expected each label to be named by its zero-based index");
				Assert.equal(labels[index].LayoutOrder, index, `Unexpected LayoutOrder on label ${index}`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced ASCII keeps one single-character label per byte, named and ordered by index, under the LetterSpacing layout")
	@Test
	public asciiStructureUnchanged() {
		withMounted(400, 200, <Text text={ASCII_TEXT} letterSpacing={SPACING} />, (mounted) => {
			const frame = waitForGuiObject<GuiObject>(mounted.host, "Text");
			settleFrames(2);

			Assert.true(frame.IsA("Frame"), `Expected a Frame root, got ${frame.ClassName}`);

			const layout = letterSpacingLayout(frame);
			Assert.equal(layout.Padding.Offset, SPACING, "Expected the list padding to be the letterSpacing");
			Assert.equal(layout.Padding.Scale, 0, "Expected a pixel-only list padding");
			Assert.equal(layout.FillDirection, Enum.FillDirection.Horizontal);
			Assert.equal(layout.SortOrder, Enum.SortOrder.LayoutOrder);

			const labels = characterLabels(frame);
			Assert.equal(labels.size(), ASCII_TEXT.size(), "Expected one TextLabel per byte");
			Assert.equal(frame.GetChildren().size(), ASCII_TEXT.size() + 1, "Expected only the list layout plus the character labels");
			for (let index = 0; index < labels.size(); index++) {
				const label = labels[index];
				Assert.equal(label.Name, `${index}`, "Expected each label to be named by its zero-based index");
				Assert.equal(label.LayoutOrder, index, `Unexpected LayoutOrder on label ${index}`);
				Assert.equal(label.Text, ASCII_TEXT.sub(index + 1, index + 1), `Unexpected character on label ${index}`);
				Assert.equal(label.Text.size(), 1, `Expected label ${index} to hold a single character`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Consecutive ASCII character labels sit left to right exactly the letterSpacing apart")
	@Test
	public asciiGapMatchesSpacing() {
		withMounted(400, 200, <Text text={ASCII_TEXT} letterSpacing={SPACING} />, (mounted) => {
			const frame = waitForGuiObject<Frame>(mounted.host, "Text");

			const labels = waitForLayout(() => {
				const found = characterLabels(frame);
				return found.size() === ASCII_TEXT.size() && found.every((label) => label.AbsoluteSize.X > 0) ? found : undefined;
			}, "Timed out waiting for every character label to be laid out");

			for (let index = 1; index < labels.size(); index++) {
				const gap = rect(labels[index]).left - rect(labels[index - 1]).right;
				Assert.true(
					math.abs(gap - SPACING) <= 0.5,
					`Expected a ${SPACING}px gap between labels ${index - 1} and ${index}, got ${gap}`,
				);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[ARABIC], [HEBREW], [DEVANAGARI], [`Hello ${ARABIC}`], ["abc\u{200F}def"]])
	@DisplayName("Letter-spaced Arabic, Hebrew, Devanagari or bidi-controlled text falls back to one root TextLabel holding the whole string")
	@Test
	public complexScriptStaysWhole(text: string) {
		withMounted(400, 200, <Text text={text} letterSpacing={SPACING} />, (mounted) => {
			const root = waitForRoot(mounted.host);
			settleFrames(2);

			Assert.true(root.IsA("TextLabel"), `Expected a single TextLabel root for complex-script text, got ${root.ClassName}`);
			Assert.equal((root as TextLabel).Text, text, "Expected the root label to hold the whole string");
			Assert.undefined(root.FindFirstChild("LetterSpacing"), "Expected no LetterSpacing layout on the fallback label");
			Assert.equal(characterLabels(root).size(), 0, "Expected no per-character labels");
			Assert.equal(
				mounted.host.GetDescendants().filter((descendant) => descendant.IsA("TextLabel")).size(),
				1,
				"Expected exactly one TextLabel in the whole mount",
			);
		});
	}
}

export = TextLetterSpacing;
