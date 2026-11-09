import React from "@rbxts/react";

import { GamepadSelectionGuard } from "../../Components/Interaction/GamepadSelectionGuard";
import { Modal } from "../../Components/Interaction/Modal";
import { Text } from "../../Components/Typography/Text";
import { GamepadSelectionMode } from "../../Helpers/gamepad.helper";
import { ModalProvider } from "../../Providers/modal.provider";
import { OverlayProvider } from "../../Providers/overlay.provider";
import { RegistryProvider } from "../../Providers/registry.provider";
import { MountedElement, waitForGuiObject, waitForRemoval } from "./layout";

export const MODAL_HOST_WIDTH = 800;
export const MODAL_HOST_HEIGHT = 600;

export interface ModalSelectionCase {
	open: boolean;
	mode?: GamepadSelectionMode;
	focus?: React.RefObject<Frame>;
	guard?: boolean;
}

export interface OpenedModal {
	shield: ImageButton;
	panel: GuiObject;
}

export function modalSelectionApp(options: ModalSelectionCase) {
	const tree = (
		<ModalProvider>
			<frame key="Outside" Selectable={true} Size={UDim2.fromOffset(40, 40)} BackgroundTransparency={1} />
			<Modal open={options.open} selectionMode={options.mode} initialFocus={options.focus}>
				<Text text="Body" />
				{options.focus !== undefined && (
					<frame key="Focus" ref={options.focus} Selectable={true} Size={UDim2.fromOffset(40, 40)} BackgroundTransparency={1} />
				)}
			</Modal>
		</ModalProvider>
	);

	return (
		<RegistryProvider>
			<OverlayProvider>
				{options.guard === true ? <GamepadSelectionGuard>{tree}</GamepadSelectionGuard> : tree}
			</OverlayProvider>
		</RegistryProvider>
	);
}

export function waitForOutside(mounted: MountedElement): Frame {
	waitForGuiObject<Frame>(mounted.host, "OverlayProvider");
	return waitForGuiObject<Frame>(mounted.host, "Outside");
}

export function waitForOpenModal(mounted: MountedElement): OpenedModal {
	const shield = waitForGuiObject<ImageButton>(mounted.host, "ModalPanelInputShield");
	const panel = waitForGuiObject<GuiObject>(shield, "Modal");
	return { shield, panel };
}

export function openModal(mounted: MountedElement, options: Omit<ModalSelectionCase, "open">): OpenedModal {
	mounted.update(modalSelectionApp({ ...options, open: true }));
	return waitForOpenModal(mounted);
}

export function closeModal(mounted: MountedElement, options: Omit<ModalSelectionCase, "open">) {
	mounted.update(modalSelectionApp({ ...options, open: false }));
	waitForRemoval(mounted.host, "ModalBackdrop");
}
