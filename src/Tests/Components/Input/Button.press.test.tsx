import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Button } from "../../../Components/Input/Button";
import { fireHostEvent } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, withMounted } from "../../Helpers/layout";
import { PressKind, gamepadInput, hostHandler, releaseState, withPress } from "../../Helpers/press";

interface PressLog {
	events: string[];
	released: string[];
}

interface PressButtonOptions {
	mode?: string;
	disabled?: boolean;
	callerInputBegan?: boolean;
}

function newLog(): PressLog {
	return { events: [], released: [] };
}

function pressOnFor(mode: string): "down" | "up" | undefined {
	return mode === "unset" ? undefined : mode === "up" ? "up" : "down";
}

function pressButton(log: PressLog, options: PressButtonOptions = {}) {
	return (
		<Button
			text="Hold"
			pressOn={pressOnFor(options.mode ?? "down")}
			disabled={options.disabled}
			Event={{
				Activated: (_button, input) => {
					log.events.push(`activated:${input.UserInputType.Name}`);
				},
				InputBegan: options.callerInputBegan
					? (_button, input) => {
							log.events.push(`began:${input.UserInputType.Name}`);
						}
					: undefined,
			}}
			onRelease={(_button, input) => {
				log.released.push(input.UserInputType.Name);
			}}
		/>
	);
}

function waitForButton(host: Instance): ImageButton {
	return waitForGuiObject<ImageButton>(host, "Button");
}

@Tag("Studio")
class ButtonPressDownValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("A pointer InputBegan activates once and the later native Activated for the same press is swallowed")
	@Test
	public firesOnBegan(kind: PressKind) {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress(kind, (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				Assert.deepEqual(log.events, [`activated:${kind}`]);

				fireHostEvent(mounted, button, "Activated", press.input, 1);
				Assert.deepEqual(log.events, [`activated:${kind}`]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A gamepad ButtonA press is ignored on InputBegan and passes through the native Activated unchanged")
	@Test
	public gamepadPassesThrough() {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);
			const input = gamepadInput();

			fireHostEvent(mounted, button, "InputBegan", input);
			Assert.deepEqual(log.events, []);

			fireHostEvent(mounted, button, "Activated", input, 1);
			Assert.deepEqual(log.events, ["activated:Gamepad1"]);
			settleFrames(3);
			Assert.deepEqual(log.released, [], "Expected a gamepad activation never to call onRelease");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["End"], ["Cancel"]])
	@DisplayName("onRelease fires once, only when the pressed input's UserInputState becomes End or Cancel")
	@Test
	public releasesOnEnd(state: string) {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				settleFrames(2);
				Assert.deepEqual(log.released, [], "Expected no release while the press is still held");

				press.finish(releaseState(state));
				Assert.deepEqual(log.released, ["MouseButton1"]);

				press.finish(Enum.UserInputState.End);
				Assert.deepEqual(log.released, ["MouseButton1"], "Expected the release connection to be gone after it fired");
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Two simultaneous touches give two activations and each touch's own release")
	@Test
	public touchesTrackedSeparately() {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("Touch", (first) => {
				withPress("Touch", (second) => {
					fireHostEvent(mounted, button, "InputBegan", first.input);
					fireHostEvent(mounted, button, "InputBegan", second.input);
					Assert.deepEqual(log.events, ["activated:Touch", "activated:Touch"]);

					first.finish(Enum.UserInputState.End);
					Assert.deepEqual(log.released, ["Touch"]);

					second.finish(Enum.UserInputState.End);
					Assert.deepEqual(log.released, ["Touch", "Touch"]);
				});
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A disabled button ignores press-down, the native Activated and never tracks a release")
	@Test
	public disabledBlocks() {
		const log = newLog();

		withMounted(400, 200, pressButton(log, { disabled: true }), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				fireHostEvent(mounted, button, "Activated", press.input, 1);
				press.finish(Enum.UserInputState.End);

				Assert.deepEqual(log.events, []);
				Assert.deepEqual(log.released, []);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A press that began while enabled still releases after the button is disabled mid-hold")
	@Test
	public disabledMidHold() {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				mounted.update(pressButton(log, { disabled: true }));
				Assert.false(button.Active, "Expected the button to be disabled before the release");

				press.finish(Enum.UserInputState.End);
				Assert.deepEqual(log.released, ["MouseButton1"]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Presses still held when the button unmounts are dropped without calling onRelease")
	@Test
	public unmountDropsRelease() {
		const log = newLog();

		withMounted(400, 200, pressButton(log), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				mounted.update(<frame key="Empty" BackgroundTransparency={1} />);

				press.finish(Enum.UserInputState.End);
				settleFrames(2);
				Assert.deepEqual(log.released, []);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The caller's own InputBegan runs before the press-down activation")
	@Test
	public callerInputBeganFirst() {
		const log = newLog();

		withMounted(400, 200, pressButton(log, { callerInputBegan: true }), (mounted) => {
			const button = waitForButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				Assert.deepEqual(log.events, ["began:MouseButton1", "activated:MouseButton1"]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["unset"], ["up"]])
	@DisplayName("Without pressOn down there is no InputBegan handler and a pointer Activated fires as before")
	@Test
	public upUnchanged(mode: string) {
		const log = newLog();

		withMounted(400, 200, pressButton(log, { mode }), (mounted) => {
			const button = waitForButton(mounted.host);

			Assert.undefined(hostHandler(mounted, button, "InputBegan"), `${mode}: expected no InputBegan handler`);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "Activated", press.input, 1);
				press.finish(Enum.UserInputState.End);

				Assert.deepEqual(log.events, ["activated:MouseButton1"]);
				Assert.deepEqual(log.released, [], `${mode}: expected onRelease to be unused`);
			});
		});
	}
}

export = ButtonPressDownValidation;
