import { Assert, Runtime } from "@rbxts/lunit";
import { GuiService } from "@rbxts/services";

import { GamepadHelper } from "../../Helpers/gamepad.helper";
import { settleFrames } from "./layout";

export const SELECTION_SKIP_MESSAGE =
	"Requires Roblox Studio, a GuiService.SelectedObject that accepts a GuiObject under the CoreGui test host, and a non-gamepad last input type.";

let selectionProbe: boolean | undefined;

function probeSelection(): boolean {
	const coreGui = game.FindFirstChild("CoreGui");
	if (coreGui === undefined) return false;

	const gui = new Instance("ScreenGui");
	gui.Name = "SelectionProbe";

	const frame = new Instance("Frame");
	frame.Name = "SelectionProbeTarget";
	frame.Selectable = true;
	frame.Size = UDim2.fromOffset(10, 10);
	frame.Parent = gui;
	gui.Parent = coreGui;

	const previous = GuiService.SelectedObject;
	const [assigned] = pcall(() => {
		GuiService.SelectedObject = frame;
	});
	const accepted = assigned && GuiService.SelectedObject === frame;

	pcall(() => {
		GuiService.SelectedObject = previous;
	});
	gui.Destroy();

	return accepted;
}

export function selectionUnavailable(): boolean {
	if (!Runtime.isRoblox()) return true;

	if (selectionProbe === undefined) {
		selectionProbe = probeSelection();
	}

	return !selectionProbe || GamepadHelper.isGamepadActive();
}

export function resetSelection() {
	GamepadHelper.trySetSelectedObject(undefined);
}

export function withSelectionReset(fn: () => void) {
	resetSelection();

	try {
		fn();
	} finally {
		resetSelection();
	}
}

export function selectObject(target: GuiObject) {
	GamepadHelper.trySetSelectedObject(target);
	Assert.equal(
		GuiService.SelectedObject,
		target,
		`Expected GuiService.SelectedObject to accept ${target.GetFullName()} before the check`,
	);
}

export function waitForSelection(expected: GuiObject | undefined, label: string, frames = 30) {
	for (let attempt = 0; attempt < frames; attempt++) {
		if (GuiService.SelectedObject === expected) return;
		task.wait();
	}

	const actual = GuiService.SelectedObject;
	Assert.fail(
		`${label}: expected GuiService.SelectedObject to be ${expected === undefined ? "nil" : expected.GetFullName()} within ${frames} frames, got ${actual === undefined ? "nil" : actual.GetFullName()}`,
	);
}

export function assertSelectionStays(expected: GuiObject | undefined, label: string, frames = 5) {
	settleFrames(frames);

	const actual = GuiService.SelectedObject;
	Assert.true(
		actual === expected,
		`${label}: expected GuiService.SelectedObject to stay ${expected === undefined ? "nil" : expected.GetFullName()}, got ${actual === undefined ? "nil" : actual.GetFullName()}`,
	);
}
