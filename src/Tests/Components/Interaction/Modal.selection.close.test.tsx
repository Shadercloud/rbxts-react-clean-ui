import { Test, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { withMounted } from "../../Helpers/layout";
import {
	MODAL_HOST_HEIGHT,
	MODAL_HOST_WIDTH,
	closeModal,
	modalSelectionApp,
	openModal,
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
class ModalCloseSelection {
	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("selectionMode=\"always\" hands the selection back to what was selected before the modal opened")
	@Test
	public alwaysRestores() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				const outside = waitForOutside(mounted);
				selectObject(outside);

				const opened = openModal(mounted, { mode: "always" });
				waitForSelection(opened.panel, "while the always modal is open");

				closeModal(mounted, { mode: "always" });

				waitForSelection(outside, "after closing the always modal");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("With the default selectionMode and no gamepad, a selection left inside the modal is cleared on close")
	@Test
	public defaultClearsInside() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				selectObject(waitForOutside(mounted));

				const opened = openModal(mounted, {});
				selectObject(opened.panel);

				closeModal(mounted, {});

				waitForSelection(undefined, "after closing a default modal holding the selection");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("With the default selectionMode and no gamepad, a selection outside the modal survives the close")
	@Test
	public defaultKeepsOutside() {
		withSelectionReset(() => {
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({ open: false }), (mounted) => {
				const outside = waitForOutside(mounted);
				selectObject(outside);

				openModal(mounted, {});
				closeModal(mounted, {});

				assertSelectionStays(outside, "after closing a default modal");
			});
		});
	}
}

export = ModalCloseSelection;
