import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Modal } from "../../Components/Interaction/Modal";
import { Button } from "../../Components/Input/Button";
import { Card } from "../../Components/Surface/Card";
import { OverlayContext } from "../../Contexts/overlay.context";
import { useModalClose } from "../../Contexts/modal.context";
import { GuiHelper } from "../../Helpers/gui.helper";
import { ModalProvider } from "../../Providers/modal.provider";
import {
	DraggableRegistryKey,
	RegistryContext,
	RegistryContextValue,
	RegistryProvider,
} from "../../Providers/registry.provider";
import { ThemeProvider } from "../../Providers/theme.provider";
import { DefaultTheme } from "../../Theme";

let latestRegistry: RegistryContextValue | undefined;

function RegistryHarness() {
	latestRegistry = React.useContext(RegistryContext);
	return undefined;
}

function waitForValue<T extends defined>(resolve: () => T | undefined, failureMessage: string): T {
	for (let attempt = 0; attempt < 30; attempt++) {
		const value = resolve();

		if (value !== undefined) {
			return value;
		}

		task.wait();
	}

	return Assert.fail(failureMessage);
}

function waitForCondition(resolve: () => boolean, failureMessage: string) {
	waitForValue(() => (resolve() ? true : undefined), failureMessage);
}

function waitForDescendant<T extends Instance>(host: Instance, name: string, failureMessage: string): T {
	return waitForValue(() => host.FindFirstChild(name, true) as T | undefined, failureMessage);
}

function createTestRoot(host: Instance) {
	Assert.notUndefined(RegistryProvider, "Expected direct registry.provider import to export RegistryProvider");
	Assert.notUndefined(ThemeProvider, "Expected direct theme.provider import to export ThemeProvider");
	Assert.notUndefined(ModalProvider, "Expected direct modal.provider import to export ModalProvider");
	Assert.notUndefined(OverlayContext, "Expected direct overlay.context import to export OverlayContext");
	Assert.notUndefined(OverlayContext.Provider, "Expected OverlayContext to expose its React Provider element type");

	const renderHost = new Instance("Folder");
	renderHost.Name = "ReactRenderHost";
	renderHost.Parent = host;

	const overlay = new Instance("Frame");
	overlay.Name = "TestOverlay";
	overlay.Size = UDim2.fromScale(1, 1);
	overlay.BackgroundTransparency = 1;
	overlay.Parent = host;

	const root = ReactRoblox.createRoot(renderHost);
	let renderGeneration = 0;

	return {
		render: (children: React.ReactNode) => {
			renderGeneration++;
			const probeName = `ReactCommitProbe-${renderGeneration}`;

			root.render(
				<RegistryProvider>
					<ThemeProvider theme={DefaultTheme}>
						<OverlayContext.Provider value={{ overlay }}>
							<ModalProvider>
								<frame key={probeName} />
								{children}
							</ModalProvider>
						</OverlayContext.Provider>
					</ThemeProvider>
				</RegistryProvider>,
			);
			waitForDescendant(
				renderHost,
				probeName,
				`Timed out waiting for createRoot().render() to commit ${probeName} into ReactRenderHost`,
			);
		},
		unmount: () => {
			root.unmount();
			waitForCondition(
				() => renderHost.GetChildren().size() === 0 && overlay.GetChildren().size() === 0,
				"Timed out waiting for the React root and Modal portal to unmount",
			);
			overlay.Destroy();
			renderHost.Destroy();
		},
	};
}

@Tag("Studio")
class ModalMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public rendersBackdropAndPanelWithExplicitModalProviders() {
		const host = new Instance("Folder");

		const root = createTestRoot(host);

		root.render(
			<>
				<Modal open={true} />
			</>,
		);

		waitForDescendant(
			host,
			"ModalBackdrop",
			"Expected Modal to portal ModalBackdrop into the explicit TestOverlay",
		);
		waitForDescendant(host, "Modal", "Expected the Modal Card inside the portal");

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

		const root = createTestRoot(host);

		root.render(
			<>
				<Modal open={true} />
			</>,
		);

		const backdrop = waitForDescendant(host, "ModalBackdrop", "Expected ModalBackdrop after the portal commit");
		const shield = waitForDescendant(
			host,
			"ModalPanelInputShield",
			"Expected ModalPanelInputShield inside ModalBackdrop",
		);
		const panel = waitForDescendant(host, "Modal", "Expected the Modal Card inside its input shield");
		Assert.true(backdrop!.IsA("ImageButton"));
		Assert.true(shield!.IsA("ImageButton"));

		const shieldButton = shield as ImageButton;

		Assert.true(shieldButton.Active);
		Assert.false(shieldButton.AutoButtonColor);
		Assert.equal(shieldButton.AutomaticSize, Enum.AutomaticSize.Y);
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
		const root = createTestRoot(host);

		root.render(
			<>
				<Modal open={true} width="50%" height="40%" />
			</>,
		);

		let shield = waitForDescendant<ImageButton>(
			host,
			"ModalPanelInputShield",
			"Expected the percentage-sized ModalPanelInputShield",
		);
		let panel = waitForDescendant<GuiObject>(host, "Modal", "Expected the percentage-sized Modal Card");
		Assert.equal(shield!.Size, UDim2.fromScale(0.5, 0.4));
		Assert.equal(panel!.Size, UDim2.fromScale(1, 1));
		Assert.true(shield!.AbsoluteSize.X > 0);
		Assert.true(shield!.AbsoluteSize.Y > 0);

