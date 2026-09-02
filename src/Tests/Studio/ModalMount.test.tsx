import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Modal } from "../../Components/Interaction/Modal";
import { Button } from "../../Components/Input";
import { Card } from "../../Components/Surface";
import { GuiHelper } from "../../Helpers";
import { CleanUiProvider } from "../../Providers/app.provider";
import { DraggableRegistryKey, RegistryContext, RegistryContextValue } from "../../Providers";
import { DefaultTheme } from "../../Theme";
import { useModalClose } from "../../Contexts";

let latestRegistry: RegistryContextValue | undefined;

function RegistryHarness() {
	latestRegistry = React.useContext(RegistryContext);
	return undefined;
}

@Tag("Studio")
class ModalMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public rendersBackdropAndPanelWhenOpenInsideCleanUiProvider() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={true} />
			</CleanUiProvider>,
		);

		task.wait();

		Assert.notUndefined(host.FindFirstChildWhichIsA("ImageButton", true));
		Assert.notUndefined(host.FindFirstChild("Modal", true));

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={true} />
			</CleanUiProvider>,
		);

		task.wait();

		const backdrop = host.FindFirstChild("ModalBackdrop", true);
		const shield = host.FindFirstChild("ModalPanelInputShield", true);
		const panel = host.FindFirstChild("Modal", true);

		Assert.notUndefined(backdrop);
		Assert.notUndefined(shield);
		Assert.notUndefined(panel);
		Assert.true(backdrop!.IsA("ImageButton"));
		Assert.true(shield!.IsA("ImageButton"));

		const shieldButton = shield as ImageButton;

		Assert.true(shieldButton.Active);
		Assert.false(shieldButton.AutoButtonColor);
		Assert.equal(shieldButton.AutomaticSize, Enum.AutomaticSize.XY);
		Assert.equal(panel!.Parent, shield);
		Assert.true(shield!.IsDescendantOf(backdrop!));

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public resolvesPercentageAndScalePanelSizesAgainstTheOverlay() {
		const host = new Instance("Frame");
		host.Size = UDim2.fromOffset(800, 600);
		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={true} width="50%" height="40%" />
			</CleanUiProvider>,
		);

		task.wait();

		let shield = host.FindFirstChild("ModalPanelInputShield", true) as ImageButton | undefined;
		let panel = host.FindFirstChild("Modal", true) as GuiObject | undefined;

		Assert.notUndefined(shield);
		Assert.notUndefined(panel);
		Assert.equal(shield!.Size, UDim2.fromScale(0.5, 0.4));
		Assert.equal(panel!.Size, UDim2.fromScale(1, 1));
		Assert.true(shield!.AbsoluteSize.X > 0);
		Assert.true(shield!.AbsoluteSize.Y > 0);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={true} Size={UDim2.fromScale(0.25, 0.3)} />
			</CleanUiProvider>,
		);

		task.wait();

		shield = host.FindFirstChild("ModalPanelInputShield", true) as ImageButton | undefined;
		panel = host.FindFirstChild("Modal", true) as GuiObject | undefined;

		Assert.notUndefined(shield);
		Assert.notUndefined(panel);
		Assert.equal(shield!.Size, UDim2.fromScale(0.25, 0.3));
		Assert.equal(panel!.Size, UDim2.fromScale(1, 1));
		Assert.true(shield!.AbsoluteSize.X > 0);
		Assert.true(shield!.AbsoluteSize.Y > 0);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public defaultsToANonDraggableCenteredPanel() {
		const host = new Instance("Folder");
		latestRegistry = undefined;
		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<RegistryHarness />
				<Modal open={true}>
					<Card.Header />
				</Modal>
			</CleanUiProvider>,
		);

		task.wait();

		Assert.notUndefined(host.FindFirstChild("CenterLayout", true));
		Assert.notUndefined(latestRegistry);
		Assert.equal(latestRegistry!.getAll(DraggableRegistryKey).size(), 0);

		const header = host.FindFirstChild("CardHeader", true) as GuiObject | undefined;
		Assert.notUndefined(header);
		Assert.false(header!.Active);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public makesTheHeaderADragHandleAndRetainsTheDroppedPosition() {
		const host = new Instance("Folder");
		latestRegistry = undefined;
		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<RegistryHarness />
				<Modal open={true} draggable={true}>
					<Card.Header />
				</Modal>
			</CleanUiProvider>,
		);

		task.wait();

		Assert.undefined(host.FindFirstChild("CenterLayout", true));
		Assert.notUndefined(latestRegistry);

		const registrations = latestRegistry!.getAll(DraggableRegistryKey);
		Assert.equal(registrations.size(), 1);

		const registration = registrations[0];
		const header = host.FindFirstChild("CardHeader", true) as GuiObject | undefined;

		Assert.notUndefined(header);
		Assert.true(header!.Active);
		Assert.equal(registration.guiObject.AnchorPoint, new Vector2(0.5, 0.5));
		Assert.equal(registration.guiObject.Position, UDim2.fromScale(0.5, 0.5));

		const dragStart = { Position: new Vector3(10, 20, 0) } as unknown as InputObject;
		const dragEnd = { Position: new Vector3(40, 60, 0) } as unknown as InputObject;

		registration.draggable.beginDrag(dragStart, header!);
		registration.draggable.endDrag(dragEnd);

		Assert.equal(registration.guiObject.Position.X.Offset, 30);
		Assert.equal(registration.guiObject.Position.Y.Offset, 40);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public nestedHeaderButtonClosesWithoutStartingOrCommittingADrag() {
		const host = new Instance("Frame");
		host.Size = UDim2.fromOffset(800, 600);
		latestRegistry = undefined;
		const openChanges = new Array<boolean>();
		let activateClose: (() => void) | undefined;

		function CloseButton() {
			const close = useModalClose();
			activateClose = close;
			return <Button name="ModalCloseButton" text="Close" Event={{ Activated: close }} />;
		}

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<RegistryHarness />
				<Modal open={true} draggable={true} onOpenChange={(open) => openChanges.push(open)}>
					<Card.Header>
						<CloseButton />
					</Card.Header>
				</Modal>
			</CleanUiProvider>,
		);

		task.wait();

		const header = host.FindFirstChild("CardHeader", true) as GuiObject | undefined;
		const closeButton = host.FindFirstChild("ModalCloseButton", true) as GuiButton | undefined;

		Assert.notUndefined(header);
		Assert.notUndefined(closeButton);
		Assert.notUndefined(latestRegistry);
		Assert.notUndefined(activateClose);
		Assert.true(closeButton!.IsDescendantOf(header!));

		const registration = latestRegistry!.getAll(DraggableRegistryKey)[0];
		Assert.notUndefined(registration);

		const buttonPoint = closeButton!.AbsolutePosition.add(closeButton!.AbsoluteSize.div(2));
		const hitObjects = GuiHelper.getGuiObjectsAtPosition(header!, buttonPoint);
		Assert.true(hitObjects.some((guiObject) => guiObject === closeButton));

		const initialPosition = registration!.guiObject.Position;
		activateClose!();
		task.wait();

		Assert.deepEqual(openChanges, [false]);
		Assert.false(registration!.draggable.isDragging);
		Assert.equal(registration!.guiObject.Position, initialPosition);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal defaultOpen={true} />
			</CleanUiProvider>,
		);

		task.wait();

		Assert.notUndefined(host.FindFirstChild("Modal", true));

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={false} defaultOpen={true} />
			</CleanUiProvider>,
		);

		task.wait();

		Assert.undefined(host.FindFirstChild("Modal", true));

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal open={true} defaultOpen={true} />
			</CleanUiProvider>,
		);

		task.wait();

		Assert.notUndefined(host.FindFirstChild("Modal", true));

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal() {
		const host = new Instance("Folder");

		const onOpenChangeValues: boolean[] = [];
		let requestClose: (() => void) | undefined;

		function CloseHarness() {
			requestClose = useModalClose();
			return undefined;
		}

		const root = ReactRoblox.createRoot(host);

		root.render(
			<CleanUiProvider theme={DefaultTheme}>
				<Modal
					open={true}
					onOpenChange={(value) => {
						onOpenChangeValues.push(value);
					}}
				>
					<CloseHarness />
				</Modal>
			</CleanUiProvider>,
		);

		task.wait();

		Assert.notUndefined(requestClose);

		requestClose!();
		task.wait();

		Assert.deepEqual(onOpenChangeValues, [false]);
		Assert.notUndefined(host.FindFirstChild("Modal", true));

		root.unmount();
		host.Destroy();
	}
}

export = ModalMountValidation;
