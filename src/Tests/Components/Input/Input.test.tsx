import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Input } from "../../../Components/Input/Input";
import { FieldsetContext } from "../../../Components/Layout";
import { CssBoxShadow, CssShadow } from "../../../Interfaces";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, ThemeTemplate, extendTheme } from "../../../Theme";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	MountedElement,
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const FIELD_FILL = Color3.fromRGB(41, 88, 150);
const BASE_BORDER = Color3.fromRGB(61, 39, 18);
const HOVER_BORDER = Color3.fromRGB(120, 200, 80);
const FOCUS_BORDER = Color3.fromRGB(242, 166, 90);
const DISABLED_BORDER = Color3.fromRGB(128, 128, 128);
const SHADOW_COLOR = Color3.fromRGB(10, 20, 30);
const LIP_COLOR = Color3.fromRGB(168, 122, 69);
const INK = Color3.fromRGB(0, 0, 0);

const STATE_THEME = extendTheme(DefaultTheme, {
	components: {
		input: {
			borderColor: BASE_BORDER,
			borderThickness: 1,
			backgroundColor: FIELD_FILL,
			backgroundTransparency: 0.5,
			states: {
				hover: { borderColor: HOVER_BORDER, backgroundTransparency: 0.75 },
				focus: { borderColor: FOCUS_BORDER, borderThickness: 3 },
				disabled: { borderColor: DISABLED_BORDER, backgroundTransparency: 0.25 },
			},
		},
	},
});

function themedInput(theme: ThemeTemplate, disabled?: boolean) {
	return (
		<ThemeProvider theme={theme}>
			<Input value="" disabled={disabled} />
		</ThemeProvider>
	);
}

function inputTheme(overrides: Partial<ThemeTemplate["components"]["input"]>, boxShadow?: ThemeTemplate["components"]["boxShadow"]) {
	return extendTheme(DefaultTheme, { components: { input: overrides, boxShadow } });
}

function waitForInput(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Input");
}

function inputStroke(root: Instance): UIStroke {
	const stroke = root.FindFirstChild("Stroke") as UIStroke | undefined;
	Assert.notUndefined(stroke, "Expected a Stroke UIStroke directly under the Input root");
	return stroke!;
}

function assertFieldLook(root: ImageLabel, borderColor: Color3, thickness: number, transparency: number, label: string) {
	const stroke = inputStroke(root);
	Assert.equal(stroke.Color, borderColor, `${label}: border colour`);
	Assert.equal(stroke.Thickness, thickness, `${label}: border thickness`);
	Assert.equal(root.BackgroundTransparency, transparency, `${label}: background transparency`);
}

function focusTextBox(mounted: MountedElement, root: Instance) {
	fireHostEvent(mounted, findDescendant<TextBox>(root, "TextBox"), "Focused");
}

function blurTextBox(mounted: MountedElement, root: Instance) {
	fireHostEvent(mounted, findDescendant<TextBox>(root, "TextBox"), "FocusLost", false, undefined);
}

function waitForMeasuredBand(root: Instance, size: number): Frame {
	return waitForGuiObject<Frame>(
		root,
		"InnerShadow",
		(band) => {
			if (!band.Visible || band.AbsoluteSize.Y <= 0) return false;
			const fade = band.FindFirstChild("Fade") as UIGradient | undefined;
			const keypoints = fade?.Transparency.Keypoints;
			return keypoints !== undefined && keypoints.size() === 3 && math.abs(keypoints[1].Time - size / band.AbsoluteSize.Y) < 0.002;
		},
		"Timed out waiting for the InnerShadow band to measure its height and fade over its size",
	);
}

