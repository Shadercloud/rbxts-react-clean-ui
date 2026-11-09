import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, TypographyOutline, extendTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, withMounted } from "../../Helpers/layout";

const SPACED_TEXT = "Hey";
const THEME_COLOR = new Color3(0.25, 0.5, 0.75);
const PROP_COLOR = new Color3(0.75, 0.25, 0.5);
const BLACK = new Color3(0, 0, 0);

function themed(outline: TypographyOutline, element: React.ReactElement) {
	const theme = extendTheme(DefaultTheme, { typography: { body: { outline } } });
	return <ThemeProvider theme={theme}>{element}</ThemeProvider>;
}

function strokesOf(instance: Instance): UIStroke[] {
	const found: UIStroke[] = [];
	for (const child of instance.GetChildren()) {
		if (child.IsA("UIStroke")) found.push(child);
	}
	return found;
}

function soleOutline(instance: Instance): UIStroke {
	const found = strokesOf(instance);
	Assert.equal(found.size(), 1, `Expected exactly one UIStroke directly on ${instance.GetFullName()}`);
	Assert.equal(found[0].Name, "Outline", `Expected the UIStroke on ${instance.Name} to be named Outline`);
	Assert.equal(found[0].ApplyStrokeMode, Enum.ApplyStrokeMode.Contextual, "Expected a Contextual stroke so it outlines the glyphs");
	return found[0];
}

function assertOutline(stroke: UIStroke, color: Color3, thickness: number, transparency: number) {
	Assert.true(stroke.Color === color, `Expected outline colour ${color}, got ${stroke.Color}`);
	Assert.equal(stroke.Thickness, thickness, "Unexpected outline thickness");
	Assert.equal(stroke.Transparency, transparency, "Unexpected outline transparency");
}

function characterLabels(frame: Instance): TextLabel[] {
	const found: TextLabel[] = [];
	for (const child of frame.GetChildren()) {
		if (child.IsA("TextLabel")) found.push(child);
	}
	return found;
}

function waitForLabel(host: Instance): TextLabel {
	return waitForGuiObject<TextLabel>(host, "Text");
}

@Tag("Studio")
class TextOutline {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A plain label with none of the new props has no child instances at all")
	@Test
	public plainHasNoChildren() {
		withMounted(400, 200, <Text text="Hello" />, (mounted) => {
			const label = waitForLabel(mounted.host);
			settleFrames(2);

			Assert.equal(label.GetChildren().size(), 0, "Expected no UIStroke, UIScale or constraints on a plain label");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A letter-spaced text with none of the new props holds only its list layout and bare character labels")
	@Test
	public spacedHasNoDecorations() {
		withMounted(400, 200, <Text text={SPACED_TEXT} letterSpacing={2} />, (mounted) => {
			const frame = waitForGuiObject<Frame>(mounted.host, "Text");
			settleFrames(2);

			const labels = characterLabels(frame);
			Assert.equal(frame.GetChildren().size(), SPACED_TEXT.size() + 1, "Expected one UIListLayout plus one label per character");
			Assert.equal(labels.size(), SPACED_TEXT.size(), "Expected one TextLabel per character");
			for (const label of labels) {
				Assert.equal(label.GetChildren().size(), 0, `Expected character label ${label.Name} to have no children`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("outline={true} with no theme outline draws a black 1px opaque stroke")
	@Test
	public trueUsesDefaults() {
		withMounted(400, 200, <Text text="Hello" outline={true} />, (mounted) => {
			assertOutline(soleOutline(waitForLabel(mounted.host)), BLACK, 1, 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An outline object sets the stroke colour, thickness and transparency")
	@Test
	public objectSetsFields() {
		withMounted(
			400,
			200,
			<Text text="Hello" outline={{ color: PROP_COLOR, thickness: 3, transparency: 0.5 }} />,
			(mounted) => {
				assertOutline(soleOutline(waitForLabel(mounted.host)), PROP_COLOR, 3, 0.5);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A partial outline object falls back to the defaults for the fields it leaves out")
	@Test
	public partialObjectDefaults() {
		withMounted(400, 200, <Text text="Hello" outline={{ thickness: 2 }} />, (mounted) => {
			assertOutline(soleOutline(waitForLabel(mounted.host)), BLACK, 2, 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With outline unset, a theme typography.body.outline still draws the stroke")
	@Test
	public themeOutlineApplies() {
		withMounted(
			400,
			200,
			themed({ color: THEME_COLOR, thickness: 2, transparency: 0.25 }, <Text text="Hello" />),
			(mounted) => {
				assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 2, 0.25);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("outline={true} under a theme outline uses the theme's fields")
	@Test
	public trueUsesTheme() {
		withMounted(
			400,
			200,
			themed({ color: THEME_COLOR, thickness: 2, transparency: 0.25 }, <Text text="Hello" outline={true} />),
			(mounted) => {
				assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 2, 0.25);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An outline object overrides a theme outline field by field and keeps the theme's other fields")
	@Test
	public objectMergesTheme() {
		withMounted(
			400,
			200,
			themed({ color: THEME_COLOR, thickness: 2, transparency: 0.25 }, <Text text="Hello" outline={{ thickness: 4 }} />),
			(mounted) => {
				assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 4, 0.25);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("outline={false} draws no stroke even when the theme style has one")
	@Test
	public falseBeatsTheme() {
		withMounted(
			400,
			200,
			themed({ color: THEME_COLOR, thickness: 2 }, <Text text="Hello" outline={false} />),
			(mounted) => {
				const label = waitForLabel(mounted.host);
				settleFrames(2);

				Assert.equal(strokesOf(label).size(), 0, "Expected outline={false} to suppress the theme outline");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Letter-spaced text draws one Outline stroke on every character label and none on the frame")
	@Test
	public spacedStrokePerCharacter() {
		withMounted(
			400,
			200,
			<Text text={SPACED_TEXT} letterSpacing={2} outline={{ color: PROP_COLOR, thickness: 2 }} />,
			(mounted) => {
				const frame = waitForGuiObject<Frame>(mounted.host, "Text");
				const labels = characterLabels(frame);

				Assert.equal(labels.size(), SPACED_TEXT.size(), "Expected one TextLabel per character");
				Assert.equal(strokesOf(frame).size(), 0, "Expected no UIStroke on the letter-spaced frame itself");
				for (const label of labels) {
					assertOutline(soleOutline(label), PROP_COLOR, 2, 0);
				}
			},
		);
	}
}

export = TextOutline;
