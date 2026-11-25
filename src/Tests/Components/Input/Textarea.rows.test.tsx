import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import { resolveTextareaWholePixels } from "../../../Components/Input/Textarea.layout";
import { SpacingHelper } from "../../../Helpers";
import { DefaultTheme } from "../../../Theme";
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
const ROWS = 4;
const FIELD_HEIGHT = 125;
const ROOT_WITH_COUNT = 155;

function lines(count: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= count; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

const LONG_TEXT = lines(40);

function textarea(value: string, showCount?: boolean) {
	return <Textarea value={value} rows={ROWS} showCount={showCount} />;
}

interface Mounted {
	root: Frame;
	field: ImageLabel;
	frame: ScrollingFrame;
	box: TextBox;
}

function waitForMounted(host: Instance): Mounted {
	const root = waitForGuiObject<Frame>(host, "Textarea");
	const field = waitForGuiObject<ImageLabel>(root, "Field");
	const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
	Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);

	const box = findDescendant<TextBox>(frame!, "TextBox");
	waitForLayout(
		() => (box.AbsoluteSize.X > 0 ? true : undefined),
		`Timed out waiting for the TextBox to get a width (${describeGui(box)})`,
	);
	settleFrames(5);

	return { root, field, frame: frame!, box };
}

@Tag("Studio")
class TextareaRowsValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Four default-theme rows render a 125px field, and with showCount a 155px root")
	@Each([[false], [true]])
	@Test
	public wholePixelField(showCount: boolean) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT, showCount), (mounted) => {
			const view = waitForMounted(mounted.host);

			Assert.equal(view.field.Size.Y.Offset, FIELD_HEIGHT, `Expected the computed field height to be ${FIELD_HEIGHT}, got ${view.field.Size.Y.Offset}`);
			Assert.equal(view.field.AbsoluteSize.Y, FIELD_HEIGHT, `Expected ${describeGui(view.field)} to render ${FIELD_HEIGHT}px tall`);

			const expectedRoot = showCount ? ROOT_WITH_COUNT : FIELD_HEIGHT;
			Assert.equal(view.root.AbsoluteSize.Y, expectedRoot, `Expected ${describeGui(view.root)} to be ${expectedRoot}px tall`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With four rows the canvas is the unscaled measured text plus padding, so the scale used is exactly 1")
	@Test
	public unitScale() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), (mounted) => {
			const view = waitForMounted(mounted.host);
			waitForLayout(
				() => (view.frame.AbsoluteCanvasSize.Y > view.frame.AbsoluteWindowSize.Y ? true : undefined),
				"Timed out waiting for 40 lines to overflow the four-row field",
			);
			settleFrames(3);

			const padding = SpacingHelper.GetResolvedPadding(DefaultTheme, {});
			const measure = findDescendant<TextLabel>(view.field, "TextMeasure");
			const canvas = findDescendant<TextButton>(view.frame, "Canvas");
			const expected = resolveTextareaWholePixels(measure.TextBounds.Y + padding.top + padding.bottom);

			Assert.equal(
				canvas.Size.Y.Offset,
				expected,
				`Expected the canvas to be ceil(${measure.TextBounds.Y} + ${padding.top} + ${padding.bottom}) = ${expected} at scale 1, got ${canvas.Size.Y.Offset}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TextMeasure and CaretProbe are exactly as wide as the rendered TextBox at odd and even host widths")
	@Each([[289], [300], [301]])
	@Test
	public probesMatchTextBox(width: number) {
		withMounted(width, HOST_HEIGHT, textarea(LONG_TEXT, true), (mounted) => {
			const view = waitForMounted(mounted.host);
			const boxWidth = view.box.AbsoluteSize.X;

			for (const name of ["TextMeasure", "CaretProbe", "LineProbe"]) {
				const label = findDescendant<TextLabel>(view.field, name);

				Assert.equal(label.Size.X.Offset, boxWidth, `Host ${width}: expected ${name} to be ${boxWidth}px wide like the TextBox, got ${label.Size.X.Offset}`);
				Assert.equal(label.AbsoluteSize.X, boxWidth, `Host ${width}: expected ${name} to render ${boxWidth}px wide, got ${label.AbsoluteSize.X}`);
			}
		});
	}
}

export = TextareaRowsValidation;
