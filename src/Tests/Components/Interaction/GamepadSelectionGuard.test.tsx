import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { GamepadSelectionGuard } from "../../../Components/Interaction/GamepadSelectionGuard";
import { STUDIO_SKIP_MESSAGE, mountInScreenGui, waitForGuiObject, withMounted } from "../../Helpers/layout";
import {
	SELECTION_SKIP_MESSAGE,
	assertSelectionStays,
	selectObject,
	selectionUnavailable,
	waitForSelection,
	withSelectionReset,
} from "../../Helpers/selection";

function selectableTarget(name: string) {
	return <frame key={name} Selectable={true} Size={UDim2.fromOffset(40, 40)} BackgroundTransparency={1} />;
}

function guardApp(enabled: boolean) {
	return <GamepadSelectionGuard enabled={enabled}>{selectableTarget("Target")}</GamepadSelectionGuard>;
}

function waitForTarget(host: Instance, name = "Target"): Frame {
	return waitForGuiObject<Frame>(host, name);
}

@Tag("Studio")
class GamepadSelectionGuardClearing {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Renders its children unchanged with no instance of its own")
	@Test
	public rendersChildren() {
		withMounted(200, 200, guardApp(true), (mounted) => {
			const target = waitForTarget(mounted.host);

			Assert.equal(target.Parent, mounted.host, "Expected the child frame to sit directly under the host");
			Assert.equal(mounted.host.GetChildren().size(), 1, "Expected the guard to add no instances");
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("Turning the guard on clears a selection that already exists")
	@Test
	public clearsOnEnable() {
		withSelectionReset(() => {
			withMounted(200, 200, guardApp(false), (mounted) => {
				selectObject(waitForTarget(mounted.host));

				mounted.update(guardApp(true));

				waitForSelection(undefined, "after enabling the guard");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("A selection made while the guard is on is cleared a frame later")
	@Test
	public clearsLaterSelection() {
		withSelectionReset(() => {
			withMounted(200, 200, guardApp(true), (mounted) => {
				selectObject(waitForTarget(mounted.host));

				waitForSelection(undefined, "after selecting under an enabled guard");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("With enabled={false} a selection is left alone")
	@Test
	public disabledKeeps() {
		withSelectionReset(() => {
			withMounted(200, 200, guardApp(false), (mounted) => {
				const target = waitForTarget(mounted.host);
				selectObject(target);

				assertSelectionStays(target, "under a disabled guard");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("Switching the guard off stops it clearing selections made afterwards")
	@Test
	public disableDisconnects() {
		withSelectionReset(() => {
			withMounted(200, 200, guardApp(true), (mounted) => {
				const target = waitForTarget(mounted.host);

				mounted.update(guardApp(false));
				selectObject(target);

				assertSelectionStays(target, "after disabling the guard");
			});
		});
	}

	@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	@DisplayName("After the guard unmounts a new selection elsewhere is no longer cleared")
	@Test
	public unmountDisconnects() {
		withSelectionReset(() => {
			const guarded = mountInScreenGui(200, 200, guardApp(true));
			let guardedMounted = true;

			try {
				withMounted(200, 200, selectableTarget("Outside"), (other) => {
					const outside = waitForTarget(other.host, "Outside");
					waitForTarget(guarded.host);

					guarded.unmount();
					guardedMounted = false;

					selectObject(outside);

					assertSelectionStays(outside, "after the guard unmounted");
				});
			} finally {
				if (guardedMounted) guarded.unmount();
			}
		});
	}
}

export = GamepadSelectionGuardClearing;
