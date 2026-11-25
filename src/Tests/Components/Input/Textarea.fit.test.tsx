import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import { SpacingHelper } from "../../../Helpers";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
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
const PROBE_HEIGHT = 40;
const MIN_LINES = 2;
const MAX_LINES = 20;
const OVER_MARGIN = 0.05;
const SIZE_TOLERANCE = 0.5;

function lines(count: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= count; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

function scaledTextarea(scale: number, value: string, height: number) {
	return (
		<frame key="Scaled" Size={UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT)} BackgroundTransparency={1}>
			<uiscale key="TestScale" Scale={scale} />
			<Textarea value={value} height={height} controlled={true} />
		</frame>
	);
}

interface Fit {
	count: number;
	content: number;
	height: number;
}

function describeScroll(frame: ScrollingFrame): string {
	return `canvas ${frame.AbsoluteCanvasSize.Y}, window ${frame.AbsoluteWindowSize.Y}`;
}

function waitForFieldHeight(root: Instance, height: number, scale: number): ImageLabel {
	const expected = height * scale;

	return waitForGuiObject<ImageLabel>(
		root,
		"Field",
		(gui) => math.abs(gui.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE,
		`Timed out waiting for the Textarea Field to be ${expected}px tall at scale ${scale}`,
	);
}

function waitForOverflow(frame: ScrollingFrame, label: string) {
	waitForLayout(
		() => (frame.AbsoluteWindowSize.Y > 0 && frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y ? true : undefined),
		`${label}: timed out waiting for the canvas to overflow`,
	);
}

function findFit(mounted: { update: (element: React.ReactElement) => void }, field: ImageLabel, scale: number): Fit {
	const padding = SpacingHelper.GetResolvedPadding(DefaultTheme, {});
	const measure = findDescendant<TextLabel>(field, "TextMeasure");
	const tolerance = 1 / scale;
	let previous = -1;

	for (let count = MIN_LINES; count <= MAX_LINES; count++) {
		const text = lines(count);

		mounted.update(scaledTextarea(scale, text, PROBE_HEIGHT));
		waitForLayout(
			() => (measure.Text === text && measure.TextBounds.Y > 0 && measure.TextBounds.Y !== previous ? true : undefined),
			`Scale ${scale}: timed out waiting for TextMeasure to measure ${count} lines`,
		);
		settleFrames(2);

		previous = measure.TextBounds.Y;

		const screenScale = field.AbsoluteSize.Y / PROBE_HEIGHT;
		const content = measure.TextBounds.Y / screenScale + padding.top + padding.bottom;
		const height = math.ceil(content - tolerance);
		const over = content - height;
		const minimum = tolerance > 1 + 2 * OVER_MARGIN ? 1 + OVER_MARGIN : OVER_MARGIN;

		if (over >= minimum && over <= tolerance - OVER_MARGIN) {
			return { count, content, height };
		}
	}

	return Assert.fail(`Scale ${scale}: fixture found no line count from ${MIN_LINES} to ${MAX_LINES} whose content lands strictly inside the tolerance`);
}

@Tag("Studio")
class TextareaFitValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Content up to one screen pixel taller than the field shows no bar at each UIScale and one more line does")
	@Each([[0.75], [1], [1.5]])
	@Test
	public withinTolerance(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale, lines(1), PROBE_HEIGHT), (mounted) => {
			const root = waitForGuiObject<Frame>(mounted.host, "Textarea");
			const field = waitForFieldHeight(root, PROBE_HEIGHT, scale);
			const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
			Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);

			const fit = findFit(mounted, field, scale);
			const label = `Scale ${scale}, ${fit.count} lines, content ${fit.content} in a ${fit.height} field`;

			mounted.update(scaledTextarea(scale, lines(fit.count), fit.height));
			waitForFieldHeight(root, fit.height, scale);
			settleFrames(5);

			const canvas = findDescendant<TextButton>(frame!, "Canvas");
			Assert.true(
				frame!.AbsoluteCanvasSize.Y <= frame!.AbsoluteWindowSize.Y,
				`${label}: expected no bar (${describeScroll(frame!)})`,
			);
			Assert.equal(canvas.Size.Y.Offset, fit.height, `${label}: expected the Canvas to stay at the field height, got ${canvas.Size.Y.Offset}`);

			mounted.update(scaledTextarea(scale, lines(fit.count + 1), fit.height));
			waitForOverflow(frame!, `${label}, plus one line`);

			Assert.true(
				frame!.AbsoluteCanvasSize.Y > frame!.AbsoluteWindowSize.Y,
				`${label}: expected one more line to overflow (${describeScroll(frame!)})`,
			);
		});
	}
}

export = TextareaFitValidation;
