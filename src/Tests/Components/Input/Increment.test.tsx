import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Increment } from "../../../Components/Input/Increment";

@Tag("Studio")
class IncrementMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("The TextBox shows the initial value prop as its text on first mount")
	@Test
	public seedsFromValue() {
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
	@DisplayName("Re-rendering with a new value prop does not change the text when uncontrolled")
	@Test
	public uncontrolledIgnoresProp() {
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
	@DisplayName("Re-rendering with a new value prop updates the text when controlled")
	@Test
	public controlledFollowsProp() {
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
	@DisplayName("Typing a number above max fires onChange with the raw number and leaves the text unclamped while editing")
	@Test
	public typingSkipsClamp() {
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
}

export = IncrementMountValidation;
