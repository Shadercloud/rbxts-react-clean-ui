import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Each } = Decorators;
import {
	TEXTAREA_DEFAULT_ROWS,
	formatTextareaCount,
	resolveTextareaCanvasHeight,
	resolveTextareaCaretScroll,
	resolveTextareaCaretText,
	resolveTextareaHeight,
	resolveTextareaLength,
	resolveTextareaScreenScale,
	resolveTextareaWrapWidth,
	trimTextareaText,
} from "../../../Components/Input/Textarea.layout";

const LINE_HEIGHT = 18;
const PADDING_TOP = 8;
const PADDING_BOTTOM = 6;
const E_ACUTE = "\u{E9}";
const GRINNING = "\u{1F600}";

@Tag("Lune")
class TextareaLayoutValidation {
	@DisplayName("Without a height, the field is rows times the line height plus top and bottom padding")
	@Each([[1], [2], [4], [10]])
	@Test
	public rowsHeight(rows: number) {
		Assert.equal(
			resolveTextareaHeight(undefined, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM),
			rows * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM,
		);
	}

	@DisplayName("An explicit pixel height wins over rows, line height and padding")
	@Test
	public heightBeatsRows() {
		Assert.equal(resolveTextareaHeight(160, 10, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), 160);
	}

	@DisplayName("A negative explicit height is clamped to zero")
	@Test
	public negativeHeight() {
		Assert.equal(resolveTextareaHeight(-20, 4, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), 0);
	}

	@DisplayName("Fractional rows are floored before multiplying by the line height")
	@Each([[2.9, 2], [1.01, 1], [4.5, 4]])
	@Test
	public rowsFloored(rows: number, expectedRows: number) {
		Assert.equal(
			resolveTextareaHeight(undefined, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM),
			expectedRows * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM,
		);
	}

	@DisplayName("Zero, negative, sub-one and NaN rows still give one visible line")
	@Each([[0], [-3], [0.5], [0 / 0]])
	@Test
	public atLeastOneRow(rows: number) {
		Assert.equal(
			resolveTextareaHeight(undefined, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM),
			LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM,
		);
	}

	@DisplayName("The exported default row count is four")
	@Test
	public defaultRows() {
		Assert.equal(TEXTAREA_DEFAULT_ROWS, 4);
	}

	@DisplayName("Text taller than the viewport gives a canvas of N line heights plus top and bottom padding")
	@Each([[10], [40], [100]])
	@Test
	public canvasForLines(lines: number) {
		Assert.equal(
			resolveTextareaCanvasHeight(lines * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160),
			lines * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM,
		);
	}

	@DisplayName("Text shorter than the viewport gives a canvas exactly as tall as the viewport")
	@Each([[0], [1], [4]])
	@Test
	public canvasFloor(lines: number) {
		Assert.equal(resolveTextareaCanvasHeight(lines * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160), 160);
	}

	@DisplayName("Screen scale is the laid-out height divided by the design height")
	@Each([[120, 160, 0.75], [160, 160, 1], [240, 160, 1.5], [50, 200, 0.25]])
	@Test
	public screenScaleRatio(screen: number, design: number, expected: number) {
		Assert.equal(resolveTextareaScreenScale(screen, design, 2), expected);
	}

	@DisplayName("Before layout, a zero, negative or NaN height on either side falls back to the context scale")
	@Each([[0, 160], [120, 0], [0, 0], [-120, 160], [120, -160], [0 / 0, 160], [120, 0 / 0]])
	@Test
	public screenScaleFallback(screen: number, design: number) {
		Assert.equal(resolveTextareaScreenScale(screen, design, 1.25), 1.25);
	}

	@DisplayName("A zero, negative or NaN fallback scale resolves to one so nothing divides by zero")
	@Each([[0], [-2], [0 / 0]])
	@Test
	public screenScaleBadFallback(fallback: number) {
		Assert.equal(resolveTextareaScreenScale(0, 160, fallback), 1);
	}