		root.render(
			<>
				<Modal open={true} Size={UDim2.fromScale(0.25, 0.3)} />
			</>,
		);

		shield = waitForDescendant<ImageButton>(
			host,
			"ModalPanelInputShield",
			"Expected the scale-sized ModalPanelInputShield after rerender",
		);
		panel = waitForDescendant<GuiObject>(host, "Modal", "Expected the scale-sized Modal Card after rerender");
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
		const root = createTestRoot(host);

		root.render(
			<>
				<RegistryHarness />
				<Modal open={true}>
					<Card.Header />
				</Modal>
			</>,
		);

		waitForDescendant(host, "CenterLayout", "Expected default Modal centering layout");
		const registry = waitForValue(() => latestRegistry, "Expected RegistryHarness to publish RegistryContext");
		Assert.equal(registry.getAll(DraggableRegistryKey).size(), 0);

		const header = waitForDescendant<GuiObject>(host, "CardHeader", "Expected the non-draggable CardHeader");
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
		const root = createTestRoot(host);

		root.render(
			<>
				<RegistryHarness />
				<Modal open={true} draggable={true}>
					<Card.Header />
				</Modal>
			</>,
		);

		Assert.undefined(host.FindFirstChild("CenterLayout", true));
		const registry = waitForValue(() => latestRegistry, "Expected RegistryHarness to publish RegistryContext");
		const registrations = waitForValue(() => {
			const current = registry.getAll(DraggableRegistryKey);
			return current.size() === 1 ? current : undefined;
		}, "Expected one draggable Modal registration");

		const registration = registrations[0];
		const header = waitForDescendant<GuiObject>(
			host,
			"CardHeader",
			"Expected CardHeader to render as the drag handle",
		);
		Assert.true(header!.Active);
		Assert.equal(registration.guiObject.AnchorPoint, new Vector2(0.5, 0.5));
		Assert.equal(registration.guiObject.Position, UDim2.fromScale(0.5, 0.5));

		const dragStart = { Position: new Vector3(10, 20, 0) } as unknown as InputObject;
		const dragEnd = { Position: new Vector3(40, 60, 0) } as unknown as InputObject;

		registration.draggable.beginDrag(dragStart, header);
		registration.draggable.endDrag(dragEnd);
		waitForCondition(
			() => registration.guiObject.Position.X.Offset === 30 && registration.guiObject.Position.Y.Offset === 40,
			"Expected retained draggable position to reach the 30px, 40px drop offset",
		);

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

		const root = createTestRoot(host);

		root.render(
			<>
				<RegistryHarness />
				<Modal open={true} draggable={true} onOpenChange={(open) => openChanges.push(open)}>
					<Card.Header>
						<CloseButton />
					</Card.Header>
				</Modal>
			</>,
		);

		const header = waitForDescendant<GuiObject>(
			host,
			"CardHeader",
			"Expected CardHeader around the nested close button",
		);
		const closeButton = waitForDescendant<GuiButton>(
			host,
			"ModalCloseButton",
			"Expected the nested ModalCloseButton",
		);
		const registry = waitForValue(() => latestRegistry, "Expected RegistryHarness to publish RegistryContext");
		const close = waitForValue(() => activateClose, "Expected CloseButton to capture useModalClose()");
		Assert.true(closeButton!.IsDescendantOf(header!));

		const registration = waitForValue(
			() => registry.getAll(DraggableRegistryKey)[0],
			"Expected draggable Modal registration",
		);

		const buttonPoint = closeButton!.AbsolutePosition.add(closeButton!.AbsoluteSize.div(2));
		const hitObjects = GuiHelper.getGuiObjectsAtPosition(header!, buttonPoint);
		Assert.true(hitObjects.some((guiObject) => guiObject === closeButton));

		const initialPosition = registration!.guiObject.Position;
		close();
		waitForCondition(() => openChanges.size() === 1, "Expected nested close button to publish onOpenChange(false)");

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

		const root = createTestRoot(host);

		root.render(
			<>
				<Modal defaultOpen={true} />
			</>,
		);

		waitForDescendant(host, "Modal", "Expected defaultOpen Modal Card in the portal");

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

		const root = createTestRoot(host);

		root.render(
			<>
				<Modal open={false} defaultOpen={true} />
			</>,
		);

		Assert.undefined(host.FindFirstChild("Modal", true));

		root.render(
			<>
				<Modal open={true} defaultOpen={true} />
			</>,
		);

		waitForDescendant(host, "Modal", "Expected controlled Modal Card after open changed to true");

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

		const root = createTestRoot(host);

		root.render(
			<>
				<Modal
					open={true}
					onOpenChange={(value) => {
						onOpenChangeValues.push(value);
					}}
				>
					<CloseHarness />
				</Modal>
			</>,
		);

		const close = waitForValue(() => requestClose, "Expected CloseHarness to capture useModalClose()");

		close();
		waitForCondition(
			() => onOpenChangeValues.size() === 1,
			"Expected modal close request to publish onOpenChange(false)",
		);

		Assert.deepEqual(onOpenChangeValues, [false]);
		waitForDescendant(host, "Modal", "Expected controlled Modal to remain rendered until its open prop changes");

		root.unmount();
		host.Destroy();
	}
}

export = ModalMountValidation;
