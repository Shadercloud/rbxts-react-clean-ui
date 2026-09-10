import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Switch } from "../../../Components/Input/Switch";
import { FieldsetContext } from "../../../Components/Layout";

@Tag("Studio")
class SwitchMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("Mounting with checked={true} fires onChange exactly once with true")
	@Test
	public seedsFromChecked() {
		const host = new Instance("Folder");

		const onChangeValues: boolean[] = [];

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Switch
				checked={true}
				onChange={(value) => {
					onChangeValues.push(value);
				}}
			/>,
		);

		task.wait();

		Assert.deepEqual(onChangeValues, [true]);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("Mounting without a checked prop fires onChange exactly once with false")
	@Test
	public defaultsUnchecked() {
		const host = new Instance("Folder");

		const onChangeValues: boolean[] = [];

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Switch
				onChange={(value) => {
					onChangeValues.push(value);
				}}
			/>,
		);

		task.wait();

		Assert.deepEqual(onChangeValues, [false]);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("Re-rendering with a flipped checked prop does not fire onChange again when uncontrolled")
	@Test
	public uncontrolledIgnoresProp() {
		const host = new Instance("Folder");

		const onChangeValues: boolean[] = [];

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Switch
				checked={false}
				onChange={(value) => {
					onChangeValues.push(value);
				}}
			/>,
		);
		task.wait();

		root.render(
			<Switch
				checked={true}
				onChange={(value) => {
					onChangeValues.push(value);
				}}
			/>,
		);
		task.wait();

		Assert.deepEqual(onChangeValues, [false]);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("Firing the Fieldset labelActivated event flips the switch and fires onChange with the new state")
	@Test
	public labelToggles() {
		const host = new Instance("Folder");
		const labelActivated = new Instance("BindableEvent");

		const onChangeValues: boolean[] = [];

		const root = ReactRoblox.createRoot(host);

		root.render(
			<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
				<Switch
					onChange={(value) => {
						onChangeValues.push(value);
					}}
				/>
			</FieldsetContext.Provider>,
		);

		task.wait();

		labelActivated.Fire();

		for (let attempt = 0; attempt < 10 && onChangeValues.size() < 2; attempt++) {
			task.wait();
		}

		Assert.deepEqual(onChangeValues, [false, true]);

		root.unmount();
		labelActivated.Destroy();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("A disabled switch ignores the Fieldset labelActivated event and never fires onChange beyond mount")
	@Test
	public disabledIgnoresLabel() {
		const host = new Instance("Folder");
		const labelActivated = new Instance("BindableEvent");

		const onChangeValues: boolean[] = [];

		const root = ReactRoblox.createRoot(host);

		root.render(
			<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
				<Switch
					disabled={true}
					onChange={(value) => {
						onChangeValues.push(value);
					}}
				/>
			</FieldsetContext.Provider>,
		);

		task.wait();

		labelActivated.Fire();

		for (let attempt = 0; attempt < 10; attempt++) {
			task.wait();
		}

		Assert.deepEqual(onChangeValues, [false]);

		root.unmount();
		labelActivated.Destroy();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("A disabled switch renders its track ImageButton with Active and Selectable both false")
	@Test
	public disabledTrackInert() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Switch disabled={true} />);
		task.wait();

		const track = host.FindFirstChildWhichIsA("ImageButton", true) as ImageButton | undefined;

		Assert.notUndefined(track);
		Assert.false(track!.Active);
		Assert.false(track!.Selectable);

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("The root instance is named \"Switch\" when no name prop is given")
	@Test
	public defaultName() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Switch />);
		task.wait();

		Assert.notUndefined(host.FindFirstChild("Switch"));

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("Passing a name prop renames the root instance and no \"Switch\" child remains")
	@Test
	public customName() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Switch name="MarketingOptIn" />);
		task.wait();

		Assert.notUndefined(host.FindFirstChild("MarketingOptIn"));
		Assert.undefined(host.FindFirstChild("Switch"));

		root.unmount();
		host.Destroy();
	}
}

export = SwitchMountValidation;
