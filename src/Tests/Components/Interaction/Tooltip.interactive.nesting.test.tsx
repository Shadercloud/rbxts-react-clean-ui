import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { STUDIO_SKIP_MESSAGE, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	HOLD_SECONDS,
	ParentMode,
	assertStaysShown,
	nestedApp,
	waitForShown,
	waitForTrigger,
} from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipNestingValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["interactive"], ["pinOnPress"]])
	@DisplayName("An open nested tooltip keeps an interactive or pinOnPress parent open until the nested one hides")
	@Test
	public childHoldsParent(mode: ParentMode) {
		withMounted(400, 300, nestedApp(mode, true), (mounted) => {
			const trigger = waitForTrigger(mounted.host, "ParentTrigger");
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			waitForShown(mounted.host, "ParentTip");
			waitForShown(mounted.host, "ChildTip");

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			assertStaysShown(mounted.host, HOLD_SECONDS, `Expected the nested tooltip to hold the ${mode} parent open`, "ParentTip");

			mounted.update(nestedApp(mode, false));
			waitForRemoval(mounted.host, "ParentTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An open nested tooltip does not keep a plain hover parent open after its trigger is left")
	@Test
	public plainParentCloses() {
		withMounted(400, 300, nestedApp("plain", true), (mounted) => {
			const trigger = waitForTrigger(mounted.host, "ParentTrigger");
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			waitForShown(mounted.host, "ParentTip");
			waitForShown(mounted.host, "ChildTip");

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "ParentTip");
		});
	}
}

export = TooltipNestingValidation;
