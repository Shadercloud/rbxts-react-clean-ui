import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Select } from "../../../Components/Input/Select";
import { FieldsetContext } from "../../../Components/Layout";
import { SpacingHelper } from "../../../Helpers";
import { CssBoxShadow, CssShadow } from "../../../Interfaces";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, ThemeTemplate, extendTheme } from "../../../Theme";
import { activateButton, fireHostEvent } from "../../Helpers/fiber";
import {
	MountedElement,
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertNonZeroSize,
	findDescendant,
	rect,
	settleFrames,
	waitForGuiObject,
	waitForLayout,
	waitForRemoval,
	withMounted,
} from "../../Helpers/layout";

const OPTIONS = ["Alpha", "Beta", "Gamma"];

function selectWithOptions(props: { selected?: number } = {}) {
	return (
		<Select selected={props.selected}>
			{OPTIONS.map((text) => (
				<Select.Option key={text} text={text} />
			))}
		</Select>
	);
}

const FIELD_FILL = Color3.fromRGB(41, 88, 150);
const FIELD_TEXT = Color3.fromRGB(255, 247, 207);
const CARET_COLOR = Color3.fromRGB(200, 60, 90);
const BASE_BORDER = Color3.fromRGB(61, 39, 18);
const HOVER_BORDER = Color3.fromRGB(120, 200, 80);
const FOCUS_BORDER = Color3.fromRGB(242, 166, 90);
const DISABLED_BORDER = Color3.fromRGB(128, 128, 128);
const SHADOW_COLOR = Color3.fromRGB(10, 20, 30);
const LIP_COLOR = Color3.fromRGB(168, 122, 69);
const INK = Color3.fromRGB(0, 0, 0);
const CAP_FILL = Color3.fromRGB(23, 58, 102);
const CAP_BORDER = Color3.fromRGB(90, 50, 20);
const DROP_BORDER = Color3.fromRGB(30, 140, 160);

