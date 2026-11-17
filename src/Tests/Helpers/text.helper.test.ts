import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";
import { TextHelper } from "../../Helpers/text.helper";

const { Each } = Decorators;

const HEBREW = "\u{5E9}\u{5DC}\u{5D5}\u{5DD}";
const ARABIC = "\u{645}\u{631}\u{62D}\u{628}\u{627}";
const DEVANAGARI = "\u{928}\u{92E}\u{938}\u{94D}\u{924}\u{947}";
const THAI = "\u{E2A}\u{E27}\u{E31}\u{E2A}\u{E14}\u{E35}";
const GRINNING_FACE = "\u{1F600}";
const FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}";
const LONE_CONTINUATION = string.char(0x80);
const TRUNCATED_LEAD = string.char(0xc3);
const INVALID_BYTE = string.char(0xff);

@Tag("Lune")
class TextHelperValidation {
	@Each([["Hello World"], ["ABC xyz 123 !@#"], ["already lower"], ["MiXeD\tCaSe\r\n"], [""]])
	@DisplayName("Pure ASCII text lowercases byte for byte the same as string.lower")
	@Test
	public asciiMatchesLower(text: string) {
		Assert.equal(TextHelper.lowercase(text), text.lower());
	}

	@Each([
		["ÀÉÎÕÜ", "àéîõü"],
		["École", "école"],
		["ÉCOLE Été", "école été"],
		["Año ÜBER", "año über"],
		["ÞÐÆØ", "þðæø"],
		["ĀĘŁŃŠŽĲ", "āęłńšžĳ"],
		["Ÿ", "ÿ"],
	])
	@DisplayName("Latin-1 and Latin Extended-A capitals fold to their lowercase pair along with any ASCII capitals beside them")
	@Test
	public foldsAccentedLatin(text: string, expected: string) {
		Assert.equal(TextHelper.lowercase(text), expected);
	}

	@Each([
		["ΑΒΓΔΩ", "αβγδω"],
		["ΣΟΦΙΑ", "σοφια"],
		["ΆΈΉΊΌΎΏ", "άέήίόύώ"],
		["ΪΫ", "ϊϋ"],
	])
	@DisplayName("Greek capitals, including the accented ones, fold to lowercase")
	@Test
	public foldsGreek(text: string, expected: string) {
		Assert.equal(TextHelper.lowercase(text), expected);
	}

	@Each([
		["ПРИВЕТ", "привет"],
		["Москва", "москва"],
		["ЁЖЇЄ", "ёжїє"],
		["АЯ", "ая"],
	])
	@DisplayName("Cyrillic capitals U+0400 to U+042F fold to lowercase")
	@Test
	public foldsCyrillic(text: string, expected: string) {
		Assert.equal(TextHelper.lowercase(text), expected);
	}

	@Each([["×"], ["İ"], ["ß"], ["ı"], ["àéîõü"], ["привет"], ["日本語"], ["ԱԲԳ"], [GRINNING_FACE]])
	@DisplayName("The multiplication sign, dotted capital I, sharp s, lowercase text and other scripts come back unchanged")
	@Test
	public leavesExceptions(text: string) {
		Assert.equal(TextHelper.lowercase(text), text);
	}

	@DisplayName("Invalid UTF-8 lowercases only its ASCII letters and keeps the invalid bytes, like string.lower")
	@Test
	public invalidLowersAscii() {
		const text = `AB${INVALID_BYTE}C`;

		Assert.equal(TextHelper.lowercase(text), `ab${INVALID_BYTE}c`);
		Assert.equal(TextHelper.lowercase(text), text.lower());
	}

	@Each([
		[HEBREW],
		[ARABIC],
		[DEVANAGARI],
		[`Hello ${HEBREW}`],
		["abc\u{200F}def"],
		["\u{202E}abc"],
		["\u{2066}abc\u{2069}"],
	])
	@DisplayName("Hebrew, Arabic, Devanagari and bidi control characters anywhere in the text make it complex script")
	@Test
	public complexScripts(text: string) {
		Assert.true(TextHelper.isComplexScript(text), `Expected "${text}" to be complex script`);
	}

