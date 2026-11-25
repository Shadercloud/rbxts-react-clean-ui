import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import { resolveTextareaWholePixels } from "../../../Components/Input/Textarea.layout";
import { Container } from "../../../Components/Layout/Container";
import { VStack } from "../../../Components/Layout/VStack";
import { Text } from "../../../Components/Typography/Text";
import { SpacingHelper, TypographyHelper } from "../../../Helpers";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 500;
const HOST_HEIGHT = 800;
const COLUMN_WIDTH = 420;
const FIELD_HEIGHT = 120;
const SHORT_TEXT = "Hello";

function longText(lines: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= lines; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

const LONG_TEXT = longText(40);

function counterLineHeight(): number {
	const typography = TypographyHelper.getTypography(DefaultTheme, undefined, DefaultTheme.components.textarea?.counter);

	return resolveTextareaWholePixels((TypographyHelper.toTextSize(typography.size) ?? 14) * (typography.lineHeight ?? 1));
}

function expectedRootHeight(showCount: boolean): number {
	return resolveTextareaWholePixels(FIELD_HEIGHT) + (showCount ? resolveTextareaWholePixels(SpacingHelper.GetPadding(DefaultTheme, "xs")) + counterLineHeight() : 0);
}

function storyColumn(value: string, showCount: boolean) {
	return (
		<Container name="Column" width={COLUMN_WIDTH}>
			<VStack>
				<Text name="Before" text={`height={${FIELD_HEIGHT}} with long text`} LayoutOrder={1} />
				<Textarea value={value} height={FIELD_HEIGHT} showCount={showCount} LayoutOrder={2} />
				<Text name="After" text="Trailing caption" LayoutOrder={3} />
			</VStack>
		</Container>
	);
}

interface Measured {
	columnHeight: number;
	afterY: number;
	afterGap: number;
	rootHeight: number;
	fieldHeight: number;
	listGap: number;
}

function measureColumn(value: string, showCount: boolean, overflows: boolean): Measured {
	let measured: Measured | undefined;

	withMounted(HOST_WIDTH, HOST_HEIGHT, storyColumn(value, showCount), (mounted) => {
		const column = waitForGuiObject<ImageLabel>(mounted.host, "Column");
		const root = waitForGuiObject<Frame>(column, "Textarea");
		const field = waitForGuiObject<ImageLabel>(
			root,
			"Field",
			(gui) => gui.AbsoluteSize.Y === FIELD_HEIGHT,
			`Timed out waiting for the Textarea Field to be ${FIELD_HEIGHT}px tall`,
		);
		const after = waitForGuiObject<TextLabel>(column, "After");
		const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
		Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);

		waitForLayout(
			() => {
				if (!(frame!.AbsoluteWindowSize.Y > 0 && frame!.AbsoluteCanvasSize.Y > 0)) {
					return undefined;
				}

				return (frame!.AbsoluteCanvasSize.Y > frame!.AbsoluteWindowSize.Y) === overflows ? true : undefined;
			},
			`Timed out waiting for the canvas to ${overflows ? "overflow" : "fit"} the window (canvas ${frame!.AbsoluteCanvasSize.Y}, window ${frame!.AbsoluteWindowSize.Y})`,
		);
		settleFrames(5);

		measured = {
			columnHeight: column.AbsoluteSize.Y,
			afterY: after.AbsolutePosition.Y,
			afterGap: after.AbsolutePosition.Y - (root.AbsolutePosition.Y + root.AbsoluteSize.Y),
			rootHeight: root.AbsoluteSize.Y,
			fieldHeight: field.AbsoluteSize.Y,
			listGap: findDescendant<UIListLayout>(column, "VStack").Padding.Offset,
		};
	});

	return measured!;
}

function textFor(length: string): string {
	return length === "long" ? LONG_TEXT : SHORT_TEXT;
}

@Tag("Studio")
class TextareaStackValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In the story's Container and VStack, forty lines leave the column height and trailing caption where short text puts them")
	@Each([[false], [true]])
	@Test
	public stackSteady(showCount: boolean) {
		const short = measureColumn(SHORT_TEXT, showCount, false);
		const long = measureColumn(LONG_TEXT, showCount, true);

		Assert.equal(long.columnHeight, short.columnHeight, `Expected the column to stay ${short.columnHeight}px tall with long text, got ${long.columnHeight}`);
		Assert.equal(long.afterY, short.afterY, `Expected the trailing caption to stay at Y ${short.afterY} with long text, got ${long.afterY}`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without showCount the root is exactly the 120px field for short and overflowing text")
	@Each([["short"], ["long"]])
	@Test
	public rootIsField(length: string) {
		const measured = measureColumn(textFor(length), false, length === "long");

		Assert.equal(measured.fieldHeight, FIELD_HEIGHT, `Expected the field to be ${FIELD_HEIGHT}px tall, got ${measured.fieldHeight}`);
		Assert.equal(measured.rootHeight, FIELD_HEIGHT, `Expected the root to be ${FIELD_HEIGHT}px tall, got ${measured.rootHeight}`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With showCount the root is the field plus the xs gap and one counter line for short and overflowing text")
	@Each([["short"], ["long"]])
	@Test
	public rootAddsCounter(length: string) {
		const measured = measureColumn(textFor(length), true, length === "long");
		const expected = expectedRootHeight(true);

		Assert.equal(measured.fieldHeight, FIELD_HEIGHT, `Expected the field to be ${FIELD_HEIGHT}px tall, got ${measured.fieldHeight}`);
		Assert.true(
			math.abs(measured.rootHeight - expected) <= 0.5,
			`Expected the root to be ${expected}px tall (field ${FIELD_HEIGHT} + gap + counter line), got ${measured.rootHeight}`,
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The trailing caption starts one VStack gap below the root's bottom edge even when the text overflows")
	@Each([[false], [true]])
	@Test
	public captionFollowsRoot(showCount: boolean) {
		const measured = measureColumn(LONG_TEXT, showCount, true);
		const gap = measured.listGap;

		Assert.true(gap > 0, `Expected the VStack to have a gap, got ${gap}`);
		Assert.true(
			math.abs(measured.afterGap - gap) <= 0.5,
			`Expected the trailing caption ${gap}px below the root, got ${measured.afterGap}px`,
		);
	}
}

export = TextareaStackValidation;
