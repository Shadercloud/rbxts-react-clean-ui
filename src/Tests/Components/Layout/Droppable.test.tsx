import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Droppable } from "../../../Components/Layout/Droppable";
import {
	DroppableRegistration,
	DroppableRegistryKey,
	RegistryContext,
	RegistryContextValue,
	RegistryProvider,
} from "../../../Providers/registry.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertSizeApprox,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const DROP_ID = "target";

let latestRegistry: RegistryContextValue | undefined;

function RegistryHarness() {
	latestRegistry = React.useContext(RegistryContext);
	return undefined;
}

function droppableFixture(onDrop?: (dragged: GuiObject) => void) {
	return (
		<RegistryProvider>
			<RegistryHarness />
			<Droppable id={DROP_ID} onDrop={onDrop}>
				<frame key="DropZone" Size={UDim2.fromOffset(120, 80)} BackgroundTransparency={1} />
			</Droppable>
		</RegistryProvider>
	);
}

function waitForDropZone(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "DropZone");
}

function waitForRegistration(dropZone: GuiObject): DroppableRegistration {
	return waitForLayout(
		() => latestRegistry?.get(dropZone, DroppableRegistryKey),
		"Timed out waiting for Droppable to register its child in the registry",
	);
}

@Tag("Studio")
class DroppableMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Renders its child in place with no wrapper, at the child's own size, inside the host")
	@Test
	public rendersChildUnwrapped() {
		latestRegistry = undefined;

		withMounted(400, 300, droppableFixture(), (mounted) => {
			const dropZone = waitForDropZone(mounted.host);

			Assert.equal(dropZone.Parent, mounted.host, "Expected the drop zone to be a direct child of the host (no wrapper)");
			assertSizeApprox(dropZone, 120, 80, 1, "drop zone");
			assertContained(dropZone, mounted.host, "drop zone vs host");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Registers its child under DroppableRegistryKey with its id, and the registration's drop() forwards the dragged object to onDrop")
	@Test
	public registersAndForwardsDrop() {
		latestRegistry = undefined;
		const dropped: GuiObject[] = [];

		withMounted(400, 300, droppableFixture((dragged) => dropped.push(dragged)), (mounted) => {
			const dropZone = waitForDropZone(mounted.host);
			const registration = waitForRegistration(dropZone);

			Assert.equal(registration.id, DROP_ID);
			Assert.equal(registration.guiObject, dropZone, "Expected the registration to point at the cloned child instance");

			const dragged = new Instance("Frame");
			registration.drop(dragged);

			Assert.equal(dropped.size(), 1, "Expected onDrop to fire exactly once");
			Assert.equal(dropped[0], dragged, "Expected onDrop to receive the dragged GuiObject unchanged");

			dragged.Destroy();
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Unmounting the Droppable removes its registry entry")
	@Test
	public unregistersOnUnmount() {
		latestRegistry = undefined;

		withMounted(400, 300, droppableFixture(), (mounted) => {
			const dropZone = waitForDropZone(mounted.host);
			waitForRegistration(dropZone);

			const registry = latestRegistry!;

			mounted.update(
				<RegistryProvider>
					<RegistryHarness />
					<frame key="Placeholder" Size={UDim2.fromOffset(10, 10)} BackgroundTransparency={1} />
				</RegistryProvider>,
			);

			waitForLayout(
				() => (registry.get(dropZone, DroppableRegistryKey) === undefined ? true : undefined),
				"Timed out waiting for the Droppable's registry entry to be removed after unmount",
			);
		});
	}
}

export = DroppableMountValidation;
