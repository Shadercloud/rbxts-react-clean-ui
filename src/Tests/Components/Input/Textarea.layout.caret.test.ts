import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Each } = Decorators;
import { resolveTextareaCaretLineText } from "../../../Components/Input/Textarea.layout";

const E_ACUTE = "\u{E9}";
const O_UMLAUT = "\u{F6}";

@Tag("Lune")
class TextareaCaretLineText {
	@DisplayName("A caret inside a word measures through the end of that word")
	@Each([["aa bbbb cc", 6, "aa bbbb"], ["aa bbbb", 4, "aa bbbb"], ["aa bbbb", 3, "aa"]])
	@Test
	public restOfWord(text: string, cursor: number, expected: string) {
		Assert.equal(resolveTextareaCaretLineText(text, cursor), expected);
	}

	@DisplayName("A caret at the start of a line adds nothing after the placeholder space")
	@Test
	public lineStart() {
		Assert.equal(resolveTextareaCaretLineText("x\nword", 3), "x\n ");
	}

	@DisplayName("Empty text with the caret at position one measures a single space")
	@Test
	public emptyText() {
		Assert.equal(resolveTextareaCaretLineText("", 1), " ");
	}

	@DisplayName("A cursor position below one gives no caret line text")
	@Each([[0], [-1]])
	@Test
	public belowOne(cursor: number) {
		Assert.undefined(resolveTextareaCaretLineText("aa bbbb", cursor));
	}

	@DisplayName("A caret inside a multibyte word returns the whole word with its accented bytes intact")
	@Each([[9], [11], [13]])
	@Test
	public multibyteWord(cursor: number) {
		Assert.equal(resolveTextareaCaretLineText(`h${E_ACUTE}llo w${O_UMLAUT}rld`, cursor), `h${E_ACUTE}llo w${O_UMLAUT}rld`);
	}
}

export = TextareaCaretLineText;