function zeroShadow(form: string): CssShadow | CssBoxShadow {
	return form === "string" ? "0px 0px 0px 0px" : { shadow: "0px 0px 0px 0px", color: SHADOW_COLOR, transparency: 0 };
}

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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without boxShadow, innerShadow or states the TextBox's FlexItem sits directly under the root with no Content wrapper, shadow or band")
	@Test
	public unsetTreeUnchanged() {
		withMounted(400, 200, <Input value="" />, (mounted) => {
			const root = waitForInput(mounted.host);
			const textBox = findDescendant<TextBox>(root, "TextBox");

			Assert.undefined(root.FindFirstChild("Content"));
			Assert.undefined(root.FindFirstChild("InnerShadow", true));
			Assert.undefined(root.FindFirstChildWhichIsA("UIShadow", true));
			Assert.equal(textBox.Parent?.Name, "FlexItem");
			Assert.equal(textBox.Parent?.Parent, root);
			assertFieldLook(root, DefaultTheme.components.input.borderColor, DefaultTheme.components.input.borderThickness, 1, "unset theme");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A bare CssShadow string draws a root UIShadow with that offset and blur in the global boxShadow colour and transparency")
	@Test
	public stringShadow() {
		const theme = inputTheme({ boxShadow: "0px 2px 4px 0px" }, { color: SHADOW_COLOR, transparency: 0.5 });

		withMounted(400, 200, themedInput(theme), (mounted) => {
			const root = waitForInput(mounted.host);
			const shadow = root.FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Input root");
			Assert.equal(shadow!.Color, SHADOW_COLOR);
			Assert.equal(shadow!.Transparency, 0.5);
			Assert.equal(shadow!.Offset, UDim2.fromOffset(0, 2));
			Assert.equal(shadow!.BlurRadius, new UDim(0, 4));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A { shadow, color, transparency } boxShadow uses its own colour and transparency instead of the global boxShadow ones")
	@Test
	public tableShadow() {
		const theme = inputTheme(
			{ boxShadow: { shadow: "0px 1px 0px 0px", color: LIP_COLOR, transparency: 0 } },
			{ color: SHADOW_COLOR, transparency: 0.5 },
		);

		withMounted(400, 200, themedInput(theme), (mounted) => {
			const root = waitForInput(mounted.host);
			const shadow = root.FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Input root");
			Assert.equal(shadow!.Color, LIP_COLOR);
			Assert.equal(shadow!.Transparency, 0);
			Assert.equal(shadow!.Offset, UDim2.fromOffset(0, 1));
			Assert.equal(shadow!.BlurRadius, new UDim(0, 0));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["string"], ["table"]])
	@DisplayName("An all-zero boxShadow, as a string or a table, draws no UIShadow at all")
	@Test
	public zeroShadowNothing(form: string) {
		withMounted(400, 200, themedInput(inputTheme({ boxShadow: zeroShadow(form) })), (mounted) => {
			const root = waitForInput(mounted.host);

			Assert.undefined(root.FindFirstChildWhichIsA("UIShadow", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("innerShadow adds a coloured InnerShadow band inset by the border and a ZIndex 2 Content wrapper holding the text above it")
	@Test
	public innerShadowBand() {
		const theme = inputTheme({ borderThickness: 2, cornerRadius: 8, innerShadow: { color: INK, transparency: 0.5, size: 8 } });

		withMounted(400, 200, themedInput(theme), (mounted) => {
			const root = waitForInput(mounted.host);
			const content = root.FindFirstChild("Content") as Frame | undefined;

			Assert.notUndefined(content, "Expected a Content frame directly under the Input root");
			Assert.equal(content!.ZIndex, 2);
			Assert.equal(content!.BackgroundTransparency, 1);
			Assert.true(findDescendant<TextBox>(root, "TextBox").IsDescendantOf(content!));

			const band = waitForMeasuredBand(root, 8);

			Assert.equal(band.Parent, root);
			Assert.true(band.ZIndex < content!.ZIndex, `Expected the band ZIndex (${band.ZIndex}) under Content's (${content!.ZIndex})`);
			Assert.equal(band.BackgroundColor3, INK);
			Assert.equal(band.BackgroundTransparency, 0);
			Assert.equal(band.Position, UDim2.fromOffset(2, 2));
			Assert.equal(band.Size, new UDim2(1, -4, 1, -4));
			Assert.equal((band.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 6));

			const fade = band.FindFirstChild("Fade") as UIGradient;
			const keypoints = fade.Transparency.Keypoints;

			Assert.equal(fade.Rotation, 90);
			Assert.equal(keypoints[0].Time, 0);
			Assert.equal(keypoints[0].Value, 0.5);
			Assert.approximately(keypoints[1].Time, 8 / band.AbsoluteSize.Y, 0.002);
			Assert.equal(keypoints[1].Value, 1);
			Assert.equal(keypoints[2].Value, 1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The InnerShadow inset and corner radius follow the focus state's borderThickness while the TextBox is focused")
	@Test
	public bandFollowsBorder() {
		const theme = inputTheme({
			borderThickness: 2,
			cornerRadius: 8,
			innerShadow: { color: INK, transparency: 0.5, size: 8 },
			states: { focus: { borderThickness: 4 } },
		});

		withMounted(400, 200, themedInput(theme), (mounted) => {
			const root = waitForInput(mounted.host);
			const band = waitForMeasuredBand(root, 8);

			Assert.equal(band.Position, UDim2.fromOffset(2, 2));

			focusTextBox(mounted, root);

			Assert.equal(band.Position, UDim2.fromOffset(4, 4));
			Assert.equal(band.Size, new UDim2(1, -8, 1, -8));
			Assert.equal((band.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 4));
			Assert.equal(inputStroke(root).Thickness, 4);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("MouseEnter applies states.hover's border colour and transparency, keeps the base thickness, and MouseLeave restores the base")
	@Test
	public hoverState() {
		withMounted(400, 200, themedInput(STATE_THEME), (mounted) => {
			const root = waitForInput(mounted.host);

			assertFieldLook(root, BASE_BORDER, 1, 0.5, "before hover");

			fireHostEvent(mounted, root, "MouseEnter", 0, 0);
			assertFieldLook(root, HOVER_BORDER, 1, 0.75, "hovered");
			Assert.equal(root.BackgroundColor3, FIELD_FILL);

			fireHostEvent(mounted, root, "MouseLeave", 0, 0);
			assertFieldLook(root, BASE_BORDER, 1, 0.5, "after hover");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Focusing the TextBox applies states.focus's border and falls back to the base transparency, and FocusLost restores the base")
	@Test
	public focusState() {
		withMounted(400, 200, themedInput(STATE_THEME), (mounted) => {
			const root = waitForInput(mounted.host);

			focusTextBox(mounted, root);
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "focused");

			blurTextBox(mounted, root);
			assertFieldLook(root, BASE_BORDER, 1, 0.5, "blurred");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The disabled prop applies states.disabled's border colour and transparency over the base thickness")
	@Test
	public disabledState() {
		withMounted(400, 200, themedInput(STATE_THEME, true), (mounted) => {
			const root = waitForInput(mounted.host);

			assertFieldLook(root, DISABLED_BORDER, 1, 0.25, "disabled");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Hovered and focused shows only focus with no hover keys cascading, and disabled beats both until it is cleared")
	@Test
	public statePriority() {
		withMounted(400, 200, themedInput(STATE_THEME), (mounted) => {
			const root = waitForInput(mounted.host);

			fireHostEvent(mounted, root, "MouseEnter", 0, 0);
			focusTextBox(mounted, root);
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "hovered and focused");

			mounted.update(themedInput(STATE_THEME, true));
			assertFieldLook(root, DISABLED_BORDER, 1, 0.25, "disabled while hovered and focused");

			mounted.update(themedInput(STATE_THEME, false));
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "re-enabled while hovered and focused");

			blurTextBox(mounted, root);
			assertFieldLook(root, HOVER_BORDER, 1, 0.75, "hovered only");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A disabled Input's TextBox is neither editable nor interactable")
	@Test
	public disabledNotEditable() {
		withMounted(400, 200, <Input value="" disabled />, (mounted) => {
			const textBox = findDescendant<TextBox>(waitForInput(mounted.host), "TextBox");

			Assert.false(textBox.TextEditable);
			Assert.false(textBox.Interactable);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without disabled the TextBox stays interactable and an explicit TextEditable={false} still passes through")
	@Test
	public enabledPassesEditable() {
		withMounted(400, 200, <Input value="" TextEditable={false} />, (mounted) => {
			const textBox = findDescendant<TextBox>(waitForInput(mounted.host), "TextBox");

			Assert.false(textBox.TextEditable);
			Assert.true(textBox.Interactable);

			mounted.update(<Input value="" />);

			Assert.true(textBox.TextEditable);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Setting disabled on a focused Input releases the TextBox's focus")
	@Test
	public disabledReleasesFocus() {
		withMounted(400, 200, <Input value="" />, (mounted) => {
			const textBox = findDescendant<TextBox>(waitForInput(mounted.host), "TextBox");

			textBox.CaptureFocus();
			waitForLayout(() => (textBox.IsFocused() ? true : undefined), "Timed out waiting for CaptureFocus to focus the TextBox");

			mounted.update(<Input value="" disabled />);

			waitForLayout(() => (!textBox.IsFocused() ? true : undefined), "Expected disabling the Input to release the TextBox's focus");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Fieldset labelActivated does not focus a disabled Input, but does once disabled is cleared")
	@Test
	public disabledIgnoresLabel() {
		const labelActivated = new Instance("BindableEvent");
		const fieldsetInput = (disabled: boolean) => (
			<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
				<Input value="" disabled={disabled} />
			</FieldsetContext.Provider>
		);

		try {
			withMounted(400, 200, fieldsetInput(true), (mounted) => {
				const textBox = findDescendant<TextBox>(waitForInput(mounted.host), "TextBox");

				labelActivated.Fire();
				settleFrames(5);
				Assert.false(textBox.IsFocused(), "Expected a disabled Input to ignore labelActivated");

				mounted.update(fieldsetInput(false));
				labelActivated.Fire();

				waitForLayout(() => (textBox.IsFocused() ? true : undefined), "Timed out waiting for labelActivated to focus the re-enabled Input");
				textBox.ReleaseFocus();
			});
		} finally {
			labelActivated.Destroy();
		}
	}
}

export = InputMountValidation;
