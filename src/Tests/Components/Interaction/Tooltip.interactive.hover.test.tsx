import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { DefaultTheme, extendTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	FAST_THEME,
	HOLD_SECONDS,
	assertNoPopup,
	assertStaysShown,
	fadesBy,
	pressInput,
	tipApp,
	waitForShown,
	waitForTrigger,
} from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipHoverValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without the opt-in props, leaving the trigger starts the fade at once and the popup is not Active")
	@Test
	public plainClosesAtOnce() {
		withMounted(400, 300, tipApp(), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			const popup = waitForShown(mounted.host);

			Assert.false(popup.Active, "Expected a plain Tooltip popup not to be Active");

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			Assert.true(fadesBy(popup, os.clock() + 0.5), "Expected a plain Tooltip to start fading right after MouseLeave");
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["MouseButton1"], ["Touch"]])
	@DisplayName("Without pinOnPress or longPress, a press neither opens the popup nor keeps it open after MouseLeave")
	@Test
	public plainPressNoop(kind: "MouseButton1" | "Touch") {
		withMounted(400, 300, tipApp(), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind));
			assertNoPopup(mounted.host, `Expected a ${kind} press not to open a plain Tooltip`);

			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			waitForShown(mounted.host);
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind));
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An interactive popup is Active and stays open while the pointer crosses from the trigger onto it")
	@Test
	public crossToPopup() {
		withMounted(400, 300, tipApp({ interactive: true }), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			const popup = waitForShown(mounted.host);

			Assert.true(popup.Active, "Expected an interactive Tooltip popup to be Active");

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			fireHostEvent(mounted, popup, "MouseEnter", 0, 0);
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected the popup to stay open while it is hovered");

			fireHostEvent(mounted, popup, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Once the pointer leaves an interactive tooltip it stays fully shown for the theme closeDelay, then fades")
	@Test
	public closeAfterDelay() {
		withMounted(400, 300, tipApp({ interactive: true }, DefaultTheme), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			const popup = waitForShown(mounted.host);

			const early = os.clock() + DefaultTheme.components.tooltip.closeDelay! * 0.6;
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			Assert.false(fadesBy(popup, early), "Expected no fade before closeDelay has elapsed");
			Assert.true(fadesBy(popup, os.clock() + 1), "Expected the popup to fade once closeDelay has elapsed");
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A ThemeProvider closeDelay override of 1s keeps an interactive popup open well past the default delay")
	@Test
	public themeCloseDelay() {
		const theme = extendTheme(FAST_THEME, { components: { tooltip: { closeDelay: 1 } } });

		withMounted(400, 300, tipApp({ interactive: true }, theme), (mounted) => {
			const trigger = waitForTrigger(mounted.host);
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0);
			waitForShown(mounted.host);

			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0);
			assertStaysShown(mounted.host, 0.6, "Expected the overridden closeDelay to keep the popup open");
			waitForRemoval(mounted.host, "Tooltip", 240);
		});
	}
}

export = TooltipHoverValidation;
