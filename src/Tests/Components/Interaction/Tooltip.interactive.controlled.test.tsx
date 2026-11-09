import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { DefaultTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	FAST_TOOLTIP,
	assertNoPopup,
	fadesBy,
	pressInput,
	tipApp,
	touchPress,
	waitForShown,
	waitForTrigger,
} from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipControlledValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("With open={false}, presses and long presses on a trigger with every opt-in prop open nothing")
	@Test
	public controlledIgnoresPress(kind: "MouseButton1" | "Touch") {
		withMounted(400, 300, tipApp({ open: false, interactive: true, pinOnPress: true, longPress: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);

			if (kind === "Touch") {
				const touch = touchPress();
				fireHostEvent(mounted, trigger, "InputBegan", touch.input);
				task.wait(FAST_TOOLTIP.longPressDelay + 0.2);
				assertNoPopup(mounted.host, "Expected a long press not to open a controlled Tooltip");
				touch.finish(Enum.UserInputState.End);
			} else {
				fireHostEvent(mounted, trigger, "InputBegan", pressInput());
			}

			assertNoPopup(mounted.host, `Expected a ${kind} press not to open a controlled Tooltip`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Switching an interactive Tooltip from open={true} to open={false} fades it at once with no closeDelay")
	@Test
	public controlledCloseImmediate() {
		withMounted(400, 300, tipApp({ open: true, interactive: true }, DefaultTheme), (mounted) => {
			const popup = waitForShown(mounted.host);

			mounted.update(tipApp({ open: false, interactive: true }, DefaultTheme));
			Assert.true(
				fadesBy(popup, os.clock() + DefaultTheme.components.tooltip.closeDelay! * 0.6),
				"Expected a controlled close to start fading before closeDelay",
			);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}
}

export = TooltipControlledValidation;
