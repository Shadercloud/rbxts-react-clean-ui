import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import {
	STUDIO_SKIP_MESSAGE,
	describeGui,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 600;
const HOST_HEIGHT = 700;
const DESIGN_WIDTH = 300;
const DESIGN_HEIGHT = 400;
const FIELD_HEIGHT = 160;
const SIZE_TOLERANCE = 0.5;
const SCROLL_TOLERANCE = 1;
const SCROLL_FRAMES = 60;
const USER_SCROLL_FRAMES = 15;

function longText(lines: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= lines; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

const LONG_TEXT = longText(40);

function scaledTextarea(scale: number) {
	return (
		<frame key="Scaled" Size={UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)} BackgroundTransparency={1}>
			<uiscale key="TestScale" Scale={scale} />
			<Textarea value={LONG_TEXT} height={FIELD_HEIGHT} />
		</frame>
	);
}

interface Mounted {
	root: Frame;
	field: ImageLabel;
	frame: ScrollingFrame;
	box: TextBox;
}

function waitForScaled(host: Instance, scale: number): Mounted {
	const expected = FIELD_HEIGHT * scale;
	const root = waitForGuiObject<Frame>(host, "Textarea");
	const field = waitForGuiObject<ImageLabel>(
		root,
		"Field",
		(gui) => math.abs(gui.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE,
		`Timed out waiting for the Textarea Field to be ${expected}px tall at scale ${scale}`,
	);
	const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
	Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);

	waitForLayout(
		() => (frame!.AbsoluteWindowSize.Y > 0 && frame!.AbsoluteCanvasSize.Y > frame!.AbsoluteWindowSize.Y ? true : undefined),
		`Timed out waiting for the canvas to overflow at scale ${scale} (canvas ${frame!.AbsoluteCanvasSize.Y}, window ${frame!.AbsoluteWindowSize.Y})`,
	);
	settleFrames(3);

	return { root, field, frame: frame!, box: findDescendant<TextBox>(frame!, "TextBox") };
}

function maxScroll(frame: ScrollingFrame): number {
	return math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y);
}

function describeScroll(frame: ScrollingFrame): string {
	return `CanvasPosition.Y ${frame.CanvasPosition.Y}, canvas ${frame.AbsoluteCanvasSize.Y}, window ${frame.AbsoluteWindowSize.Y}, max ${maxScroll(frame)}`;
}

function focus(box: TextBox) {
	box.CaptureFocus();
	waitForLayout(
		() => (box.IsFocused() ? true : undefined),
		"Timed out waiting for CaptureFocus to focus the Textarea TextBox; focus may be unavailable in this test runner",
	);
	settleFrames(2);
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

function moveCaretToEnd(mounted: Mounted, scale: number) {
	mounted.box.CursorPosition = mounted.box.Text.size() + 1;
	waitForScrollY(mounted.frame, () => maxScroll(mounted.frame), `Scale ${scale}: expected the caret at the end to scroll to the bottom`);
}

function moveCaretToStart(mounted: Mounted, scale: number) {
	mounted.box.CursorPosition = 1;
	waitForScrollY(mounted.frame, () => 0, `Scale ${scale}: expected the caret at the start to scroll back to the top`);
}

@Tag("Studio")
class TextareaScaleValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Under a plain UIScale the 160px field lays out at 160 times the scale and the canvas still overflows")
	@Each([[0.75], [1], [1.5]])
	@Test
	public scaledField(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), (host) => {
			const mounted = waitForScaled(host.host, scale);
			const expected = FIELD_HEIGHT * scale;

			Assert.true(
				math.abs(mounted.field.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE,
				`Scale ${scale}: expected ${describeGui(mounted.field)} to be ${expected}px tall, got ${mounted.field.AbsoluteSize.Y}`,
			);
			Assert.true(
				mounted.frame.AbsoluteCanvasSize.Y > mounted.frame.AbsoluteWindowSize.Y,
				`Scale ${scale}: expected the canvas (${mounted.frame.AbsoluteCanvasSize.Y}) to exceed the window (${mounted.frame.AbsoluteWindowSize.Y})`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With focus, a caret at the end scrolls to the maximum and a caret at position 1 scrolls back to 0")
	@Each([[0.75], [1], [1.5]])
	@Test
	public caretFollowsScaled(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), (host) => {
			const mounted = waitForScaled(host.host, scale);

			focus(mounted.box);
			moveCaretToEnd(mounted, scale);

			Assert.true(maxScroll(mounted.frame) > 0, `Scale ${scale}: expected a positive maximum scroll (${describeScroll(mounted.frame)})`);

			moveCaretToStart(mounted, scale);
			mounted.box.ReleaseFocus();
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A mid-canvas scroll made while focused is not pulled back to the caret over the following frames")
	@Each([[0.75], [1], [1.5]])
	@Test
	public userScrollStays(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), (host) => {
			const mounted = waitForScaled(host.host, scale);
			const frame = mounted.frame;

			focus(mounted.box);
			moveCaretToEnd(mounted, scale);
			moveCaretToStart(mounted, scale);
			settleFrames(3);

			const userY = math.floor(maxScroll(frame) / 2);
			Assert.true(userY > 0, `Scale ${scale}: expected room to scroll (${describeScroll(frame)})`);

			frame.CanvasPosition = new Vector2(frame.CanvasPosition.X, userY);
			settleFrames(USER_SCROLL_FRAMES);

			Assert.true(mounted.box.IsFocused(), `Scale ${scale}: expected the TextBox to still be focused`);
			Assert.true(
				math.abs(frame.CanvasPosition.Y - userY) <= SCROLL_TOLERANCE,
				`Scale ${scale}: expected the user scroll to stay at ${userY} (${describeScroll(frame)})`,
			);
			mounted.box.ReleaseFocus();
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The 100000px measuring labels in the hidden Measure frame never stretch the root past the field")
	@Each([[0.75], [1], [1.5]])
	@Test
	public measureOutOfLayout(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), (host) => {
			const mounted = waitForScaled(host.host, scale);
			const measure = findDescendant<Frame>(mounted.field, "Measure");
			const textMeasure = findDescendant<TextLabel>(measure, "TextMeasure");

			Assert.false(measure.Visible, "Expected the Measure frame to be hidden");
			Assert.true(
				textMeasure.TextBounds.Y > mounted.field.AbsoluteSize.Y,
				`Scale ${scale}: expected TextMeasure to measure the full text (${textMeasure.TextBounds.Y}) past the field (${mounted.field.AbsoluteSize.Y})`,
			);
			Assert.true(
				math.abs(mounted.root.AbsoluteSize.Y - mounted.field.AbsoluteSize.Y) <= SIZE_TOLERANCE,
				`Scale ${scale}: expected ${describeGui(mounted.root)} to stay at the field height ${mounted.field.AbsoluteSize.Y}, got ${mounted.root.AbsoluteSize.Y}`,
			);
		});
	}
}

export = TextareaScaleValidation;
