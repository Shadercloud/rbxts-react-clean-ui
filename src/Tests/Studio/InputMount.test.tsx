import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Input } from "../../Components/Input/Input";

class InputMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@Test
	public typingAnInvalidCharacterKeepsLastValidNumber() {
		const host = new Instance("Folder");

		let latestOnChangeValue = "";

		const root = ReactRoblox.createRoot(host);

		root.render(
			<Input
				value=""
				validation="Number"
				onChange={(value) => {
					latestOnChangeValue = value;
				}}
			/>,
		);

		task.wait();

		const textBox = host.FindFirstChildWhichIsA("TextBox", true) as TextBox | undefined;

		Assert.notUndefined(textBox);

		for (const candidate of ["1", "12", "123", "123A"]) {
			textBox!.Text = candidate;
			task.wait();
		}

		Assert.equal(textBox!.Text, "123");
		Assert.equal(latestOnChangeValue, "123");

		root.unmount();
		host.Destroy();
	}
}

export = InputMountValidation;
