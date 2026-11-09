import React from "@rbxts/react";
import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { withMounted } from "../../Helpers/layout";
import {
	MODAL_HOST_HEIGHT,
	MODAL_HOST_WIDTH,
	modalSelectionApp,
	openModal,
	waitForOpenModal,
	waitForOutside,
} from "../../Helpers/modal";
import {
	SELECTION_SKIP_MESSAGE,
	assertSelectionStays,
	selectObject,
	selectionUnavailable,
	waitForSelection,
	withSelectionReset,
} from "../../Helpers/selection";

@Tag("Studio")
class ModalOpenSelection {
	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("With the default selectionMode and no gamepad, opening selects nothing")
	@Test
	public defaultSelectsNothing() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				waitForOutside(mounted);
				openModal(mounted, {});

				assertSelectionStays(undefined, "after opening a default modal");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("With the default selectionMode and no gamepad, a selection outside the modal is left alone on open")
	@Test
	public defaultKeepsOutside() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				const outside = waitForOutside(mounted);
				selectObject(outside);

				openModal(mounted, {});

				assertSelectionStays(outside, "after opening a default modal");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("selectionMode=\"always\" moves the selection to the panel Card on open whatever the input")
	@Test
	public alwaysSelectsPanel() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				selectObject(waitForOutside(mounted));

				const opened = openModal(mounted, { mode: "always" });

				waitForSelection(opened.panel, "after opening an always modal");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("selectionMode=\"always\" with initialFocus selects that element instead of the panel")
	@Test
	public alwaysSelectsInitialFocus() {
		const focus = React.createRef<Frame>();

		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false, focus }), (mounted) => {
				waitForOutside(mounted);

				openModal(mounted, { mode: "always", focus });

				Assert.notUndefined(focus.current, "Expected the initialFocus frame to be mounted");
				waitForSelection(focus.current, "after opening an always modal with initialFocus");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("selectionMode=\"always\" selects the panel even when the modal mounts already open next to a new OverlayProvider")
	@Test
	public alwaysSelectsMountedOpen() {
		withSelectionReset(() => {
			withMounted(
				MODAL_HOST_WIDTH,
				MODAL_HOST_HEIGHT,
				modalSelectionApp({ open: true, mode: "always" }),
				(mounted) => {
					const opened = waitForOpenModal(mounted);

					waitForSelection(opened.panel, "after mounting an always modal open");
				},
			);
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("A GamepadSelectionGuard clears the panel selection an always modal takes for a non-gamepad player")
	@Test
	public guardBeatsAlways() {
		withSelectionReset(() => {
			withMounted(
				MODAL_HOST_WIDTH,
				MODAL_HOST_HEIGHT,
				modalSelectionApp({ open: false, guard: true }),
				(mounted) => {
					waitForOutside(mounted);

					openModal(mounted, { mode: "always", guard: true });

					waitForSelection(undefined, "after opening an always modal under a guard");
					assertSelectionStays(undefined, "while the guarded always modal stays open");
				},
			);
		});
	}
}

export = ModalOpenSelection;
