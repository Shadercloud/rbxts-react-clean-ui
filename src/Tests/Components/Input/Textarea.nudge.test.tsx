import React from "@rbxts/react";
import { RunService } from "@rbxts/services";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, withMounted } from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 400;
const FIELD_HEIGHT = 160;
const NUDGE_FRAMES = 4;
const WATCH_FRAMES = 10;
const OVERFLOW_FRAMES = 30;
const USER_SCROLL = 100;
const MAX_LENGTH = 100;
const OVER_LIMIT_BYTES = 795;

function lines(prefix: string, count: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= count; index++) {
		parts.push(`${prefix} ${index}`);
	}

	return parts.join("\n");
}

const SHORT_TEXT = "Hello";
const LONG_TEXT = lines("Line", 40);
const OTHER_LONG_TEXT = lines("Item", 40);
const OVER_LIMIT_TEXT = `${string.rep("abcdefghi\n", 79)}abcde`;

interface SizeSample {
	frame: number;
	y: number;
	canvasY: number;
	scrollY: number;
}

interface FrameSample {
	frame: number;
	canvasY: number;
	scrollY: number;
}

interface Recorder {
	box: TextBox | undefined;
	start: number;
	frame: number;
	samples: SizeSample[];
	frames: FrameSample[];
	changes: string[];
	ref: (instance: TextBox | undefined) => void;
	onChange: (value: string) => void;
	reset: () => void;
}

function scrollerOf(box: TextBox | undefined): ScrollingFrame | undefined {
	return box?.FindFirstAncestorWhichIsA("ScrollingFrame");
}

function withRecorder(fn: (recorder: Recorder) => void) {
	const connections: RBXScriptConnection[] = [];
	const recorder: Recorder = {
		box: undefined,
		start: 0,
		frame: 0,
		samples: [],
		frames: [],
		changes: [],
		ref: (instance) => {
			if (instance === undefined || instance === recorder.box) {
				return;
			}

			recorder.box = instance;
			recorder.start = instance.Size.Y.Offset;
			recorder.frame = 0;
			connections.push(
				instance.GetPropertyChangedSignal("Size").Connect(() => {
					const frame = scrollerOf(instance);

					recorder.samples.push({
						frame: recorder.frame,
						y: instance.Size.Y.Offset,
						canvasY: frame?.AbsoluteCanvasSize.Y ?? 0,
						scrollY: frame?.CanvasPosition.Y ?? 0,
					});
				}),
			);
		},
		onChange: (value) => {
			recorder.changes.push(value);
		},
		reset: () => {
			recorder.start = recorder.box?.Size.Y.Offset ?? 0;
			recorder.frame = 0;
			recorder.samples.clear();
			recorder.frames.clear();
			recorder.changes.clear();
		},
	};

	connections.push(
		RunService.Heartbeat.Connect(() => {
			recorder.frame += 1;

			const frame = scrollerOf(recorder.box);

			if (frame !== undefined) {
				recorder.frames.push({ frame: recorder.frame, canvasY: frame.AbsoluteCanvasSize.Y, scrollY: frame.CanvasPosition.Y });
			}
		}),
	);

	try {
		fn(recorder);
	} finally {
		for (const connection of connections) {
			connection.Disconnect();
		}
	}
}

function textarea(recorder: Recorder, value: string, controlled?: boolean, maxLength?: number) {
	return (
		<Textarea
			ref={recorder.ref}
			value={value}
			height={FIELD_HEIGHT}
			controlled={controlled}
			maxLength={maxLength}
			onChange={recorder.onChange}
		/>
	);
}

function describeSamples(recorder: Recorder): string {
	const parts = recorder.samples.map((sample) => `f${sample.frame}:${sample.y}`);

	return `start ${recorder.start}, Size Y changes [${parts.join(", ")}]`;
}

function findDips(recorder: Recorder): number[] {
	const dips: number[] = [];
	let previous = recorder.start;

	for (let index = 0; index < recorder.samples.size(); index++) {
		const sample = recorder.samples[index];

		if (sample.y === previous - 1) {
			dips.push(index);
		}

		previous = sample.y;
	}

	return dips;
}

