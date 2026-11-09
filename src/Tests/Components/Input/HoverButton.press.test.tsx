import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { HoverButton } from "../../../Components/Input/HoverButton";
import { fireHostEvent } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForGuiObject, withMounted } from "../../Helpers/layout";
import { PressKind, gamepadInput, hostHandler, releaseState, withPress } from "../../Helpers/press";

interface PressLog {
	events: string[];
	released: string[];
}

interface PressHoverOptions {
	mode?: string;
	active?: boolean;
	hoverActivated?: boolean;
}

function newLog(): PressLog {
	return { events: [], released: [] };
}

function pressOnFor(mode: string): "down" | "up" | undefined {
	return mode === "unset" ? undefined : mode === "up" ? "up" : "down";
}

function pressHoverButton(log: PressLog, options: PressHoverOptions = {}) {
	return (
		<HoverButton
			pressOn={pressOnFor(options.mode ?? "down")}
			onRelease={(_button, input) => {
				log.released.push(input.UserInputType.Name);
			}}
			default={{
				Size: UDim2.fromOffset(120, 40),
				Active: options.active,
				Event: {
					Activated: (_button, input) => {
						log.events.push(`default:${input.UserInputType.Name}`);
					},
				},
			}}
			hover={
				options.hoverActivated
					? {
							Event: {
								Activated: (_button, input) => {
									log.events.push(`hover:${input.UserInputType.Name}`);
								},
							},
						}
					: undefined
			}
		/>
	);
}

function waitForHoverButton(host: Instance): ImageButton {
	return waitForGuiObject<ImageButton>(host, "HoverButton");
}

@Tag("Studio")
class HoverButtonPressDownValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("A pointer InputBegan calls the default Activated once and the later native pointer Activated is swallowed")
	@Test
	public firesOnBegan(kind: PressKind) {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log), (mounted) => {
			const button = waitForHoverButton(mounted.host);

			withPress(kind, (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				Assert.deepEqual(log.events, [`default:${kind}`]);

				fireHostEvent(mounted, button, "Activated", press.input, 1);
				Assert.deepEqual(log.events, [`default:${kind}`]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A gamepad ButtonA press is ignored on InputBegan and passes through the native Activated")
	@Test
	public gamepadPassesThrough() {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log), (mounted) => {
			const button = waitForHoverButton(mounted.host);
			const input = gamepadInput();

			fireHostEvent(mounted, button, "InputBegan", input);
			Assert.deepEqual(log.events, []);

			fireHostEvent(mounted, button, "Activated", input, 1);
			Assert.deepEqual(log.events, ["default:Gamepad1"]);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["End"], ["Cancel"]])
	@DisplayName("onRelease fires once when the pressed input's UserInputState becomes End or Cancel")
	@Test
	public releasesOnEnd(state: string) {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log), (mounted) => {
			const button = waitForHoverButton(mounted.host);

			withPress("Touch", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				settleFrames(2);
				Assert.deepEqual(log.released, [], "Expected no release while the touch is still held");

				press.finish(releaseState(state));
				Assert.deepEqual(log.released, ["Touch"]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Active=false in the merged prop set blocks press-down activation and its release")
	@Test
	public inactiveBlocks() {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log, { active: false }), (mounted) => {
			const button = waitForHoverButton(mounted.host);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				press.finish(Enum.UserInputState.End);

				Assert.deepEqual(log.events, []);
				Assert.deepEqual(log.released, []);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("While hovered, press-down calls the hover set's Activated instead of the default one")
	@Test
	public hoverSetActivated() {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log, { hoverActivated: true }), (mounted) => {
			const button = waitForHoverButton(mounted.host);

			fireHostEvent(mounted, button, "MouseEnter", 0, 0);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "InputBegan", press.input);
				Assert.deepEqual(log.events, ["hover:MouseButton1"]);
			});
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["unset"], ["up"]])
	@DisplayName("Without pressOn down there is no InputBegan handler and a pointer Activated reaches the default set")
	@Test
	public upUnchanged(mode: string) {
		const log = newLog();

		withMounted(400, 200, pressHoverButton(log, { mode }), (mounted) => {
			const button = waitForHoverButton(mounted.host);

			Assert.undefined(hostHandler(mounted, button, "InputBegan"), `${mode}: expected no InputBegan handler`);

			withPress("MouseButton1", (press) => {
				fireHostEvent(mounted, button, "Activated", press.input, 1);
				press.finish(Enum.UserInputState.End);

				Assert.deepEqual(log.events, ["default:MouseButton1"]);
				Assert.deepEqual(log.released, [], `${mode}: expected onRelease to be unused`);
			});
		});
	}
}

export = HoverButtonPressDownValidation;
