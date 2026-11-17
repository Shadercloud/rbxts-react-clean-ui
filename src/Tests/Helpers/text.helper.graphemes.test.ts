import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";
import { TextHelper } from "../../Helpers/text.helper";
import { STUDIO_SKIP_MESSAGE } from "./layout";

const { Skip, Each } = Decorators;

const SEPARATOR = "|";
const THAI = "\u{E2A}\u{E27}\u{E31}\u{E2A}\u{E14}\u{E35}";
const THAI_CLUSTERS = "\u{E2A}|\u{E27}\u{E31}|\u{E2A}|\u{E14}\u{E35}";
const GRINNING_FACE = "\u{1F600}";
const FLAG = "\u{1F1EF}\u{1F1F5}";
const FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}";
const HEART = "\u{2764}\u{FE0F}";
const WAVE_TONE = "\u{1F44B}\u{1F3FD}";

@Tag("Studio")
class TextHelperGraphemes {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["Año", "A|ñ|o"],
		["Über", "Ü|b|e|r"],
		["cafe\u{301}", "c|a|f|e\u{301}"],
		["Привет", "П|р|и|в|е|т"],
		["日本語", "日|本|語"],
		["한국어", "한|국|어"],
		[THAI, THAI_CLUSTERS],
		[GRINNING_FACE, GRINNING_FACE],
		[`a${FLAG}b`, `a|${FLAG}|b`],
		[`a${FAMILY}b`, `a|${FAMILY}|b`],
		[`${HEART}${WAVE_TONE}`, `${HEART}|${WAVE_TONE}`],
	])
	@DisplayName("Non-ASCII text splits into whole grapheme clusters, keeping combining marks and multi-codepoint emoji together")
	@Test
	public splitsIntoClusters(text: string, expected: string) {
		const characters = TextHelper.splitGraphemes(text);

		Assert.notUndefined(characters, "Expected the text to be splittable");
		Assert.equal(characters!.join(SEPARATOR), expected, "Unexpected grapheme clusters");
		Assert.equal(characters!.size(), expected.split(SEPARATOR).size(), "Unexpected grapheme count");
		Assert.equal(characters!.join(""), text, "Expected the clusters to concatenate back to the input");
	}
}

export = TextHelperGraphemes;
