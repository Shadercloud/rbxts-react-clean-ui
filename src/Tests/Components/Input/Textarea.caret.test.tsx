import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import {
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 200;
const HOST_HEIGHT = 300;
const FILLER = "go";
const LAST_WORD = "wrapping";
const CARET_OFFSET = 2;
const MAX_FILLERS = 40;
const RULER_FRAMES = 3;
const BOUNDS_TOLERANCE = 0.5;
const SCROLL_TOLERANCE = 1;
const SCROLL_FRAMES = 60;

interface WrappingText {
	text: string;
	cursor: number;
	prefixBounds: number;
	fullBounds: number;
}

function textarea(value: string) {
	return <Textarea value={value} rows={1} controlled={true} />;
}

function measure(ruler: TextLabel, text: string): number {
	ruler.Text = text;
	settleFrames(RULER_FRAMES);

	return ruler.TextBounds.Y;
}

function findWrappingText(probe: TextLabel, lineHeight: number): WrappingText {
	const ruler = probe.Clone();
	ruler.Name = "Ruler";
	ruler.Parent = probe.Parent;

	try {
		let filler = FILLER;

		for (let count = 1; count <= MAX_FILLERS; count++) {
			const text = `${filler} ${LAST_WORD}`;
			const prefix = `${filler} ${LAST_WORD.sub(1, CARET_OFFSET)}`;
			const fullBounds = measure(ruler, text);

			if (fullBounds > lineHeight + BOUNDS_TOLERANCE) {
				const prefixBounds = measure(ruler, prefix);

				Assert.true(
					prefixBounds <= lineHeight + BOUNDS_TOLERANCE,
					`Fixture: expected ${prefix} to fit on one line (${prefixBounds} vs line ${lineHeight}) once ${text} wraps (${fullBounds})`,
				);

				return { text, cursor: prefix.size() + 1, prefixBounds, fullBounds };
			}

			filler = `${filler} ${FILLER}`;
		}
	} finally {
		ruler.Destroy();
	}

	return Assert.fail(`Fixture: no filler count up to ${MAX_FILLERS} made ${LAST_WORD} wrap at wrap width ${probe.Size.X.Offset}`);
}

function focus(box: TextBox) {
	box.CaptureFocus();
	waitForLayout(
		() => (box.IsFocused() ? true : undefined),
		"Timed out waiting for CaptureFocus to focus the Textarea TextBox; focus may be unavailable in this test runner",
	);
	settleFrames(2);
}

function maxScroll(frame: ScrollingFrame): number {
	return math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y);
}

function describeScroll(frame: ScrollingFrame): string {
	return `CanvasPosition.Y ${frame.CanvasPosition.Y}, canvas ${frame.AbsoluteCanvasSize.Y}, window ${frame.AbsoluteWindowSize.Y}, max ${maxScroll(frame)}`;
}

function waitForScrollY(frame: ScrollingFrame, target: () => number, message: string) {
	for (let attempt = 0; attempt < SCROLL_FRAMES; attempt++) {
		if (math.abs(frame.CanvasPosition.Y - target()) <= SCROLL_TOLERANCE) {
			return;
		}

		task.wait();
	}

	Assert.fail(`${message} (target ${target()}, ${describeScroll(frame)})`);
}

function waitForProbe(probe: TextLabel, wrapping: WrappingText) {
	for (let attempt = 0; attempt < SCROLL_FRAMES; attempt++) {
		if (probe.Text === wrapping.text && math.abs(probe.TextBounds.Y - wrapping.fullBounds) <= BOUNDS_TOLERANCE) {
			return;
		}

		task.wait();
	}

	Assert.fail(
		`Expected CaretProbe to measure the whole last word (${wrapping.fullBounds}), got ${probe.TextBounds.Y} for ${probe.Text.size()} of ${wrapping.text.size()} bytes; up to the caret alone is ${wrapping.prefixBounds}`,
	);
}

@Tag("Studio")
class TextareaCaretLineValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A caret in the wrapped part of the last word measures two lines and scrolls that line fully into view")
	@Test
	public wrappedWordCaret() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(""), (mounted) => {
			const root = waitForGuiObject<Frame>(mounted.host, "Textarea");
			const field = waitForGuiObject<ImageLabel>(root, "Field");
			const probe = findDescendant<TextLabel>(field, "CaretProbe");
			const lineProbe = findDescendant<TextLabel>(field, "LineProbe");

			waitForLayout(
				() => (probe.Size.X.Offset > 0 && lineProbe.TextBounds.Y > 0 ? true : undefined),
				`Timed out waiting for the probes to get a wrap width and a line height (width ${probe.Size.X.Offset}, line ${lineProbe.TextBounds.Y})`,
			);

			const lineHeight = lineProbe.TextBounds.Y;
			const wrapping = findWrappingText(probe, lineHeight);

			mounted.update(textarea(wrapping.text));

			const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
			Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);
			waitForLayout(
				() => (frame!.AbsoluteWindowSize.Y > 0 && frame!.AbsoluteCanvasSize.Y > frame!.AbsoluteWindowSize.Y ? true : undefined),
				`Timed out waiting for the two-line text to overflow the one-row field (${describeScroll(frame!)})`,
			);
			settleFrames(3);

			const box = findDescendant<TextBox>(frame!, "TextBox");

			focus(box);
			box.CursorPosition = 1;
			waitForScrollY(frame!, () => 0, "Expected the caret at the start to keep the view at the top");

			box.CursorPosition = wrapping.cursor;
			waitForProbe(probe, wrapping);

			Assert.true(
				probe.TextBounds.Y > lineHeight + BOUNDS_TOLERANCE,
				`Expected the caret line bottom to span more than one line (${probe.TextBounds.Y} vs line ${lineHeight})`,
			);

			waitForScrollY(frame!, () => maxScroll(frame!), "Expected caret follow to scroll the wrapped line fully into view");
			Assert.true(maxScroll(frame!) > 0, `Expected a positive maximum scroll (${describeScroll(frame!)})`);
			Assert.true(
				frame!.CanvasPosition.Y + frame!.AbsoluteWindowSize.Y >= frame!.AbsoluteCanvasSize.Y - SCROLL_TOLERANCE,
				`Expected the bottom of the canvas, the wrapped line and its padding, to be in view (${describeScroll(frame!)})`,
			);

			box.ReleaseFocus();
		});
	}
}

export = TextareaCaretLineValidation;