const STATE_THEME = extendTheme(DefaultTheme, {
	components: {
		select: {
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

function themedSelect(theme: ThemeTemplate) {
	return <ThemeProvider theme={theme}>{selectWithOptions()}</ThemeProvider>;
}

function waitForSelect(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Select");
}

function findSelectedText(selectRoot: Instance): TextLabel {
	return findDescendant<TextLabel>(selectRoot, "SelectedText");
}

function selectTheme(overrides: Partial<ThemeTemplate["components"]["select"]>, boxShadow?: ThemeTemplate["components"]["boxShadow"]) {
	return extendTheme(DefaultTheme, { components: { select: overrides, boxShadow } });
}

function overlaySelect(theme: ThemeTemplate, props: { disabled?: boolean; BackgroundTransparency?: number } = {}) {
	return (
		<ThemeProvider theme={theme}>
			<OverlayProvider>
				<Select disabled={props.disabled} BackgroundTransparency={props.BackgroundTransparency}>
					{OPTIONS.map((text) => (
						<Select.Option key={text} text={text} />
					))}
				</Select>
			</OverlayProvider>
		</ThemeProvider>
	);
}

function selectButton(selectRoot: Instance): ImageButton {
	return waitForGuiObject<ImageButton>(selectRoot, "SelectButton");
}

function fieldStroke(selectRoot: Instance): UIStroke {
	const stroke = selectButton(selectRoot).FindFirstChild("Stroke") as UIStroke | undefined;
	Assert.notUndefined(stroke, "Expected a Stroke UIStroke directly under SelectButton");
	return stroke!;
}

function assertFieldLook(selectRoot: ImageLabel, borderColor: Color3, thickness: number, transparency: number, label: string) {
	const stroke = fieldStroke(selectRoot);
	Assert.equal(stroke.Color, borderColor, `${label}: border colour`);
	Assert.equal(stroke.Thickness, thickness, `${label}: border thickness`);
	Assert.equal(selectRoot.BackgroundTransparency, transparency, `${label}: background transparency`);
}

function openDropdown(mounted: MountedElement, selectRoot: Instance): Frame {
	waitForGuiObject<Frame>(mounted.host, "OverlayProvider");
	activateButton(mounted, selectButton(selectRoot));
	return waitForGuiObject<Frame>(mounted.host, "SelectDropdown");
}

function zeroShadow(form: string): CssShadow | CssBoxShadow {
	return form === "string" ? "0px 0px 0px 0px" : { shadow: "0px 0px 0px 0px", color: SHADOW_COLOR, transparency: 0 };
}

function fieldPaddingY(theme: ThemeTemplate): number {
	const padding = SpacingHelper.GetResolvedPadding(theme, {});
	return padding.top + padding.bottom;
}

function capInset(theme: ThemeTemplate): number {
	return fieldPaddingY(theme) - 2 * theme.components.select.borderThickness;
}

function caretColorTheme(source: string) {
	if (source === "caret") return selectTheme({ iconColor: FIELD_TEXT, caret: { size: 24, iconColor: CARET_COLOR } });
	if (source === "select") return selectTheme({ iconColor: FIELD_TEXT, caret: { size: 24 } });
	return selectTheme({ caret: { size: 24 } });
}

function expectedCaretColor(source: string): Color3 {
	if (source === "caret") return CARET_COLOR;
	if (source === "select") return FIELD_TEXT;
	return DefaultTheme.colors.intents.primary.default.textColor;
}

@Tag("Studio")
class SelectMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With three options and no selected prop, the closed control shows the first option and stays self-contained")
	@Test
	public mountsContained() {
		withMounted(400, 200, selectWithOptions(), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			assertNonZeroSize(selectRoot, "closed selectRoot");
			Assert.equal(findSelectedText(selectRoot).Text, "Alpha");
			assertAllDescendantsContained(selectRoot, "closed selectRoot");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("selected={2} seeds the closed control with the third option's text")
	@Test
	public seedsFromSelected() {
		withMounted(400, 200, selectWithOptions({ selected: 2 }), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(findSelectedText(selectRoot).Text, "Gamma");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no Select.Option children the closed control falls back to \"No Options\"")
	@Test
	public noOptionsFallback() {
		withMounted(400, 200, <Select />, (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(findSelectedText(selectRoot).Text, "No Options");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Firing the Fieldset labelActivated event opens the dropdown directly below the control with every option inside it, and firing again closes it")
	@Test
	public labelTogglesDropdown() {
		const labelActivated = new Instance("BindableEvent");

		try {
			withMounted(
				400,
				400,
				<OverlayProvider>
					<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
						{selectWithOptions()}
					</FieldsetContext.Provider>
				</OverlayProvider>,
				(mounted) => {
					const selectRoot = waitForSelect(mounted.host);
					const control = waitForGuiObject<ImageButton>(selectRoot, "SelectButton");
					waitForGuiObject<Frame>(mounted.host, "OverlayProvider");

					Assert.undefined(mounted.host.FindFirstChild("SelectDropdown", true));

					labelActivated.Fire();

					const dropdown = waitForGuiObject<Frame>(mounted.host, "SelectDropdown");

					const controlRect = rect(control);
					const dropdownRect = rect(dropdown);
					Assert.true(
						math.abs(dropdownRect.top - controlRect.bottom) <= 1,
						`Expected the dropdown top (${dropdownRect.top}) to sit at the control's bottom edge (${controlRect.bottom})`,
					);
					Assert.true(
						math.abs(dropdownRect.width - controlRect.width) <= 1,
						`Expected the dropdown width (${dropdownRect.width}) to match the control width (${controlRect.width})`,
					);

					waitForLayout(() => {
						const options = dropdown.GetDescendants().filter((d) => d.Name === "Option" && d.IsA("GuiObject"));
						return options.size() === OPTIONS.size() && options.every((o) => (o as GuiObject).AbsoluteSize.Y > 0) ? true : undefined;
					}, `Timed out waiting for ${OPTIONS.size()} laid-out options inside the dropdown`);

					assertAllDescendantsContained(dropdown, "open dropdown");

					labelActivated.Fire();

					waitForLayout(
						() => (mounted.host.FindFirstChild("SelectDropdown", true) === undefined ? true : undefined),
						"Timed out waiting for the dropdown to close after a second labelActivated",
					);
				},
			);
		} finally {
			labelActivated.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without theme background keys the Select root stays transparent and carries no root Corners")
	@Test
	public defaultTransparent() {
		withMounted(400, 200, selectWithOptions(), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(selectRoot.BackgroundTransparency, 1);
			Assert.undefined(selectRoot.FindFirstChild("Corners"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A themed backgroundColor with backgroundTransparency below 1 fills the root and rounds it with the theme cornerRadius")
	@Test
	public themedBackground() {
		const theme = extendTheme(DefaultTheme, {
			components: { select: { backgroundColor: FIELD_FILL, backgroundTransparency: 0.5, cornerRadius: 6 } },
		});

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(selectRoot.BackgroundColor3, FIELD_FILL);
			Assert.equal(selectRoot.BackgroundTransparency, 0.5);

			const corners = selectRoot.FindFirstChild("Corners") as UICorner | undefined;
			Assert.notUndefined(corners, "Expected a Corners UICorner directly under the Select root");
			Assert.equal(corners!.CornerRadius, new UDim(0, 6));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An instance BackgroundTransparency beats the theme fill while the root Corners still follows the theme transparency")
	@Test
	public instanceTransparencyWins() {
		const theme = extendTheme(DefaultTheme, {
			components: { select: { backgroundColor: FIELD_FILL, backgroundTransparency: 0 } },
		});

		withMounted(
			400,
			200,
			<ThemeProvider theme={theme}>
				<Select BackgroundTransparency={1}>
					<Select.Option text="Alpha" />
				</Select>
			</ThemeProvider>,
			(mounted) => {
				const selectRoot = waitForSelect(mounted.host);

				Assert.equal(selectRoot.BackgroundTransparency, 1);
				Assert.notUndefined(selectRoot.FindFirstChild("Corners"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("select.textColor colours SelectedText and select.iconColor colours the SelectCaret image")
	@Test
	public themedTextAndCaret() {
		const theme = extendTheme(DefaultTheme, {
			components: { select: { textColor: FIELD_TEXT, iconColor: CARET_COLOR } },
		});

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(findSelectedText(selectRoot).TextColor3, FIELD_TEXT);
			Assert.equal(findDescendant<ImageLabel>(selectRoot, "SelectCaret").ImageColor3, CARET_COLOR);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without select.textColor or iconColor both fall back to the primary intent's default textColor")
	@Test
	public defaultTextAndCaret() {
		withMounted(400, 200, selectWithOptions(), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const fallback = DefaultTheme.colors.intents.primary.default.textColor;

			Assert.equal(findSelectedText(selectRoot).TextColor3, fallback);
			Assert.equal(findDescendant<ImageLabel>(selectRoot, "SelectCaret").ImageColor3, fallback);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without the new theme keys the field has no shadow or band, a bare SelectCaret icon, and the dropdown opens flush with the field's border and radius")
	@Test
	public unsetTreeUnchanged() {
		withMounted(400, 400, overlaySelect(DefaultTheme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const button = selectButton(selectRoot);
			const caret = findDescendant<ImageLabel>(selectRoot, "SelectCaret");

			Assert.undefined(selectRoot.FindFirstChildWhichIsA("UIShadow", true));
			Assert.undefined(selectRoot.FindFirstChild("InnerShadow", true));
			Assert.undefined(selectRoot.FindFirstChild("SelectCaretCap", true));
			Assert.equal(caret.Parent, button);
			Assert.equal(button.ZIndex, 1);

			const dropdown = openDropdown(mounted, selectRoot);
			const stroke = dropdown.FindFirstChild("Stroke") as UIStroke;

			Assert.undefined(dropdown.FindFirstChildWhichIsA("UIShadow", true));
			Assert.equal(stroke.Thickness, DefaultTheme.components.select.borderThickness);
			Assert.equal(stroke.Color, DefaultTheme.components.select.borderColor);
			Assert.equal((dropdown.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 8));
			Assert.approximately(rect(dropdown).top, rect(button).bottom, 1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A bare CssShadow string draws a root UIShadow with that offset and blur in the global boxShadow colour and transparency")
	@Test
	public stringShadow() {
		const theme = selectTheme({ boxShadow: "0px 2px 4px 0px" }, { color: SHADOW_COLOR, transparency: 0.5 });

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const shadow = waitForSelect(mounted.host).FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Select root");
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
		const theme = selectTheme(
			{ boxShadow: { shadow: "0px 1px 0px 0px", color: LIP_COLOR, transparency: 0 } },
			{ color: SHADOW_COLOR, transparency: 0.5 },
		);

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const shadow = waitForSelect(mounted.host).FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Select root");
			Assert.equal(shadow!.Color, LIP_COLOR);
			Assert.equal(shadow!.Transparency, 0);
			Assert.equal(shadow!.Offset, UDim2.fromOffset(0, 1));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["string"], ["table"]])
	@DisplayName("An all-zero boxShadow, as a string or a table, draws no UIShadow on the Select root")
	@Test
	public zeroShadowNothing(form: string) {
		withMounted(400, 200, themedSelect(selectTheme({ boxShadow: zeroShadow(form) })), (mounted) => {
			Assert.undefined(waitForSelect(mounted.host).FindFirstChildWhichIsA("UIShadow", true));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("innerShadow puts a coloured InnerShadow band on the root, inset by the border, under a ZIndex 2 SelectButton")
	@Test
	public innerShadowBand() {
		const theme = selectTheme({ borderThickness: 2, cornerRadius: 8, innerShadow: { color: INK, transparency: 0.5, size: 8 } });

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const button = selectButton(selectRoot);
			const band = waitForGuiObject<Frame>(selectRoot, "InnerShadow", (frame) => frame.Visible && frame.AbsoluteSize.Y > 0);

			Assert.equal(band.Parent, selectRoot);
			Assert.equal(button.ZIndex, 2);
			Assert.true(band.ZIndex < button.ZIndex, `Expected the band ZIndex (${band.ZIndex}) under SelectButton's (${button.ZIndex})`);
			Assert.equal(band.BackgroundColor3, INK);
			Assert.equal(band.Position, UDim2.fromOffset(2, 2));
			Assert.equal(band.Size, new UDim2(1, -4, 1, -4));
			Assert.equal((band.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 6));

			const fade = band.FindFirstChild("Fade") as UIGradient;

			Assert.equal(fade.Rotation, 90);
			Assert.equal(fade.Transparency.Keypoints[0].Value, 0.5);
			waitForLayout(
				() => {
					const keypoints = fade.Transparency.Keypoints;
					return keypoints.size() === 3 && math.abs(keypoints[1].Time - 8 / band.AbsoluteSize.Y) < 0.002 ? true : undefined;
				},
				`Timed out waiting for the fade keypoint at 8 / ${band.AbsoluteSize.Y}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("MouseEnter on SelectButton applies states.hover's border colour and transparency over the base thickness, and MouseLeave restores the base")
	@Test
	public hoverState() {
		withMounted(400, 400, overlaySelect(STATE_THEME), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const button = selectButton(selectRoot);

			assertFieldLook(selectRoot, BASE_BORDER, 1, 0.5, "before hover");

			fireHostEvent(mounted, button, "MouseEnter", 0, 0);
			assertFieldLook(selectRoot, HOVER_BORDER, 1, 0.75, "hovered");
			Assert.equal(selectRoot.BackgroundColor3, FIELD_FILL);

			fireHostEvent(mounted, button, "MouseLeave", 0, 0);
			assertFieldLook(selectRoot, BASE_BORDER, 1, 0.5, "after hover");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Opening the dropdown while hovered applies only states.focus, and closing it returns to the hover look")
	@Test
	public focusState() {
		withMounted(400, 400, overlaySelect(STATE_THEME), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const button = selectButton(selectRoot);

			fireHostEvent(mounted, button, "MouseEnter", 0, 0);
			openDropdown(mounted, selectRoot);
			assertFieldLook(selectRoot, FOCUS_BORDER, 3, 0.5, "open and hovered");

			activateButton(mounted, button);
			waitForRemoval(mounted.host, "SelectDropdown");
			assertFieldLook(selectRoot, HOVER_BORDER, 1, 0.75, "closed and hovered");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The disabled prop applies states.disabled even while hovered, and an instance BackgroundTransparency still beats it")
	@Test
	public disabledState() {
		withMounted(400, 400, overlaySelect(STATE_THEME, { disabled: true }), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			fireHostEvent(mounted, selectButton(selectRoot), "MouseEnter", 0, 0);
			assertFieldLook(selectRoot, DISABLED_BORDER, 1, 0.25, "disabled and hovered");

			mounted.update(overlaySelect(STATE_THEME, { disabled: true, BackgroundTransparency: 1 }));
			Assert.equal(selectRoot.BackgroundTransparency, 1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The root Corners appears only while a state brings the theme transparency below 1")
	@Test
	public cornersFollowState() {
		const theme = selectTheme({ backgroundColor: FIELD_FILL, cornerRadius: 6, states: { disabled: { backgroundTransparency: 0.5 } } });

		withMounted(400, 400, overlaySelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.undefined(selectRoot.FindFirstChild("Corners"));

			mounted.update(overlaySelect(theme, { disabled: true }));

			Assert.equal(selectRoot.BackgroundTransparency, 0.5);
			Assert.equal((selectRoot.FindFirstChild("Corners") as UICorner | undefined)?.CornerRadius, new UDim(0, 6));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A disabled Select ignores both a click and Fieldset labelActivated, and opens again once re-enabled")
	@Test
	public disabledCannotOpen() {
		const labelActivated = new Instance("BindableEvent");
		const fieldsetSelect = (disabled: boolean) => (
			<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
				{overlaySelect(DefaultTheme, { disabled })}
			</FieldsetContext.Provider>
		);

		try {
			withMounted(400, 400, fieldsetSelect(true), (mounted) => {
				const selectRoot = waitForSelect(mounted.host);
				waitForGuiObject<Frame>(mounted.host, "OverlayProvider");

				activateButton(mounted, selectButton(selectRoot));
				labelActivated.Fire();
				settleFrames(5);
				Assert.undefined(mounted.host.FindFirstChild("SelectDropdown", true), "Expected a disabled Select to stay closed");

				mounted.update(fieldsetSelect(false));
				labelActivated.Fire();
				waitForGuiObject<Frame>(mounted.host, "SelectDropdown");
			});
		} finally {
			labelActivated.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Setting disabled while the dropdown is open closes it and shows the disabled look")
	@Test
	public disabledClosesOpen() {
		withMounted(400, 400, overlaySelect(STATE_THEME), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			openDropdown(mounted, selectRoot);
			mounted.update(overlaySelect(STATE_THEME, { disabled: true }));

			waitForRemoval(mounted.host, "SelectDropdown");
			assertFieldLook(selectRoot, DISABLED_BORDER, 1, 0.25, "disabled after open");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A styled caret draws a filled, stroked, rounded Cap box around a centred SelectCaret, overlapping 6px past its slot on a -6px right margin")
	@Test
	public caretCap() {
		const theme = selectTheme({
			caret: {
				size: 30,
				backgroundColor: CAP_FILL,
				borderColor: CAP_BORDER,
				borderThickness: 2,
				cornerRadius: 6,
				iconColor: CARET_COLOR,
				margin: "0px -6px 0px 0px",
			},
		});

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const slot = waitForGuiObject<Frame>(selectRoot, "SelectCaretCap");
			const cap = slot.FindFirstChild("Cap") as Frame;
			const icon = waitForGuiObject<ImageLabel>(cap, "SelectCaret");
			const stroke = cap.FindFirstChild("Stroke") as UIStroke;

			Assert.equal(slot.Size, UDim2.fromOffset(24, math.max(0, 30 - capInset(theme))));
			Assert.equal(cap.Size, UDim2.fromOffset(30, 30));
			Assert.equal(cap.Position, new UDim2(0, 0, 0.5, 0));
			Assert.equal(cap.BackgroundColor3, CAP_FILL);
			Assert.equal(cap.BackgroundTransparency, 0);
			Assert.equal(stroke.Thickness, 2);
			Assert.equal(stroke.Color, CAP_BORDER);
			Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner);
			Assert.equal((cap.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 6));
			Assert.equal(icon.Parent, cap);
			Assert.equal(icon.ImageColor3, CARET_COLOR);
			Assert.approximately(rect(cap).right, rect(slot).right + 6, 1);
			assertCenteredIn(icon, cap, "both", 1, "caret icon");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A four-value caret margin widens the slot by left+right, sets its height to top+bottom less the padding inset, and shifts the centred Cap by left and half of top-bottom")
	@Test
	public caretMarginQuad() {
		const theme = selectTheme({ caret: { size: 20, margin: "4px 2px 6px 8px" } });

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const slot = waitForGuiObject<Frame>(waitForSelect(mounted.host), "SelectCaretCap");
			const cap = slot.FindFirstChild("Cap") as Frame;

			Assert.equal(slot.Size, UDim2.fromOffset(30, math.max(0, 30 - capInset(theme))));
			Assert.equal(cap.Size, UDim2.fromOffset(20, 20));
			Assert.equal(cap.AnchorPoint, new Vector2(0, 0.5));
			Assert.equal(cap.Position, new UDim2(0, 8, 0.5, -1));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An empty caret object gives a transparent theme-icon-sized Cap with no stroke, corners or gradient")
	@Test
	public caretDefaults() {
		const theme = selectTheme({ caret: {} });

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const cap = waitForGuiObject<Frame>(waitForSelect(mounted.host), "Cap");
			const slot = cap.Parent as Frame;
			const size = DefaultTheme.iconSize[DefaultTheme.default.scale] ?? 0;

			Assert.equal(slot.Name, "SelectCaretCap");
			Assert.equal(slot.Size, UDim2.fromOffset(size, math.max(0, size - capInset(theme))));
			Assert.equal(cap.Size, UDim2.fromOffset(size, size));
			Assert.equal(cap.BackgroundTransparency, 1);
			Assert.undefined(cap.FindFirstChild("Stroke"));
			Assert.undefined(cap.FindFirstChild("Corners"));
			Assert.undefined(cap.FindFirstChildWhichIsA("UIGradient"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A 30px stroked cap that fits inside the padded field keeps the Select at the text line plus padding, with SelectedText centred in the field")
	@Test
	public caretCapNoGrow() {
		const theme = selectTheme({
			caret: { size: 30, backgroundColor: CAP_FILL, borderColor: CAP_BORDER, borderThickness: 2, cornerRadius: 6, margin: "0px -6px 0px 0px" },
		});

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const button = selectButton(selectRoot);
			const cap = waitForGuiObject<Frame>(selectRoot, "Cap");
			const text = waitForGuiObject<TextLabel>(selectRoot, "SelectedText");
			const expected = waitForLayout(() => {
				const height = fieldPaddingY(theme) + text.AbsoluteSize.Y;
				return math.abs(selectRoot.AbsoluteSize.Y - height) <= 1 ? height : undefined;
			}, `Timed out waiting for the capped Select (${selectRoot.AbsoluteSize.Y}px) to equal the text line (${text.AbsoluteSize.Y}px) plus ${fieldPaddingY(theme)}px padding`);

			Assert.approximately(button.AbsoluteSize.Y, expected, 1);
			assertCenteredIn(text, button, "y", 1, "SelectedText");
			assertCenteredIn(cap, button, "y", 1, "caret Cap");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["gradient", 0], ["explicit", 0.5]])
	@DisplayName("A caret backgroundGradient alone makes the Cap opaque with a Gradient, and an explicit backgroundTransparency overrides the fill")
	@Test
	public caretFill(kind: string, expected: number) {
		const theme = kind === "gradient"
			? selectTheme({ caret: { backgroundGradient: { colors: [CAP_FILL, INK] } } })
			: selectTheme({ caret: { backgroundColor: CAP_FILL, backgroundTransparency: 0.5 } });

		withMounted(400, 200, themedSelect(theme), (mounted) => {
			const cap = waitForGuiObject<Frame>(waitForSelect(mounted.host), "Cap");

			Assert.equal(cap.BackgroundTransparency, expected);
			Assert.equal(cap.FindFirstChild("Gradient") !== undefined, kind === "gradient");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["caret"], ["select"], ["none"]])
	@DisplayName("The capped SelectCaret colour falls back from caret.iconColor to select.iconColor to the primary default textColor")
	@Test
	public caretIconFallback(source: string) {
		withMounted(400, 200, themedSelect(caretColorTheme(source)), (mounted) => {
			const icon = waitForGuiObject<ImageLabel>(waitForSelect(mounted.host), "SelectCaret");

			Assert.equal(icon.Parent?.Name, "Cap");
			Assert.equal(icon.ImageColor3, expectedCaretColor(source));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("dropDown overrides the dropdown's radius, Outer border and shadow and opens it gap px below the field, leaving the field stroke alone")
	@Test
	public dropDownOverrides() {
		const theme = selectTheme({
			borderColor: BASE_BORDER,
			borderThickness: 1,
			cornerRadius: 8,
			dropDown: {
				cornerRadius: 4,
				borderColor: DROP_BORDER,
				borderThickness: 3,
				boxShadow: { shadow: "0px 6px 14px 0px", color: SHADOW_COLOR, transparency: 0.5 },
				gap: 6,
			},
		});

		withMounted(400, 400, overlaySelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const dropdown = openDropdown(mounted, selectRoot);
			const stroke = dropdown.FindFirstChild("Stroke") as UIStroke;
			const shadow = dropdown.FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.equal(stroke.Thickness, 3);
			Assert.equal(stroke.Color, DROP_BORDER);
			Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer);
			Assert.equal((dropdown.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 4));
			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under SelectDropdown");
			Assert.equal(shadow!.Color, SHADOW_COLOR);
			Assert.equal(shadow!.Transparency, 0.5);
			Assert.equal(shadow!.Offset, UDim2.fromOffset(0, 6));
			Assert.equal(shadow!.BlurRadius, new UDim(0, 14));
			Assert.approximately(rect(dropdown).top, rect(selectButton(selectRoot)).bottom + 6, 1);
			Assert.equal(fieldStroke(selectRoot).Color, BASE_BORDER);
			Assert.equal((selectButton(selectRoot).FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 8));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A dropDown with only a string boxShadow keeps the field's radius and border, a flush gap, and the global shadow colour")
	@Test
	public dropDownFallback() {
		const theme = selectTheme(
			{ borderColor: BASE_BORDER, borderThickness: 2, cornerRadius: 5, dropDown: { boxShadow: "0px 4px 8px 0px" } },
			{ color: SHADOW_COLOR, transparency: 0.5 },
		);

		withMounted(400, 400, overlaySelect(theme), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const dropdown = openDropdown(mounted, selectRoot);
			const stroke = dropdown.FindFirstChild("Stroke") as UIStroke;
			const shadow = dropdown.FindFirstChild("BoxShadow") as UIShadow | undefined;

			Assert.equal(stroke.Thickness, 2);
			Assert.equal(stroke.Color, BASE_BORDER);
			Assert.equal((dropdown.FindFirstChild("Corners") as UICorner).CornerRadius, new UDim(0, 5));
			Assert.notUndefined(shadow, "Expected a BoxShadow UIShadow directly under SelectDropdown");
			Assert.equal(shadow!.Color, SHADOW_COLOR);
			Assert.equal(shadow!.Offset, UDim2.fromOffset(0, 4));
			Assert.approximately(rect(dropdown).top, rect(selectButton(selectRoot)).bottom, 1);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[4], [12]])
	@DisplayName("dropDown.gap offsets the dropdown's top edge exactly that many pixels below the field's bottom edge")
	@Test
	public dropDownGap(gap: number) {
		withMounted(400, 400, overlaySelect(selectTheme({ dropDown: { gap } })), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);
			const dropdown = openDropdown(mounted, selectRoot);

			Assert.approximately(rect(dropdown).top - rect(selectButton(selectRoot)).bottom, gap, 1);
		});
	}
}

export = SelectMountValidation;
