import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Modal } from "../../../Components/Interaction/Modal";
import { Text } from "../../../Components/Typography/Text";
import { ModalProvider } from "../../../Providers/modal.provider";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import { RegistryProvider } from "../../../Providers/registry.provider";
import {
	STUDIO_SKIP_MESSAGE,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 800;
const HOST_HEIGHT = 600;

function modalApp(modal: React.ReactElement) {
	return (
		<RegistryProvider>
			<OverlayProvider>
				<ModalProvider>{modal}</ModalProvider>
			</OverlayProvider>
		</RegistryProvider>
	);
}

@Tag("Studio")
class ModalSizeConstraint {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without min or max props the panel shield renders no UISizeConstraint")
	@Test
	public noConstraintWhenUnset() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			modalApp(
				<Modal open={true}>
					<Text text="Body" />
				</Modal>,
			),
			(mounted) => {
				const shield = waitForGuiObject<ImageButton>(mounted.host, "ModalPanelInputShield");

				Assert.equal(sizeConstraintsOf(shield).size(), 0);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A maxWidth below the theme's modal width clamps the input shield and the panel Card together")
	@Test
	public shieldClamped() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			modalApp(
				<Modal open={true} maxWidth={240}>
					<Text text="Body" />
				</Modal>,
			),
			(mounted) => {
				const shield = waitForGuiObject<ImageButton>(mounted.host, "ModalPanelInputShield");
				const panel = waitForGuiObject<GuiObject>(shield, "Modal");

				Assert.equal(soleSizeConstraint(shield).MaxSize.X, 240);
				waitForWidth(shield, 240);
				waitForWidth(panel, 240);
			},
		);
	}
}

export = ModalSizeConstraint;
