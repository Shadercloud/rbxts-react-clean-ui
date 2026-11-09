import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { STUDIO_SKIP_MESSAGE, waitForRemoval, withMounted } from "../../Helpers/layout";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	assertNoPopup,
	assertStaysShown,
	coverApp,
	pressInput,
	waitForShown,
	waitForTrigger,
} from "../../Helpers/tooltip";

@Tag("Studio")
class TooltipCoverValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A trigger covered by a hovered interactive popup ignores MouseEnter, then opens once the popup is left")
	@Test
	public coveredIgnoresHover() {
		withMounted(400, 300, coverApp({ interactive: true }), (mounted) => {
			const cover = waitForTrigger(mounted.host, "CoverTrigger");
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0);
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);
			fireHostEvent(mounted, cover, "MouseLeave", 0, 0);

			fireHostEvent(mounted, under, "MouseEnter", 0, 0);
			assertNoPopup(mounted.host, "Expected a covered trigger not to open on MouseEnter", "UnderTip");

			fireHostEvent(mounted, coverPopup, "MouseLeave", 0, 0);
			waitForShown(mounted.host, "UnderTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An open hover-only tooltip closes once an interactive popup covering its trigger is hovered")
	@Test
	public coveredClosesOpen() {
		withMounted(400, 300, coverApp({ interactive: true }), (mounted) => {
			const cover = waitForTrigger(mounted.host, "CoverTrigger");
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			fireHostEvent(mounted, under, "MouseEnter", 0, 0);
			waitForShown(mounted.host, "UnderTip");

			fireHostEvent(mounted, cover, "MouseEnter", 0, 0);
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);
			waitForRemoval(mounted.host, "UnderTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A covered pinOnPress trigger ignores presses, and accepts them again once the covering popup is gone")
	@Test
	public coveredIgnoresPress() {
		withMounted(400, 300, coverApp({ interactive: true }, { pinOnPress: true }), (mounted) => {
			const cover = waitForTrigger(mounted.host, "CoverTrigger");
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0);
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);
			fireHostEvent(mounted, cover, "MouseLeave", 0, 0);

			fireHostEvent(mounted, under, "InputBegan", pressInput());
			assertNoPopup(mounted.host, "Expected a covered trigger to ignore a press", "UnderTip");

			fireHostEvent(mounted, coverPopup, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "CoverTip");
			fireHostEvent(mounted, under, "InputBegan", pressInput());
			waitForShown(mounted.host, "UnderTip");
			assertStaysShown(mounted.host, 0.2, "Expected an uncovered trigger to pin on press", "UnderTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A still-hovered covered trigger opens once the covering interactive tooltip hides because it was disabled")
	@Test
	public uncoverOnHide() {
		withMounted(400, 300, coverApp({ interactive: true }), (mounted) => {
			const cover = waitForTrigger(mounted.host, "CoverTrigger");
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0);
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);
			fireHostEvent(mounted, under, "MouseEnter", 0, 0);
			assertNoPopup(mounted.host, "Expected a covered trigger not to open on MouseEnter", "UnderTip");

			mounted.update(coverApp({ interactive: true, disabled: true }));
			waitForShown(mounted.host, "UnderTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A hovered non-interactive Center popup does not cover other triggers")
	@Test
	public centerDoesNotCover() {
		withMounted(400, 300, coverApp({ placement: "Center" }), (mounted) => {
			const cover = waitForTrigger(mounted.host, "CoverTrigger");
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			fireHostEvent(mounted, cover, "MouseEnter", 0, 0);
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);

			fireHostEvent(mounted, under, "MouseEnter", 0, 0);
			waitForShown(mounted.host, "UnderTip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A controlled open={true} interactive popup ignores interactive, so hovering it covers no other trigger")
	@Test
	public controlledNoCover() {
		withMounted(400, 300, coverApp({ open: true, interactive: true }), (mounted) => {
			const under = waitForTrigger(mounted.host, "UnderTrigger");
			const coverPopup = waitForShown(mounted.host, "CoverTip");
			fireHostEvent(mounted, coverPopup, "MouseEnter", 0, 0);

			fireHostEvent(mounted, under, "MouseEnter", 0, 0);
			waitForShown(mounted.host, "UnderTip");
		});
	}
}

export = TooltipCoverValidation;