function currentBox(recorder: Recorder): TextBox {
	const box = recorder.box;
	Assert.notUndefined(box, "Expected the Textarea ref to receive its TextBox");
	return box!;
}

function renderedHeight(box: TextBox): number {
	const canvas = box.Parent as TextButton;

	return canvas.Size.Y.Offset - box.Position.Y.Offset;
}

function waitForOverflow(recorder: Recorder): ScrollingFrame {
	for (let attempt = 0; attempt < OVERFLOW_FRAMES; attempt++) {
		const frame = scrollerOf(recorder.box);

		if (frame !== undefined && frame.AbsoluteWindowSize.Y > 0 && frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y) {
			return frame;
		}

		task.wait();
	}

	const frame = scrollerOf(recorder.box);

	return Assert.fail(
		`Timed out waiting for the canvas to overflow (canvas ${frame?.AbsoluteCanvasSize.Y}, window ${frame?.AbsoluteWindowSize.Y})`,
	);
}

function assertNudgedOnce(recorder: Recorder, label: string) {
	const box = currentBox(recorder);
	const dips = findDips(recorder);

	Assert.equal(dips.size(), 1, `${label}: expected exactly one 1px dip in the TextBox Size height (${describeSamples(recorder)})`);

	const index = dips[0];
	const dip = recorder.samples[index];
	const before = index === 0 ? recorder.start : recorder.samples[index - 1].y;
	const restore = recorder.samples[index + 1] as SizeSample | undefined;
	const rendered = renderedHeight(box);

	Assert.true(dip.frame <= NUDGE_FRAMES, `${label}: expected the dip within ${NUDGE_FRAMES} Heartbeats, it came on ${dip.frame} (${describeSamples(recorder)})`);
	Assert.notUndefined(restore, `${label}: expected the dip to be restored (${describeSamples(recorder)})`);
	Assert.true(
		restore!.frame <= dip.frame + 1,
		`${label}: expected the restore on the Heartbeat after the dip (${describeSamples(recorder)})`,
	);
	Assert.true(
		restore!.y === before || restore!.y === rendered,
		`${label}: expected the restore to return to ${before} or the rendered ${rendered}, got ${restore!.y} (${describeSamples(recorder)})`,
	);
	Assert.equal(box.Size.Y.Offset, rendered, `${label}: expected the TextBox to end at the rendered height ${rendered}, got ${box.Size.Y.Offset}`);
}

function assertEchoes(recorder: Recorder, value: string, label: string) {
	Assert.true(recorder.changes.size() <= 1, `${label}: expected at most one onChange, got ${recorder.changes.size()}`);

	for (const change of recorder.changes) {
		Assert.true(change === value, `${label}: expected onChange to carry the new ${value.size()}-byte value, got ${change.size()} bytes`);
	}
}

