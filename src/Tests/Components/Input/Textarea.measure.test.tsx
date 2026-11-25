import React from "@rbxts/react";
import { RunService } from "@rbxts/services";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Textarea } from "../../../Components/Input/Textarea";
import { STUDIO_SKIP_MESSAGE, findDescendant, settleFrames, waitForGuiObject, waitForLayout, withMounted } from "../../Helpers/layout";

const HOST_WIDTH = 300;
const HOST_HEIGHT = 400;
const FIELD_HEIGHT = 160;
const SAMPLE_FRAMES = 10;
const SETTLE_FRAMES = 10;
const SIZE_TOLERANCE = 0.5;

function lines(count: number): string {
	const parts: string[] = [];

	for (let index = 1; index <= count; index++) {
		parts.push(`Line ${index}`);
	}

	return parts.join("\n");
}

interface Sample {
	frame: number;
	boxY: number;
	canvasY: number;
	top: number;
	screenCanvasY: number;
}

interface Sampler {
	frame: number;
	samples: Sample[];
	box: TextBox | undefined;
	ref: (instance: TextBox | undefined) => void;
}

function sample(sampler: Sampler) {
	const box = sampler.box;
	const canvas = box?.Parent;

	if (box === undefined || canvas === undefined || !canvas.IsA("TextButton") || sampler.frame > SAMPLE_FRAMES) {
		return;
	}

	const frame = box.FindFirstAncestorWhichIsA("ScrollingFrame");

	sampler.samples.push({
		frame: sampler.frame,
		boxY: box.Size.Y.Offset,
		canvasY: canvas.Size.Y.Offset,
		top: box.Position.Y.Offset,
		screenCanvasY: frame?.AbsoluteCanvasSize.Y ?? 0,
	});
}

function withSampler(fn: (sampler: Sampler) => void) {
	const connections: RBXScriptConnection[] = [];
	const sampler: Sampler = {
		frame: 0,
		samples: [],
		box: undefined,
		ref: (instance) => {
			if (instance === undefined || sampler.box !== undefined) {
				return;
			}

			sampler.box = instance;
			sample(sampler);
			connections.push(
				RunService.Heartbeat.Connect(() => {
					sampler.frame += 1;
					sample(sampler);
				}),
			);
		},
	};

	try {
		fn(sampler);
	} finally {
		for (const connection of connections) {
			connection.Disconnect();
		}
	}
}

function describeSample(entry: Sample): string {
	return `f${entry.frame}: TextBox ${entry.boxY}, Canvas ${entry.canvasY}, top ${entry.top}, AbsoluteCanvasSize ${entry.screenCanvasY}`;
}

@Tag("Studio")
class TextareaFirstMeasureValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("On every frame after mount the TextBox is at most canvas minus top padding and the canvas never overshoots")
	@Each([[40], [1], [0]])
	@Test
	public noEarlyDoubling(lineCount: number) {
		const value = lineCount > 0 ? lines(lineCount) : "";

		withSampler((sampler) => {
			withMounted(HOST_WIDTH, HOST_HEIGHT, <Textarea ref={sampler.ref} value={value} height={FIELD_HEIGHT} />, (mounted) => {
				const root = waitForGuiObject<Frame>(mounted.host, "Textarea");
				const frame = root.FindFirstChildWhichIsA("ScrollingFrame", true);
				Assert.notUndefined(frame, `Expected a ScrollingFrame under ${root.GetFullName()}`);

				if (lineCount === 40) {
					waitForLayout(
						() => (frame!.AbsoluteWindowSize.Y > 0 && frame!.AbsoluteCanvasSize.Y > frame!.AbsoluteWindowSize.Y ? true : undefined),
						"Timed out waiting for 40 lines to overflow the field",
					);
				}

				settleFrames(SETTLE_FRAMES);

				const canvas = findDescendant<TextButton>(frame!, "Canvas");
				const finalCanvas = canvas.Size.Y.Offset;
				const finalScreenCanvas = frame!.AbsoluteCanvasSize.Y;

				Assert.true(sampler.samples.size() > SAMPLE_FRAMES, `Expected a sample on every Heartbeat, got ${sampler.samples.size()}`);

				if (lineCount === 40) {
					Assert.true(finalCanvas > FIELD_HEIGHT, `Expected 40 lines to give a canvas taller than ${FIELD_HEIGHT}, got ${finalCanvas}`);
				} else {
					Assert.equal(finalCanvas, FIELD_HEIGHT, `Expected a fitting value to leave the canvas at the view height ${FIELD_HEIGHT}, got ${finalCanvas}`);
				}

				for (const entry of sampler.samples) {
					Assert.true(entry.boxY <= entry.canvasY - entry.top, `Expected the TextBox to stay within the canvas (${describeSample(entry)})`);
					Assert.true(entry.canvasY <= finalCanvas, `Expected the canvas never to exceed the final ${finalCanvas} (${describeSample(entry)})`);
					Assert.true(
						entry.screenCanvasY <= finalScreenCanvas + SIZE_TOLERANCE,
						`Expected AbsoluteCanvasSize never to exceed the final ${finalScreenCanvas} (${describeSample(entry)})`,
					);

					if (lineCount === 0) {
						Assert.equal(entry.canvasY, FIELD_HEIGHT, `Expected an empty field to keep the view-height canvas (${describeSample(entry)})`);
					}
				}
			});
		});
	}
}

export = TextareaFirstMeasureValidation;
