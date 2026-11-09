import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { STUDIO_SKIP_MESSAGE, settleFrames, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	FAST_TOOLTIP,
	assertNoPopup,
	assertStaysShown,
	pressInput,
	tipApp,
	touchPress,
	waitForShown,
	waitForTrigger,
} from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipLongPressValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A held touch on a longPress trigger shows nothing before longPressDelay and opens the popup after it")
	@Test
	public holdOpens() {
		withMounted(400, 300, tipApp({ longPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			const touch = touchPress();
			fireHostEvent(mounted, trigger, "InputBegan", touch.input);

			task.wait(FAST_TOOLTIP.longPressDelay * 0.5);
			Assert.undefined(mounted.host.FindFirstChild("Tooltip", true), "Expected no popup before longPressDelay");

			task.wait(FAST_TOOLTIP.longPressDelay * 0.5);
			waitForShown(mounted.host);
			assertStaysShown(mounted.host, 0.3, "Expected the popup to stay open while the finger is down");
			touch.finish(Enum.UserInputState.End);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["End", false], ["Cancel", false], ["End", true]])
	@DisplayName("Lifting or cancelling a long press closes the popup, and a long press never pins even with pinOnPress")
	@Test
	public releaseCloses(state: "End" | "Cancel", pinOnPress: boolean) {
		withMounted(400, 300, tipApp({ longPress: true, pinOnPress }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			const touch = touchPress();
			fireHostEvent(mounted, trigger, "InputBegan", touch.input);
			task.wait(FAST_TOOLTIP.longPressDelay);
			waitForShown(mounted.host);

			touch.finish(state === "End" ? Enum.UserInputState.End : Enum.UserInputState.Cancel);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A short tap on a longPress trigger without pinOnPress never opens the popup")
	@Test
	public shortTapNoop() {
		withMounted(400, 300, tipApp({ longPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			const touch = touchPress();
			fireHostEvent(mounted, trigger, "InputBegan", touch.input);
			touch.finish(Enum.UserInputState.End);

			task.wait(FAST_TOOLTIP.longPressDelay + 0.2);
			assertNoPopup(mounted.host, "Expected a short tap not to open a longPress-only Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With longPress and pinOnPress, a short tap pins on release rather than touch-down, and a second tap unpins")
	@Test
	public tapTogglesPin() {
		withMounted(400, 300, tipApp({ longPress: true, pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			const first = touchPress();
			fireHostEvent(mounted, trigger, "InputBegan", first.input);
			settleFrames(5);
			Assert.undefined(mounted.host.FindFirstChild("Tooltip", true), "Expected no popup on touch-down");

			first.finish(Enum.UserInputState.End);
			waitForShown(mounted.host);
			assertStaysShown(mounted.host, FAST_TOOLTIP.longPressDelay + 0.2, "Expected the tap to pin the popup");

			const second = touchPress();
			fireHostEvent(mounted, trigger, "InputBegan", second.input);
			second.finish(Enum.UserInputState.End);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With longPress and pinOnPress, a mouse press pins immediately instead of starting a long press")
	@Test
	public mousePressPins() {
		withMounted(400, 300, tipApp({ longPress: true, pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			waitForShown(mounted.host);
			assertStaysShown(mounted.host, 0.3, "Expected a mouse press to pin the popup");
		});
	}
}

export = TooltipLongPressValidation;