@Tag("Studio")
class TextareaNudgeValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Mounting 40 lines unfocused shrinks the TextBox by 1px for one Heartbeat and fires no onChange")
	@Test
	public nudgeOnMount() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				assertNudgedOnce(recorder, "Mount");
				Assert.equal(recorder.changes.size(), 0, `Expected no onChange on mount, got ${recorder.changes.size()}`);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A controlled update from one line to 40 while unfocused nudges once with at most one onChange echo")
	@Test
	public nudgeOnUpdate() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				settleFrames(WATCH_FRAMES);

				recorder.reset();
				mounted.update(textarea(recorder, LONG_TEXT, true));
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				assertNudgedOnce(recorder, "Controlled update");
				assertEchoes(recorder, LONG_TEXT, "Controlled update");
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Remounting with a 40-line initial value nudges the new TextBox once")
	@Test
	public nudgeOnRemount() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				const first = currentBox(recorder);

				mounted.update(<frame key="Empty" BackgroundTransparency={1} />);
				settleFrames(3);
				recorder.reset();
				mounted.update(textarea(recorder, LONG_TEXT));
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				Assert.true(currentBox(recorder) !== first, "Expected the remount to create a new TextBox");
				assertNudgedOnce(recorder, "Remount");
				Assert.equal(recorder.changes.size(), 0, `Expected no onChange on remount, got ${recorder.changes.size()}`);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Through the nudge the canvas height stays fixed and a CanvasPosition of 100 stays at 100")
	@Test
	public nudgeKeepsCanvas() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT, true), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				const frame = waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				frame.CanvasPosition = new Vector2(frame.CanvasPosition.X, USER_SCROLL);
				settleFrames(3);

				const canvasY = frame.AbsoluteCanvasSize.Y;
				Assert.equal(frame.CanvasPosition.Y, USER_SCROLL, `Expected the test scroll to land at ${USER_SCROLL}`);

				recorder.reset();
				mounted.update(textarea(recorder, OTHER_LONG_TEXT, true));
				settleFrames(WATCH_FRAMES);

				assertNudgedOnce(recorder, "Long to long update");
				Assert.true(currentBox(recorder).Text === OTHER_LONG_TEXT, "Expected the TextBox to show the updated value");

				for (const sample of recorder.samples) {
					Assert.equal(sample.canvasY, canvasY, `Expected the canvas to stay ${canvasY} at Size change f${sample.frame}, got ${sample.canvasY}`);
					Assert.equal(sample.scrollY, USER_SCROLL, `Expected CanvasPosition.Y to stay ${USER_SCROLL} at Size change f${sample.frame}, got ${sample.scrollY}`);
				}

				for (const sample of recorder.frames) {
					Assert.equal(sample.canvasY, canvasY, `Expected the canvas to stay ${canvasY} on Heartbeat ${sample.frame}, got ${sample.canvasY}`);
					Assert.equal(sample.scrollY, USER_SCROLL, `Expected CanvasPosition.Y to stay ${USER_SCROLL} on Heartbeat ${sample.frame}, got ${sample.scrollY}`);
				}

				assertEchoes(recorder, OTHER_LONG_TEXT, "Long to long update");
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A 795-byte initial value with maxLength 100 is shown untrimmed while unfocused")
	@Test
	public noTrimOnMount() {
		Assert.equal(OVER_LIMIT_TEXT.size(), OVER_LIMIT_BYTES, "Fixture out of date: expected the over-limit value to be 795 bytes");

		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, OVER_LIMIT_TEXT, false, MAX_LENGTH), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				const box = currentBox(recorder);
				Assert.equal(box.Text.size(), OVER_LIMIT_BYTES, `Expected the TextBox to keep all ${OVER_LIMIT_BYTES} bytes, got ${box.Text.size()}`);
				Assert.equal(recorder.changes.size(), 0, `Expected no onChange on mount, got ${recorder.changes.size()}`);
				assertNudgedOnce(recorder, "Over-limit mount");
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A controlled update to 795 bytes with maxLength 100 stays untrimmed and any echo carries all of it")
	@Test
	public noTrimOnUpdate() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true, MAX_LENGTH), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				settleFrames(WATCH_FRAMES);

				recorder.reset();
				mounted.update(textarea(recorder, OVER_LIMIT_TEXT, true, MAX_LENGTH));
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);

				const box = currentBox(recorder);
				Assert.equal(box.Text.size(), OVER_LIMIT_BYTES, `Expected the TextBox to keep all ${OVER_LIMIT_BYTES} bytes, got ${box.Text.size()}`);
				assertEchoes(recorder, OVER_LIMIT_TEXT, "Over-limit update");
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Rendering the same new value again after it was nudged does not nudge a second time")
	@Test
	public sameValueOnce() {
		withRecorder((recorder) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true), (mounted) => {
				waitForGuiObject<Frame>(mounted.host, "Textarea");
				settleFrames(WATCH_FRAMES);

				recorder.reset();
				mounted.update(textarea(recorder, LONG_TEXT, true));
				waitForOverflow(recorder);
				settleFrames(WATCH_FRAMES);
				mounted.update(textarea(recorder, LONG_TEXT, true));
				settleFrames(WATCH_FRAMES);
				mounted.update(textarea(recorder, LONG_TEXT, true));
				settleFrames(WATCH_FRAMES);

				Assert.equal(findDips(recorder).size(), 1, `Expected one nudge for the repeated value (${describeSamples(recorder)})`);
			});
		});
	}
}

export = TextareaNudgeValidation;
