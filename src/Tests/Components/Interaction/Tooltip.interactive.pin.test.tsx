import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { STUDIO_SKIP_MESSAGE, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import { HOLD_SECONDS, assertStaysShown, pressInput, tipApp, waitForShown, waitForTrigger } from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipPinValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With pinOnPress, a press on the hovered trigger keeps the popup open after MouseLeave")
	@Test
	public pressPins() {
		withMounted(400, 300, tipApp({ pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			waitForShown(mounted.host);

			fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected a pinned popup to survive MouseLeave");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("With pinOnPress, a first press opens the popup without a hover and a second press on the trigger closes it")
	@Test
	public pressTriggerUnpins(kind: "MouseButton1" | "Touch") {
		withMounted(400, 300, tipApp({ pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind));
			waitForShown(mounted.host);

			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind));
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Unpinning while the trigger is still hovered leaves the popup open until the pointer leaves")
	@Test
	public hoveredUnpinOpen() {
		withMounted(400, 300, tipApp({ pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected the hovered trigger to keep an unpinned popup open");

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("A press anywhere on a pinned popup unpins and closes it, and its pinOnPress popup is Active")
	@Test
	public pressPopupUnpins(kind: "MouseButton1" | "Touch") {
		withMounted(400, 300, tipApp({ pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			const popup = waitForShown(mounted.host);

			Assert.true(popup.Active, "Expected a pinOnPress Tooltip popup to be Active");

			fireHostEvent(mounted, popup, "InputBegan", pressInput(kind));
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A press on an unpinned, hover-opened popup does not pin it, so leaving the trigger still closes it")
	@Test
	public popupPressNoPin() {
		withMounted(400, 300, tipApp({ pinOnPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			const popup = waitForShown(mounted.host);

			fireHostEvent(mounted, popup, "InputBegan", pressInput());
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}
}

export = TooltipPinValidation;