	@Each([
		["Hello"],
		[""],
		["Año Über"],
		["Привет"],
		["日本語"],
		["한국어"],
		[THAI],
		[GRINNING_FACE],
		[FAMILY],
		["e\u{301}"],
		[`ab${INVALID_BYTE}`],
	])
	@DisplayName("ASCII, accented Latin, Cyrillic, CJK, Hangul, Thai, emoji and invalid UTF-8 are not complex script")
	@Test
	public simpleScripts(text: string) {
		Assert.false(TextHelper.isComplexScript(text), `Expected "${text}" not to be complex script`);
	}

	@Each([
		[0x058f, false],
		[0x0590, true],
		[0x0dff, true],
		[0x0e00, false],
		[0x200d, false],
		[0x200e, true],
		[0x200f, true],
		[0x2010, false],
		[0xfb1c, false],
		[0xfb1d, true],
		[0xfeff, true],
		[0xff00, false],
		[0x107ff, false],
		[0x10800, true],
		[0x1e800, true],
		[0x1f000, false],
	])
	@DisplayName("A single codepoint is complex script exactly when it falls inside one of the documented ranges")
	@Test
	public rangeBoundaries(codepoint: number, expected: boolean) {
		Assert.equal(TextHelper.isComplexScript(`a${utf8.char(codepoint)}b`), expected, `U+${string.format("%04X", codepoint)}`);
	}

	@Each([[""], ["Hello"], ["Año"], ["Привет"], ["日本語"], [HEBREW], [FAMILY]])
	@DisplayName("Well-formed text in any script is valid UTF-8")
	@Test
	public validUtf8(text: string) {
		Assert.true(TextHelper.isValidUtf8(text));
	}

	@Each([[INVALID_BYTE], [TRUNCATED_LEAD], [`a${LONE_CONTINUATION}b`], [`Hello${TRUNCATED_LEAD}`]])
	@DisplayName("A stray byte, a lone continuation byte or a truncated sequence is not valid UTF-8")
	@Test
	public invalidUtf8(text: string) {
		Assert.false(TextHelper.isValidUtf8(text));
	}

	@Each([["Hello"], ["a b"], ["x"], ["\r\n"], ["Tab\tbed"]])
	@DisplayName("Pure ASCII splits into one entry per byte, so a CR LF pair is two entries")
	@Test
	public asciiSplitsPerByte(text: string) {
		const characters = TextHelper.splitGraphemes(text);

		Assert.notUndefined(characters, "Expected ASCII text to be splittable");
		Assert.equal(characters!.size(), text.size(), "Expected one entry per byte");
		for (let index = 0; index < text.size(); index++) {
			Assert.equal(characters![index], text.sub(index + 1, index + 1), `Unexpected entry at index ${index}`);
		}
	}

	@DisplayName("An empty string splits into an empty list rather than undefined")
	@Test
	public emptySplitsEmpty() {
		const characters = TextHelper.splitGraphemes("");

		Assert.notUndefined(characters, "Expected an empty list, not undefined");
		Assert.equal(characters!.size(), 0);
	}

	@Each([[INVALID_BYTE], [`Hello${TRUNCATED_LEAD}`], [`a${LONE_CONTINUATION}b`]])
	@DisplayName("Invalid UTF-8 cannot be split and returns undefined")
	@Test
	public invalidNotSplit(text: string) {
		Assert.undefined(TextHelper.splitGraphemes(text));
	}

	@Each([[HEBREW], [ARABIC], [DEVANAGARI], [`Hello ${ARABIC}`], ["abc\u{200F}def"]])
	@DisplayName("Complex-script text is left whole and returns undefined so the caller renders it as one run")
	@Test
	public complexNotSplit(text: string) {
		Assert.undefined(TextHelper.splitGraphemes(text));
	}
}

export = TextHelperValidation;
