import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Draggable } from "../../../Components/Layout/Draggable";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import {
	DraggableRegistration,
	DraggableRegistryKey,
	RegistryContext,
	RegistryContextValue,
	RegistryProvider,
} from "../../../Providers/registry.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertSizeApprox,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const DRAG_ID = "item";

type HandleEvents = NonNullable<React.InstanceProps<Frame>["Event"]>;

let latestRegistry: RegistryContextValue | undefined;

function RegistryHarness() {
	latestRegistry = React.useContext(RegistryContext);
	return undefined;
}

let handleEvents: HandleEvents | undefined;

const DragHandle = React.forwardRef<Frame, React.InstanceProps<Frame>>((props, ref) => {
	handleEvents = props.Event;

	return (
		<frame
			key="DragHandle"
			ref={ref}
			Active={props.Active}
			BackgroundTransparency={1}
			Size={new UDim2(1, 0, 0, 24)}
			Event={props.Event}
		/>
	);
});

function draggableFixture(onStartDrag?: () => void, onDropped?: () => void) {
	return (
		<RegistryProvider>
			<OverlayProvider>
				<RegistryHarness />
				<Draggable id={DRAG_ID} onStartDrag={onStartDrag} onDropped={onDropped}>
					<frame key="DragItem" Size={UDim2.fromOffset(160, 90)} BackgroundTransparency={1}>
						<Draggable.Handle>
							<DragHandle />
						</Draggable.Handle>
					</frame>
				</Draggable>
			</OverlayProvider>
		</RegistryProvider>
	);
}

function waitForDragItem(host: Instance): Frame {
	waitForGuiObject<Frame>(host, "OverlayProvider");
	return waitForGuiObject<Frame>(host, "DragItem");
}

function waitForRegistration(dragItem: GuiObject): DraggableRegistration {
	return waitForLayout(
		() => latestRegistry?.get(dragItem, DraggableRegistryKey),
		"Timed out waiting for Draggable to register its root in the registry",
	);
}

function fakeInput(position: Vector2): InputObject {
	return {
		Position: new Vector3(position.X, position.Y, 0),
		UserInputType: Enum.UserInputType.MouseButton1,
	} as unknown as InputObject;
}

@Tag("Studio")
class DraggableMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Idle, the child renders in place with no wrapper or placeholder, visible, at its own size, inside the host")
	@Test
	public rendersChildInPlace() {
		latestRegistry = undefined;
		handleEvents = undefined;

		withMounted(400, 300, draggableFixture(), (mounted) => {
			const dragItem = waitForDragItem(mounted.host);

			Assert.equal(dragItem.Parent, mounted.host, "Expected the dragged element to be a direct child of the host (no wrapper)");
			Assert.true(dragItem.Visible, "Expected the original to be visible while not dragging");
			Assert.undefined(mounted.host.FindFirstChild("DraggablePlaceholder", true), "Expected no placeholder while not dragging");

			assertSizeApprox(dragItem, 160, 90, 1, "drag item");
			assertContained(dragItem, mounted.host, "drag item vs host");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Draggable.Handle marks its child Active and injects an InputBegan handler, without touching the root element")
	@Test
	public handleIsActive() {
		latestRegistry = undefined;
		handleEvents = undefined;

		withMounted(400, 300, draggableFixture(), (mounted) => {
			const dragItem = waitForDragItem(mounted.host);
			const handle = findDescendant<Frame>(dragItem, "DragHandle");

			Assert.equal(handle.Parent, dragItem, "Expected the handle to stay a direct child of the drag item");
			Assert.true(handle.Active, "Expected Draggable.Handle to clone its child with Active=true");
			Assert.false(dragItem.Active, "Expected the root element's own Active to be left at its default");

			const events = waitForLayout(() => handleEvents, "Timed out waiting for Draggable.Handle to inject its Event table");
			Assert.notUndefined(events.InputBegan, "Expected Draggable.Handle to inject an InputBegan handler");

			assertContained(handle, dragItem, "handle vs drag item");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Registers its root under DraggableRegistryKey with its id and an idle (not dragging) draggable")
	@Test
	public registersInRegistry() {
		latestRegistry = undefined;
		handleEvents = undefined;

		withMounted(400, 300, draggableFixture(), (mounted) => {
			const dragItem = waitForDragItem(mounted.host);
			const registration = waitForRegistration(dragItem);

			Assert.equal(registration.id, DRAG_ID);
			Assert.equal(registration.guiObject, dragItem, "Expected the registration to point at the cloned root instance");
			Assert.false(registration.draggable.isDragging, "Expected a freshly mounted Draggable not to report itself as dragging");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A press on the handle starts a drag (placeholder shown, original hidden, preview in the overlay) and releasing ends it")
	@Test
	public dragLifecycle() {
		latestRegistry = undefined;
		handleEvents = undefined;
		let startCount = 0;
		let dropCount = 0;

		withMounted(
			400,
			300,
			draggableFixture(
				() => {
					startCount++;
				},
				() => {
					dropCount++;
				},
			),
			(mounted) => {
				const dragItem = waitForDragItem(mounted.host);
				const registration = waitForRegistration(dragItem);
				const handle = findDescendant<Frame>(dragItem, "DragHandle");
				const events = waitForLayout(() => handleEvents, "Timed out waiting for Draggable.Handle to inject its Event table");
				const overlay = findDescendant<Frame>(mounted.host, "OverlayProvider");

				const pressPoint = handle.AbsolutePosition.add(handle.AbsoluteSize.div(2));
				events.InputBegan!(handle, fakeInput(pressPoint));

				Assert.equal(startCount, 1, "Expected onStartDrag to fire once when the drag begins");
				Assert.true(registration.draggable.isDragging, "Expected the registration to report an active drag");

				const placeholder = waitForGuiObject<Frame>(mounted.host, "DraggablePlaceholder");
				waitForLayout(() => (!dragItem.Visible ? true : undefined), "Timed out waiting for the original to hide while dragging");
				const preview = waitForLayout(
					() => overlay.FindFirstChild("DragItem") as Frame | undefined,
					"Timed out waiting for the drag preview to be portalled into the overlay",
				);

				Assert.equal(placeholder.Parent, mounted.host, "Expected the placeholder to sit where the original does");
				assertSizeApprox(placeholder, 160, 90, 1, "placeholder");
				Assert.true(preview.Visible, "Expected the preview clone to be visible");
				assertSizeApprox(preview, 160, 90, 1, "drag preview");

				registration.draggable.endDrag(fakeInput(pressPoint.add(new Vector2(30, 20))));

				Assert.equal(dropCount, 1, "Expected onDropped to fire once when the drag ends");
				Assert.false(registration.draggable.isDragging, "Expected the registration to report the drag as over");

				waitForLayout(() => (dragItem.Visible ? true : undefined), "Timed out waiting for the original to reappear after the drop");
				waitForLayout(
					() => (mounted.host.FindFirstChild("DraggablePlaceholder", true) === undefined ? true : undefined),
					"Timed out waiting for the placeholder to be removed after the drop",
				);
				waitForLayout(
					() => (overlay.FindFirstChild("DragItem") === undefined ? true : undefined),
					"Timed out waiting for the preview to leave the overlay after the drop",
				);
				Assert.equal(dragItem.Position, UDim2.fromOffset(0, 0), "Expected the original to keep its Position without retainPosition");
			},
		);
	}
}

export = DraggableMountValidation;
