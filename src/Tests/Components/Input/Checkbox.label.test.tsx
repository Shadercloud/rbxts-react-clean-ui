import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Checkbox } from "../../../Components/Input/Checkbox";
import { SpacingHelper } from "../../../Helpers";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import { activateButton } from "../../Helpers/fiber";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertStackedHorizontally,
	findDescendant,
	rect,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const LABEL_TEXT_COLOR = Color3.fromRGB(200, 60, 90);
const LABEL_GAP = 10;

const LABEL_THEME = extendTheme(DefaultTheme, {
	components: {
		checkbox: {
			label: {
				gap: LABEL_GAP,
				textColor: LABEL_TEXT_COLOR,
				typography: { size: Enum.FontSize.Size24 },
			},
		},
	},
});

function waitForRoot(host: Instance, name = "Checkbox"): Frame {
	return waitForGuiObject<Frame>(host, name);
}

function rowLayout(root: Instance): UIListLayout {
	const layout = root.FindFirstChildWhichIsA("UIListLayout");
	Assert.notUndefined(layout, `Expected ${root.Name} to have a direct UIListLayout`);
	return layout!;
}

function assertGap(root: Frame, expected: number, label: string) {
	const box = waitForGuiObject<ImageButton>(root, "CheckboxBox");
	const labelButton = waitForGuiObject<ImageButton>(root, "CheckboxLabel");

	Assert.equal(rowLayout(root).Padding, new UDim(0, expected), `${label}: UIListLayout.Padding`);
	Assert.true(
		math.abs(rect(labelButton).left - rect(box).right - expected) <= 1,
		`${label}: expected a ${expected}px gap, got ${rect(labelButton).left - rect(box).right}px`,
	);
}

@Tag("Studio")
class CheckboxLabelValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With a label the root is a transparent Frame holding CheckboxBox then CheckboxLabel in a row")
	@Test
	public labelTree() {
		withMounted(400, 200, <Checkbox label="Accept terms" />, (mounted) => {
			const root = waitForRoot(mounted.host);
			const box = waitForGuiObject<ImageButton>(root, "CheckboxBox");
			const labelButton = waitForGuiObject<ImageButton>(root, "CheckboxLabel");
			const text = waitForGuiObject<TextLabel>(labelButton, "CheckboxLabelText");
			const layout = rowLayout(root);

			Assert.equal(root.ClassName, "Frame");
			Assert.equal(root.BackgroundTransparency, 1);
			Assert.equal(root.AutomaticSize, Enum.AutomaticSize.XY);
			Assert.equal(box.Parent, root, "Expected CheckboxBox directly under the root");
			Assert.equal(labelButton.Parent, root, "Expected CheckboxLabel directly under the root");
			Assert.notUndefined(box.FindFirstChild("CheckboxIcon", true), "Expected the icon inside CheckboxBox");
			Assert.false(labelButton.Selectable, "Expected CheckboxLabel not to be gamepad-selectable");
			Assert.equal(labelButton.BackgroundTransparency, 1);
			Assert.equal(text.Text, "Accept terms");
			Assert.false(text.TextWrapped, "Expected the label text not to wrap");
			Assert.equal(layout.FillDirection, Enum.FillDirection.Horizontal);
			Assert.equal(layout.VerticalAlignment, Enum.VerticalAlignment.Center);
			Assert.false(layout.Wraps);
			assertStackedHorizontally([box, labelButton], "box then label");
			assertAllDescendantsContained(root, "labelled checkbox");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a label the root is the box ImageButton itself, with no CheckboxBox or CheckboxLabel")
	@Test
	public noLabelTree() {
		withMounted(400, 200, <Checkbox />, (mounted) => {
			const root = waitForGuiObject<ImageButton>(mounted.host, "Checkbox");

			Assert.equal(root.ClassName, "ImageButton");
			Assert.undefined(mounted.host.FindFirstChild("CheckboxBox", true));
			Assert.undefined(mounted.host.FindFirstChild("CheckboxLabel", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The name prop names the label-mode root Frame while the box keeps the CheckboxBox name")
	@Test
	public namedLabelRoot() {
		withMounted(400, 200, <Checkbox name="Terms" label="Accept terms" />, (mounted) => {
			const root = waitForRoot(mounted.host, "Terms");

			Assert.equal(root.ClassName, "Frame");
			Assert.notUndefined(root.FindFirstChild("CheckboxBox"));
			Assert.undefined(mounted.host.FindFirstChild("Checkbox", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clicking the label text toggles the checkbox exactly like clicking the box")
	@Test
	public labelClickToggles() {
		const values: boolean[] = [];

		withMounted(
			400,
			200,
			<Checkbox
				label="Accept terms"
				onChange={(value) => {
					values.push(value);
				}}
			/>,
			(mounted) => {
				const root = waitForRoot(mounted.host);
				const labelButton = waitForGuiObject<ImageButton>(root, "CheckboxLabel");
				const icon = findDescendant<ImageLabel>(root, "CheckboxIcon");

				activateButton(mounted, labelButton);
				Assert.deepEqual(values, [true]);
				Assert.true(icon.Image !== "", "Expected the check icon after clicking the label");

				activateButton(mounted, waitForGuiObject<ImageButton>(root, "CheckboxBox"));
				Assert.deepEqual(values, [true, false]);
				Assert.equal(icon.Image, "", "Expected no icon after clicking the box again");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Unthemed, the gap is half the checkbox spacing rounded up and the text uses the scale's typography and default colour")
	@Test
	public defaultLabelStyle() {
		const expectedGap = math.ceil(SpacingHelper.GetPadding(DefaultTheme, undefined, DefaultTheme.components.checkbox.spacing) / 2);
		const expectedSize = DefaultTheme.typography[DefaultTheme.typeScaleMap[DefaultTheme.default.scale]].size;

		withMounted(400, 200, <Checkbox label="Accept terms" />, (mounted) => {
			const root = waitForRoot(mounted.host);
			const text = waitForGuiObject<TextLabel>(root, "CheckboxLabelText");

			assertGap(root, expectedGap, "default gap");
			Assert.equal(text.FontSize, expectedSize, "default label FontSize");
			Assert.equal(text.TextColor3, DefaultTheme.colors.intents.primary.default.textColor, "default label colour");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("checkbox.label gap, textColor and typography from the theme reach the row and the label text")
	@Test
	public themedLabelStyle() {
		withMounted(
			400,
			200,
			<ThemeProvider theme={LABEL_THEME}>
				<Checkbox label="Accept terms" />
			</ThemeProvider>,
			(mounted) => {
				const root = waitForRoot(mounted.host);
				const text = waitForGuiObject<TextLabel>(root, "CheckboxLabelText");

				assertGap(root, LABEL_GAP, "themed gap");
				Assert.equal(text.FontSize, Enum.FontSize.Size24, "themed label FontSize");
				Assert.equal(text.TextColor3, LABEL_TEXT_COLOR, "themed label colour");
			},
		);
	}
}

export = CheckboxLabelValidation;
