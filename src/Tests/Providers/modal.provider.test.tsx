import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, DisplayName, Runtime, Tag } from "@rbxts/lunit";

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
	@DisplayName("Each newly registered layer receives the next index in the stack")
	@Test
	public registerOrder() {
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
	@DisplayName("Looking up an id that was never registered yields -1")
	@Test
	public unknownId() {
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
	@DisplayName("Removing the bottom layer shifts the remaining layers down by one")
	@Test
	public unregisterShift() {
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
