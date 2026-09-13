import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Input } from "../../../Components/Input/Input";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, withMounted } from "../../Helpers/layout";

const FIELD_FILL = Color3.fromRGB(41, 88, 150);

@Tag("Studio")
class InputMountValidation {
	@Skip(
		!Runtime.isRoblox(),
		"Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.",
	)
	@DisplayName("With Number validation, typing a letter reverts the TextBox and onChange to the last numeric text")
	@Test
	public rejectsInvalidChar() {
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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without theme background keys the root Input ImageLabel stays fully transparent")
	@Test
	public defaultTransparent() {
		withMounted(400, 200, <Input value="" />, (mounted) => {
			const root = waitForGuiObject<ImageLabel>(mounted.host, "Input");

			Assert.equal(root.BackgroundTransparency, 1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("theme.components.input backgroundColor and backgroundTransparency fill the root Input ImageLabel")
	@Test
	public themedBackground() {
		const theme = extendTheme(DefaultTheme, {
			components: { input: { backgroundColor: FIELD_FILL, backgroundTransparency: 0.25 } },
		});

		withMounted(
			400,
			200,
			<ThemeProvider theme={theme}>
				<Input value="" />
			</ThemeProvider>,
			(mounted) => {
				const root = waitForGuiObject<ImageLabel>(mounted.host, "Input");

				Assert.equal(root.BackgroundColor3, FIELD_FILL);
				Assert.equal(root.BackgroundTransparency, 0.25);
			},
		);
	}
}

export = InputMountValidation;
