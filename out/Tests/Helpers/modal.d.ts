import React from "@rbxts/react";
import { GamepadSelectionMode } from "../../Helpers/gamepad.helper";
import { MountedElement } from "./layout";
export declare const MODAL_HOST_WIDTH = 800;
export declare const MODAL_HOST_HEIGHT = 600;
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
export declare function modalSelectionApp(options: ModalSelectionCase): React.JSX.Element;
export declare function waitForOutside(mounted: MountedElement): Frame;
export declare function waitForOpenModal(mounted: MountedElement): OpenedModal;
export declare function openModal(mounted: MountedElement, options: Omit<ModalSelectionCase, "open">): OpenedModal;
export declare function closeModal(mounted: MountedElement, options: Omit<ModalSelectionCase, "open">): void;
