import React from "@rbxts/react";

import { findHostFiber } from "./fiber";
import { MountedElement } from "./layout";

export type PressKind = "MouseButton1" | "Touch";

export interface HeldPress {
	input: InputObject;
	finish: (state: Enum.UserInputState) => void;
}

export function withPress(kind: PressKind, fn: (press: HeldPress) => void) {
	const changed = new Instance("BindableEvent");
	const fields = {
		UserInputType: kind === "Touch" ? Enum.UserInputType.Touch : Enum.UserInputType.MouseButton1,
		UserInputState: Enum.UserInputState.Begin as Enum.UserInputState,
		GetPropertyChangedSignal: () => changed.Event,
	};

	try {
		fn({
			input: fields as unknown as InputObject,
			finish: (state) => {
				fields.UserInputState = state;
				changed.Fire();
				task.wait();
			},
		});
	} finally {
		changed.Destroy();
	}
}

export function gamepadInput(): InputObject {
	return {
		UserInputType: Enum.UserInputType.Gamepad1,
		KeyCode: Enum.KeyCode.ButtonA,
		UserInputState: Enum.UserInputState.Begin,
	} as unknown as InputObject;
}

export function releaseState(label: string): Enum.UserInputState {
	return label === "Cancel" ? Enum.UserInputState.Cancel : Enum.UserInputState.End;
}

export function hostHandler(mounted: MountedElement, instance: Instance, eventName: string): unknown {
	const eventKey = (React as unknown as { Event: Record<string, unknown> }).Event[eventName];
	return findHostFiber(mounted, instance).memoizedProps?.get(eventKey);
}
