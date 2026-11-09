import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { HoverButton } from "../../../Components/Input/HoverButton";
import { Tooltip } from "../../../Components/Interaction/Tooltip";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { activateButton, fireHostEvent } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, waitForRemoval, withMounted } from "../../Helpers/layout";
import { FAST_THEME, assertNoPopup, waitForShown } from "../../Helpers/tooltip";

interface ActivationLog {
	count: number;
}

function hoverButtonTip(log: ActivationLog) {
	return (
		<ThemeProvider theme={FAST_THEME}>
			<OverlayProvider>
				<Tooltip content="Helpful hint">
					<HoverButton
						name="TipButton"
						default={{
							Size: UDim2.fromOffset(100, 40),
							Position: UDim2.fromOffset(150, 130),
							Event: {
								Activated: () => {
									log.count += 1;
								},
							},
						}}
					/>
				</Tooltip>
			</OverlayProvider>
		</ThemeProvider>
	);
}

function waitForTipButton(host: Instance): ImageButton {
	waitForGuiObject<Frame>(host, "OverlayProvider");
	return waitForGuiObject<ImageButton>(host, "TipButton");
}

@Tag("Studio")
class TooltipHoverButtonValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A Tooltip wrapping a bare HoverButton opens on the button's MouseEnter and closes on its MouseLeave")
	@Test
	public opensOnHover() {
		withMounted(400, 300, hoverButtonTip({ count: 0 }), (mounted) => {
			const button = waitForTipButton(mounted.host);

			assertNoPopup(mounted.host, "Expected no popup before the HoverButton is hovered");

			fireHostEvent(mounted, button, "MouseEnter", 0, 0);
			waitForShown(mounted.host);

			fireHostEvent(mounted, button, "MouseLeave", 0, 0);
			waitForRemoval(mounted.host, "Tooltip");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The wrapped HoverButton's own default.Event.Activated still fires exactly once per activation")
	@Test
	public keepsOwnActivated() {
		const log = { count: 0 };

		withMounted(400, 300, hoverButtonTip(log), (mounted) => {
			const button = waitForTipButton(mounted.host);

			activateButton(mounted, button);
			Assert.equal(log.count, 1);

			fireHostEvent(mounted, button, "MouseEnter", 0, 0);
			waitForShown(mounted.host);
			activateButton(mounted, button);
			Assert.equal(log.count, 2, "Expected Activated to still fire while the tooltip is open");
		});
	}
}

export = TooltipHoverButtonValidation;