	@DisplayName("With no viewport height the canvas is just the text height plus padding")
	@Test
	public canvasNoViewport() {
		Assert.equal(resolveTextareaCanvasHeight(36, PADDING_TOP, PADDING_BOTTOM), 36 + PADDING_TOP + PADDING_BOTTOM);
	}

	@DisplayName("A NaN, infinite or negative text height counts as zero and the viewport floor still applies")
	@Each([[0 / 0], [math.huge], [-math.huge], [-50]])
	@Test
	public canvasBadText(textHeight: number) {
		Assert.equal(resolveTextareaCanvasHeight(textHeight, PADDING_TOP, PADDING_BOTTOM, 160), 160);
		Assert.equal(resolveTextareaCanvasHeight(textHeight, PADDING_TOP, PADDING_BOTTOM), PADDING_TOP + PADDING_BOTTOM);
	}

	@DisplayName("Wrap width is the field width minus left padding, right padding and gutter")
	@Each([[300, 8, 8, 12, 272], [400, 12, 4, 16, 368], [200, 0, 0, 0, 200]])
	@Test
	public wrapWidth(field: number, left: number, right: number, gutter: number, expected: number) {
		Assert.equal(resolveTextareaWrapWidth(field, left, right, gutter), expected);
	}

	@DisplayName("Wrap width stays identical whether the canvas fits the viewport or overflows it")
	@Test
	public wrapIgnoresOverflow() {
		const fitting = resolveTextareaCanvasHeight(LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160);
		const before = resolveTextareaWrapWidth(300, 8, 8, 12);
		const overflowing = resolveTextareaCanvasHeight(40 * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160);
		const after = resolveTextareaWrapWidth(300, 8, 8, 12);

		Assert.equal(fitting, 160, "Expected the short text to fit the viewport");
		Assert.true(overflowing > 160, `Expected the long text canvas ${overflowing} to overflow the 160px viewport`);
		Assert.equal(after, before, "Expected the wrap width not to change once the content overflows");
		Assert.equal(after, 300 - 8 - 8 - 12);
	}

	@DisplayName("A negative gutter is treated as zero")
	@Test
	public negativeGutter() {
		Assert.equal(resolveTextareaWrapWidth(300, 8, 8, -5), 284);
	}

	@DisplayName("A field narrower than its padding and gutter gives a zero wrap width")
	@Test
	public wrapNotNegative() {
		Assert.equal(resolveTextareaWrapWidth(10, 8, 8, 12), 0);
	}

	@DisplayName("A caret below the view scrolls down until its bottom sits on the viewport bottom")
	@Test
	public scrollsDown() {
		Assert.equal(resolveTextareaCaretScroll(150, 170, 0, 100), 70);
	}

	@DisplayName("A caret partly below the view scrolls down just enough to show its bottom")
	@Test
	public scrollsDownPartial() {
		Assert.equal(resolveTextareaCaretScroll(90, 110, 0, 100), 10);
	}

	@DisplayName("A caret above the view scrolls up until its top sits on the viewport top")
	@Test
	public scrollsUp() {
		Assert.equal(resolveTextareaCaretScroll(50, 70, 200, 100), 50);
	}

	@DisplayName("A caret above the top of the canvas never scrolls to a negative position")
	@Test
	public scrollsUpClamped() {
		Assert.equal(resolveTextareaCaretScroll(-5, 15, 10, 100), 0);
	}

	@DisplayName("A caret already inside the view leaves the scroll position unchanged")
	@Each([[20, 40, 0], [120, 140, 100], [100, 200, 100]])
	@Test
	public visibleUnchanged(top: number, bottom: number, canvasY: number) {
		Assert.equal(resolveTextareaCaretScroll(top, bottom, canvasY, 100), canvasY);
	}

	@DisplayName("A line taller than the viewport aligns to its top rather than its bottom")
	@Test
	public tallLineTop() {
		Assert.equal(resolveTextareaCaretScroll(300, 450, 0, 100), 300);
	}

