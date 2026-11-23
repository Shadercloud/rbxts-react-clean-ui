import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { UiScaleRoot } from "../../../Components/Layout/UiScaleRoot";
import { Tooltip } from "../../../Components/Interaction/Tooltip";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import { ThemeProvider } from "../../../Providers/theme.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertCenteredIn,
	findDescendant,
	formatRect,
	rect,
	settleFrames,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";
import { FAST_THEME } from "../../Helpers/tooltip";

const HOST_WIDTH = 600;
const HOST_HEIGHT = 450;

type Placement = "outside" | "inside" | "none";

function tooltip() {
	return (
		<Tooltip content="Scaled hint" placement="Bottom" open={true}>
			<frame
				key="ScaledTrigger"
				BackgroundTransparency={1}
				Size={UDim2.fromOffset(100, 40)}
				Position={UDim2.fromOffset(150, 60)}
			/>
		</Tooltip>
	);
}

function app(placement: Placement, scale: number) {
	if (placement === "outside") {
		return (
			<ThemeProvider theme={FAST_THEME}>
				<OverlayProvider>
					<UiScaleRoot scale={scale}>{tooltip()}</UiScaleRoot>
				</OverlayProvider>
			</ThemeProvider>
		);
	}

	if (placement === "inside") {
		return (
			<ThemeProvider theme={FAST_THEME}>
				<UiScaleRoot scale={scale}>
					<OverlayProvider>{tooltip()}</OverlayProvider>
				</UiScaleRoot>
			</ThemeProvider>
		);
	}

	return (
		<ThemeProvider theme={FAST_THEME}>
			<OverlayProvider>{tooltip()}</OverlayProvider>
		</ThemeProvider>
	);
}

function waitForAlignedPopup(host: Instance): { popup: CanvasGroup; trigger: Frame; overlay: Frame } {
	const overlay = waitForGuiObject<Frame>(host, "OverlayProvider");
	const trigger = waitForGuiObject<Frame>(host, "ScaledTrigger");
	const popup = waitForGuiObject<CanvasGroup>(overlay, "Tooltip");

	for (let attempt = 0; attempt < 60; attempt++) {
		const popupRect = rect(popup);
		const triggerRect = rect(trigger);

		if (
			popup.GroupTransparency < 1 &&
			math.abs(popupRect.centerX - triggerRect.centerX) <= 1.5 &&
			popupRect.top >= triggerRect.bottom - 1
		) {
			break;
		}

		task.wait();
	}

	return { popup, trigger, overlay };
}

function assertBelowAndCentered(popup: CanvasGroup, trigger: Frame, label: string) {
	const popupRect = rect(popup);
	const triggerRect = rect(trigger);

	assertCenteredIn(popup, trigger, "x", 1.5, label);
	Assert.true(
		popupRect.top >= triggerRect.bottom - 1,
		`${label}: expected the popup ${formatRect(popupRect)} to sit below the trigger ${formatRect(triggerRect)}`,
	);
}

@Tag("Studio")
class UiScaleOverlayValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1.25], [1.5]])
	@DisplayName("With the OverlayProvider outside the root, the popup is wrapped in a UiScaleOverlay at the root's scale")
	@Test
	public wrapsOutsideRoot(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("outside", scale), (mounted) => {
			const { popup, overlay } = waitForAlignedPopup(mounted.host);
			const wrapper = popup.FindFirstAncestor("UiScaleOverlay");

			Assert.notUndefined(wrapper, "Expected the popup to sit inside a UiScaleOverlay wrapper");
			Assert.equal(wrapper!.Parent, overlay, "Expected the UiScaleOverlay wrapper directly under the overlay");

			const uiScale = findDescendant<UIScale>(wrapper!, "UiScale");
			Assert.equal(uiScale.Parent, wrapper, "Expected the wrapper's own UiScale directly under it");
			Assert.equal(uiScale.Scale, scale, "Expected the wrapper to scale by the root's scale over the overlay's scale of 1");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1.25], [1.5]])
	@DisplayName("With the OverlayProvider outside the root, the wrapped popup still lines up below and centred on its scaled trigger")
	@Test
	public alignsOutsideRoot(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("outside", scale), (mounted) => {
			const { popup, trigger } = waitForAlignedPopup(mounted.host);

			Assert.true(
				math.abs(trigger.AbsoluteSize.X - 100 * scale) <= 0.5,
				`Expected the trigger to render at ${100 * scale}px on screen, got ${trigger.AbsoluteSize.X}`,
			);
			assertBelowAndCentered(popup, trigger, `outside root at ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1.25], [1.5]])
	@DisplayName("With the OverlayProvider inside the root, no UiScaleOverlay is rendered and the popup still lines up")
	@Test
	public noWrapperInsideRoot(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("inside", scale), (mounted) => {
			const { popup, trigger } = waitForAlignedPopup(mounted.host);
			settleFrames(2);

			Assert.undefined(mounted.host.FindFirstChild("UiScaleOverlay", true), "Expected no UiScaleOverlay inside the root");
			assertBelowAndCentered(popup, trigger, `inside root at ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no UiScaleRoot at all, the popup portals straight into the overlay without a wrapper")
	@Test
	public noWrapperWithoutRoot() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("none", 1), (mounted) => {
			const { popup, trigger, overlay } = waitForAlignedPopup(mounted.host);
			settleFrames(2);

			Assert.undefined(mounted.host.FindFirstChild("UiScaleOverlay", true), "Expected no UiScaleOverlay without a root");
			Assert.undefined(popup.FindFirstAncestor("UiScaleOverlay"), "Expected the popup not to be wrapped");
			Assert.true(popup.IsDescendantOf(overlay), "Expected the popup to be portalled into the overlay");
			assertBelowAndCentered(popup, trigger, "no root");
		});
	}
}

export = UiScaleOverlayValidation;
