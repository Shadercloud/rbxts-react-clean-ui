import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { HoverButton } from "../../../Components/Input/HoverButton";
import { fireHostEvent } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, withMounted } from "../../Helpers/layout";

type MergedEvent = "Activated" | "MouseEnter";

function eventArgs(eventName: MergedEvent): unknown[] {
	return eventName === "Activated" ? [{}, 1] : [0, 0];
}

function loggingEvents(log: string[], label: string): React.InstanceEvent<ImageButton> {
	return {
		Activated: () => {
			log.push(`${label}:Activated`);
		},
		MouseEnter: () => {
			log.push(`${label}:MouseEnter`);
		},
	};
}

function bothEventsButton(log: string[]) {
	return (
		<HoverButton
			Event={loggingEvents(log, "top")}
			default={{
				Size: UDim2.fromOffset(120, 40),
				Event: loggingEvents(log, "default"),
			}}
		/>
	);
}

@Tag("Studio")
class HoverButtonEventValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["Activated"], ["MouseEnter"]])
	@DisplayName("With both a top-level Event and default.Event, one host event runs each handler once with default's first")
	@Test
	public runsBothHandlers(eventName: MergedEvent) {
		const log: string[] = [];

		withMounted(400, 200, bothEventsButton(log), (mounted) => {
			const button = waitForGuiObject<ImageButton>(mounted.host, "HoverButton");

			fireHostEvent(mounted, button, eventName, ...eventArgs(eventName));
			Assert.deepEqual(log, [`default:${eventName}`, `top:${eventName}`]);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A ref passed to HoverButton resolves to its root ImageButton")
	@Test
	public forwardsRef() {
		const ref = React.createRef<ImageButton>();

		withMounted(400, 200, <HoverButton ref={ref} default={{ Size: UDim2.fromOffset(120, 40) }} />, (mounted) => {
			const button = waitForGuiObject<ImageButton>(mounted.host, "HoverButton");

			Assert.equal(ref.current, button);
		});
	}
}

export = HoverButtonEventValidation;