	@DisplayName("A cursor position below one gives no caret text")
	@Each([[0], [-1]])
	@Test
	public caretUndefined(cursor: number) {
		Assert.undefined(resolveTextareaCaretText("hello", cursor));
	}

	@DisplayName("The caret text is the bytes before the cursor position")
	@Test
	public caretPrefix() {
		Assert.equal(resolveTextareaCaretText("hello world", 6), "hello");
	}

	@DisplayName("A caret at the very start measures a single space so there is still a line")
	@Test
	public caretAtStart() {
		Assert.equal(resolveTextareaCaretText("hello", 1), " ");
	}

	@DisplayName("A caret right after a newline gets a trailing space so the new line is measured")
	@Test
	public caretAfterNewline() {
		Assert.equal(resolveTextareaCaretText("one\ntwo\n", 9), "one\ntwo\n ");
	}

	@DisplayName("Byte slicing keeps a multibyte character whole when the cursor sits after it")
	@Test
	public caretMultibyte() {
		const text = `h${E_ACUTE}llo`;

		Assert.equal(resolveTextareaCaretText(text, 4), `h${E_ACUTE}`);
		Assert.equal(resolveTextareaCaretText(`${GRINNING}a`, 5), GRINNING);
	}

	@DisplayName("A cursor past the end of the text gives the whole text")
	@Test
	public caretPastEnd() {
		Assert.equal(resolveTextareaCaretText("ab", 10), "ab");
	}

	@DisplayName("Length counts code points, not bytes, for accented and emoji text")
	@Each([["hello", 5], [`h${E_ACUTE}llo`, 5], [`${GRINNING}${GRINNING}`, 2], ["", 0]])
	@Test
	public lengthCodePoints(text: string, expected: number) {
		Assert.equal(resolveTextareaLength(text), expected);
	}

	@DisplayName("Invalid UTF-8 falls back to the byte count")
	@Test
	public lengthInvalid() {
		Assert.equal(resolveTextareaLength(`a${string.char(0xff)}b`), 3);
	}

	@DisplayName("Without a maxLength the text is returned untouched")
	@Test
	public trimNoLimit() {
		Assert.equal(trimTextareaText("hello world"), "hello world");
	}

	@DisplayName("Text within the limit is returned untouched")
	@Each([[5], [6], [100]])
	@Test
	public trimWithin(limit: number) {
		Assert.equal(trimTextareaText(`h${E_ACUTE}llo`, limit), `h${E_ACUTE}llo`);
	}

	@DisplayName("Text over the limit is cut to the first maxLength code points")
	@Test
	public trimCuts() {
		Assert.equal(trimTextareaText("hello world", 5), "hello");
	}

	@DisplayName("Cutting multibyte text lands on a code-point boundary and never splits a character")
	@Test
	public trimMultibyte() {
		Assert.equal(trimTextareaText(`h${E_ACUTE}llo`, 2), `h${E_ACUTE}`);
		Assert.equal(trimTextareaText(`${GRINNING}${GRINNING}${GRINNING}`, 2), `${GRINNING}${GRINNING}`);
	}

	@DisplayName("A zero limit gives empty text and a fractional limit is floored")
	@Test
	public trimLimitEdges() {
		Assert.equal(trimTextareaText("hello", 0), "");
		Assert.equal(trimTextareaText("hello", 2.7), "he");
	}

	@DisplayName("Without a maxLength the counter is the length grouped with commas")
	@Each([[0, "0"], [77, "77"], [999, "999"], [1000, "1,000"], [1234567, "1,234,567"]])
	@Test
	public countPlain(length: number, expected: string) {
		Assert.equal(formatTextareaCount(length), expected);
	}

	@DisplayName("With a maxLength the counter shows length slash limit, both grouped")
	@Each([[77, 1500, "77 / 1,500"], [1500, 1500, "1,500 / 1,500"], [0, 100, "0 / 100"]])
	@Test
	public countWithLimit(length: number, limit: number, expected: string) {
		Assert.equal(formatTextareaCount(length, limit), expected);
	}
}

export = TextareaLayoutValidation;
