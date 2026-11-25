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

const HOST_WIDTH = 300;
const HOST_HEIGHT = 400;
const FIELD_HEIGHT = 160;
const RERENDERS = 5;

function longText(lines: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= lines; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

const LONG_TEXT = longText(40);

function textarea(value: string, controlled?: boolean) {
	return <Textarea value={value} height={FIELD_HEIGHT} controlled={controlled} />;
}

function waitForRoot(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "Textarea");
}

function waitForField(root: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		root,
		"Field",
		(gui) => gui.AbsoluteSize.Y === FIELD_HEIGHT,
		`Timed out waiting for the Textarea Field to be ${FIELD_HEIGHT}px tall`,
	);
}

function findScrollingFrame(root: Instance): ScrollingFrame {
	const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
	Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);
	return frame!;
}

function describeCanvas(frame: ScrollingFrame): string {
	const box = frame.FindFirstChild("TextBox", true) as TextBox | undefined;
	const boxState =
		box === undefined
			? "no TextBox"
			: `TextBox Size=${box.Size}, AbsoluteSize=${box.AbsoluteSize}, TextBounds=${box.TextBounds}`;

	return `canvas ${frame.AbsoluteCanvasSize.Y}, window ${frame.AbsoluteWindowSize.Y}, CanvasSize=${frame.CanvasSize}, AutomaticCanvasSize=${frame.AutomaticCanvasSize}, ${boxState}`;
}

function waitForOverflow(root: Instance): ScrollingFrame {
	const frame = findScrollingFrame(root);

	for (let attempt = 0; attempt < 30; attempt++) {
		if (frame.AbsoluteWindowSize.Y > 0 && frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y) {
			return frame;
		}

		task.wait();
	}

	return Assert.fail(`Timed out waiting for the canvas to overflow the window (${describeCanvas(frame)})`);
}

function waitForWindow(root: Instance): ScrollingFrame {
	const frame = findScrollingFrame(root);

	waitForLayout(
		() => (frame.AbsoluteWindowSize.Y > 0 && frame.AbsoluteCanvasSize.Y > 0 ? true : undefined),
		`Timed out waiting for the ScrollingFrame to lay out (canvas ${frame.AbsoluteCanvasSize.Y}, window ${frame.AbsoluteWindowSize.Y})`,
	);

	return frame;
}

function assertOverflowing(frame: ScrollingFrame, label: string) {
	Assert.true(
		frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y,
		`${label}: expected the canvas (${frame.AbsoluteCanvasSize.Y}) to exceed the window (${frame.AbsoluteWindowSize.Y})`,
	);
	Assert.true(frame.ScrollBarThickness > 0, `${label}: expected a visible scrollbar, ScrollBarThickness is ${frame.ScrollBarThickness}`);
}

function assertHeight(gui: GuiObject, expected: number, label: string) {
	Assert.equal(gui.AbsoluteSize.Y, expected, `${label}: expected ${describeGui(gui)} to be ${expected}px tall, got ${gui.AbsoluteSize.Y}`);
}

@Tag("Studio")
class TextareaMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Forty lines in a 160px textarea keep the field and root at 160px and show a scrollbar")
	@Test
	public fixedHeightOverflow() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), (mounted) => {
			const root = waitForRoot(mounted.host);
			const field = waitForField(root);
			const frame = waitForOverflow(root);
			settleFrames(3);

			assertHeight(field, FIELD_HEIGHT, "Field");
			assertHeight(root, FIELD_HEIGHT, "Root without showCount");
			assertOverflowing(frame, "Initial mount");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Re-rendering the same long value never toggles the scrollbar or changes the content width")
	@Test
	public noToggle() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), (mounted) => {
			const root = waitForRoot(mounted.host);
			const field = waitForField(root);
			const frame = waitForOverflow(root);
			settleFrames(3);

			const content = findDescendant<Frame>(frame, "ScrollerContent");
			const contentWidth = content.AbsoluteSize.X;
			const canvasHeight = frame.AbsoluteCanvasSize.Y;

			for (let pass = 1; pass <= RERENDERS; pass++) {
				mounted.update(textarea(LONG_TEXT));
				settleFrames(3);

				const label = `Re-render ${pass}`;
				assertOverflowing(frame, label);
				Assert.equal(content.AbsoluteSize.X, contentWidth, `${label}: expected ScrollerContent to stay ${contentWidth}px wide, got ${content.AbsoluteSize.X}`);
				Assert.equal(frame.AbsoluteCanvasSize.Y, canvasHeight, `${label}: expected the canvas to stay ${canvasHeight}px tall, got ${frame.AbsoluteCanvasSize.Y}`);
				assertHeight(field, FIELD_HEIGHT, label);
				assertHeight(root, FIELD_HEIGHT, label);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Empty and single-line values fit the field, so the canvas is no taller than the window")
	@Each([[""], ["Hello"]])
	@Test
	public shortNoScrollbar(value: string) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(value), (mounted) => {
			const root = waitForRoot(mounted.host);
			const field = waitForField(root);
			const frame = waitForWindow(root);
			settleFrames(5);

			assertHeight(field, FIELD_HEIGHT, "Field");
			Assert.true(
				frame.AbsoluteCanvasSize.Y <= frame.AbsoluteWindowSize.Y,
				`Expected the canvas (${frame.AbsoluteCanvasSize.Y}) not to exceed the window (${frame.AbsoluteWindowSize.Y})`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Growing a controlled value from short to overflowing keeps the content and TextBox widths")
	@Test
	public stableWrapWidth() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea("Hello", true), (mounted) => {
			const root = waitForRoot(mounted.host);
			waitForField(root);
			const frame = waitForWindow(root);
			settleFrames(3);

			const content = findDescendant<Frame>(frame, "ScrollerContent");
			const box = findDescendant<TextBox>(frame, "TextBox");
			const contentWidth = content.AbsoluteSize.X;
			const boxWidth = box.AbsoluteSize.X;
			Assert.true(boxWidth > 0, `Expected the TextBox to have a width, got ${boxWidth}`);

			mounted.update(textarea(LONG_TEXT, true));
			waitForOverflow(root);
			settleFrames(3);

			Assert.equal(content.AbsoluteSize.X, contentWidth, `Expected ScrollerContent to stay ${contentWidth}px wide, got ${content.AbsoluteSize.X}`);
			Assert.equal(box.AbsoluteSize.X, boxWidth, `Expected the TextBox to stay ${boxWidth}px wide, got ${box.AbsoluteSize.X}`);
		});
	}
}

export = TextareaMountValidation;
