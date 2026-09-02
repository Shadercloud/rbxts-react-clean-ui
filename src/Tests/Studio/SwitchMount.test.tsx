import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Switch } from "../../Components/Input/Switch";
import { FieldsetContext } from "../../Components/Layout";

@Tag("Studio")
class SwitchMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public seedsCheckedStateFromInitialPropAndFiresOnMountWithIt() {
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
	@Test
	public defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted() {
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
	@Test
	public uncontrolledStateIgnoresSubsequentCheckedProp() {
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
	@Test
	public activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange() {
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
	@Test
	public disabledSuppressesTheFieldsetLabelBridgeAndOnChange() {
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
	@Test
	public disabledMarksTheTrackNonInteractive() {
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
	@Test
	public defaultsInstanceNameToSwitchWhenNamePropIsOmitted() {
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
	@Test
	public namePropOverridesTheRenderedInstanceName() {
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
