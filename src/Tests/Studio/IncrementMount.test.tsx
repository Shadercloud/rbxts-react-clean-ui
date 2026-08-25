import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Increment } from "../../Components/Input/Increment";

@Tag("Studio")
class IncrementMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public seedsDisplayedTextFromInitialValueWhenUncontrolled() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Increment value={5} />);

		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);
		Assert.equal(textBox!.Text, "5");

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public uncontrolledStateIgnoresSubsequentValueProps() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Increment value={5} />);
		task.wait();

		root.render(<Increment value={8} />);
		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);
		Assert.equal(textBox!.Text, "5");

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public controlledStateReflectsUpdatedValueProp() {
		const host = new Instance("Folder");

		const root = ReactRoblox.createRoot(host);

		root.render(<Increment value={5} controlled={true} />);
		task.wait();

		root.render(<Increment value={8} controlled={true} />);
		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);
		Assert.equal(textBox!.Text, "8");

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit() {
		const host = new Instance("Folder");

		let latestOnChangeValue: number | undefined;

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Increment
				value={5}
				min={0}
				max={10}
				onChange={(value) => {
					latestOnChangeValue = value;
				}}
			/>,
		);

		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);

		textBox!.Text = "50";
		task.wait();

		Assert.equal(latestOnChangeValue, 50);
		Assert.equal(textBox!.Text, "50");

		root.unmount();
		host.Destroy();
	}

	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange() {
		const host = new Instance("Folder");

		let latestOnChangeValue: number | undefined;

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Increment
				value={5}
				min={0}
				max={10}
				onChange={(value) => {
					latestOnChangeValue = value;
				}}
			/>,
		);

		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);

		textBox!.Text = "50";
		task.wait();

		textBox!.CaptureFocus();
		textBox!.ReleaseFocus(true);
		task.wait();

		Assert.equal(latestOnChangeValue, 10);
		Assert.equal(textBox!.Text, "10");

		root.unmount();
		host.Destroy();
	}
}

export = IncrementMountValidation;
