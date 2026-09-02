import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag } from "@rbxts/lunit";

const { Skip } = Decorators;
import { ModalProvider } from "../../Providers/modal.provider";
import { ModalStackContextValue, ModalStackLayer, useModalStack } from "../../Contexts";

let latestStack: ModalStackContextValue | undefined;

function StackHarness() {
	latestStack = useModalStack();
	return undefined;
}

function noopLayer(id: string): ModalStackLayer {
	return {
		id,
		closeOnEscape: () => true,
		requestClose: () => {},
	};
}

@Tag("Studio")
class ModalStackProviderValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public registeringLayersAssignsIncreasingIndicesInRegistrationOrder() {
		const host = new Instance("Folder");
		latestStack = undefined;

		const root = ReactRoblox.createRoot(host);

		root.render(
			<ModalProvider>
				<StackHarness />
			</ModalProvider>,
		);

		task.wait();

		Assert.notUndefined(latestStack);

		latestStack!.register(noopLayer("a"));
		task.wait();
		latestStack!.register(noopLayer("b"));
		task.wait();
		latestStack!.register(noopLayer("c"));
		task.wait();

		Assert.equal(latestStack!.getLayerIndex("a"), 0);
		Assert.equal(latestStack!.getLayerIndex("b"), 1);
		Assert.equal(latestStack!.getLayerIndex("c"), 2);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public getLayerIndexReturnsNegativeOneForAnUnregisteredId() {
		const host = new Instance("Folder");
		latestStack = undefined;

		const root = ReactRoblox.createRoot(host);

		root.render(
			<ModalProvider>
				<StackHarness />
			</ModalProvider>,
		);

		task.wait();

		Assert.notUndefined(latestStack);
		Assert.equal(latestStack!.getLayerIndex("missing"), -1);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public unregisteringALayerRemovesItAndShiftsSubsequentIndicesDown() {
		const host = new Instance("Folder");
		latestStack = undefined;

		const root = ReactRoblox.createRoot(host);

		root.render(
			<ModalProvider>
				<StackHarness />
			</ModalProvider>,
		);

		task.wait();

		latestStack!.register(noopLayer("a"));
		task.wait();
		latestStack!.register(noopLayer("b"));
		task.wait();
		latestStack!.register(noopLayer("c"));
		task.wait();

		latestStack!.unregister("a");
		task.wait();

		Assert.equal(latestStack!.getLayerIndex("a"), -1);
		Assert.equal(latestStack!.getLayerIndex("b"), 0);
		Assert.equal(latestStack!.getLayerIndex("c"), 1);

		root.unmount();
		host.Destroy();
	}
}

export = ModalStackProviderValidation;
