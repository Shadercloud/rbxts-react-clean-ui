import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Button } from "../../../Components/Input/Button";
import { Group, HStack } from "../../../Components/Layout";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { CssRadiusToken } from "../../../Interfaces/";
import { DefaultTheme, WoodenTheme, extendTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertStackedHorizontally,
	assertTextFits,
	findDescendant,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const WOODEN_SECONDARY_TEXT = Color3.fromHex("#D3CBA3");
const WOODEN_SECONDARY_BORDER = Color3.fromHex("#3D2712");
const WOODEN_SECONDARY_TOP = Color3.fromHex("#7A4A20");
const WOODEN_SECONDARY_BOTTOM = Color3.fromHex("#5C3A18");

function waitForButton(host: Instance, name = "Button"): ImageButton {
	return waitForGuiObject<ImageButton>(host, name);
}

function rootPadding(button: ImageButton): UIPadding {
	const padding = button.FindFirstChildWhichIsA("UIPadding");
	Assert.notUndefined(padding, `Expected ${button.Name} to have a direct UIPadding child`);
	return padding!;
}

function assertSides(padding: UIPadding, top: number, bottom: number, left: number, right: number, label: string) {
	Assert.equal(padding.PaddingTop, new UDim(0, top), `${label}: PaddingTop`);
	Assert.equal(padding.PaddingBottom, new UDim(0, bottom), `${label}: PaddingBottom`);
	Assert.equal(padding.PaddingLeft, new UDim(0, left), `${label}: PaddingLeft`);
	Assert.equal(padding.PaddingRight, new UDim(0, right), `${label}: PaddingRight`);
}

@Tag("Studio")
class ButtonMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With an icon and text, the Button auto-sizes and every visible descendant stays inside it")
	@Test
	public mountsContained() {
		withMounted(400, 200, <Button text="Save changes" icon="check" />, (mounted) => {
			const button = waitForButton(mounted.host);

			assertNonZeroSize(button, "icon + text button");
			assertAllDescendantsContained(button, "icon + text button");

			const label = findDescendant<TextLabel>(button, "ButtonText");
			Assert.equal(label.Text, "Save changes");
			assertTextFits(label, "icon + text button");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The icon renders to the left of the label without overlapping it")
	@Test
	public iconLeadsText() {
		withMounted(400, 200, <Button text="Save changes" icon="check" />, (mounted) => {
			const button = waitForButton(mounted.host);
			const icon = waitForGuiObject<ImageLabel>(button, "ButtonIcon");
			const label = waitForGuiObject<TextLabel>(button, "ButtonText");

			assertStackedHorizontally([icon, label], "icon + text row");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("disabled={true} sets the root ImageButton inactive, and re-enabling restores Active")
	@Test
	public disabledInert() {
		withMounted(400, 200, <Button text="Submit" disabled={true} />, (mounted) => {
			const button = waitForButton(mounted.host);
			Assert.false(button.Active, "Expected a disabled Button's root ImageButton to have Active=false");

			mounted.update(<Button text="Submit" />);

			waitForLayout(
				() => (button.Active ? true : undefined),
				"Timed out waiting for the Button to become Active again after disabled was removed",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Two grouped Buttons with different label lengths settle on the same width")
	@Test
	public groupAlignsWidths() {
		withMounted(
			400,
			200,
			<Group>
				<HStack>
					<Button name="ShortButton" group={true} text="OK" />
					<Button name="LongButton" group={true} text="A considerably longer label" />
				</HStack>
			</Group>,
			(mounted) => {
				const short = waitForButton(mounted.host, "ShortButton");
				const long = waitForButton(mounted.host, "LongButton");

				waitForLayout(
					() => (rect(short).width > 0 && rect(short).width === rect(long).width ? true : undefined),
					`Timed out waiting for grouped buttons to share a width (short=${rect(short).width}, long=${rect(long).width})`,
				);

				assertAllDescendantsContained(short, "grouped short button");
				assertAllDescendantsContained(long, "grouped long button");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Under WoodenTheme a secondary Button renders an opaque gradient fill, a 3px border stroke and #D3CBA3 text",
	)
	@Test
	public woodenSecondary() {
		withMounted(
			400,
			200,
			<ThemeProvider theme={WoodenTheme}>
				<Button text="Cancel" intent="secondary" />
			</ThemeProvider>,
			(mounted) => {
				const button = waitForButton(mounted.host);

				Assert.equal(button.BackgroundTransparency, 0);

				const gradient = button.FindFirstChild("Gradient") as UIGradient | undefined;
				Assert.notUndefined(gradient, "Expected the secondary Button to carry a Gradient UIGradient");
				const keypoints = gradient!.Color.Keypoints;
				Assert.equal(keypoints[0].Value, WOODEN_SECONDARY_TOP);
				Assert.equal(keypoints[keypoints.size() - 1].Value, WOODEN_SECONDARY_BOTTOM);
				Assert.equal(gradient!.Rotation, 90);

				const stroke = findDescendant<UIStroke>(button, "Stroke");
				Assert.equal(stroke.Thickness, 3);
				Assert.equal(stroke.Color, WOODEN_SECONDARY_BORDER);

				Assert.equal(findDescendant<TextLabel>(button, "ButtonText").TextColor3, WOODEN_SECONDARY_TEXT);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Under WoodenTheme a primary Button keeps its transparent image look with a zero-thickness stroke and no gradient",
	)
	@Test
	public woodenPrimaryUnchanged() {
		withMounted(
			400,
			200,
			<ThemeProvider theme={WoodenTheme}>
				<Button text="Confirm" />
			</ThemeProvider>,
			(mounted) => {
				const button = waitForButton(mounted.host);

				Assert.equal(button.BackgroundTransparency, 1);
				Assert.equal(findDescendant<UIStroke>(button, "Stroke").Thickness, 0);
				Assert.undefined(button.FindFirstChild("Gradient"));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A two-value padding quad sets top/bottom from the first value and left/right from the second")
	@Test
	public paddingQuadSides() {
		withMounted(400, 200, <Button name="PaddedButton" text="Save" padding="4 12" />, (mounted) => {
			const button = waitForButton(mounted.host, "PaddedButton");

			assertSides(rootPadding(button), 4, 4, 12, 12, 'padding="4 12"');
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without padding every side uses the theme spacing at the default spacing key")
	@Test
	public defaultPaddingFromTheme() {
		const expected = DefaultTheme.spacing[DefaultTheme.default.spacing];
		Assert.notUndefined(expected, "Expected the default theme to define spacing at its default spacing key");

		withMounted(400, 200, <Button text="Save" />, (mounted) => {
			const button = waitForButton(mounted.host);

			assertSides(rootPadding(button), expected!, expected!, expected!, expected!, "no padding prop");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("spacing None does not zero an explicit single-value padding, which applies to all four sides")
	@Test
	public paddingOverridesNone() {
		withMounted(400, 200, <Button text="Save" spacing="None" padding="6" />, (mounted) => {
			const button = waitForButton(mounted.host);

			assertSides(rootPadding(button), 6, 6, 6, 6, 'spacing="None" padding="6"');
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With padding set the icon keeps LayoutOrder 1 and the label LayoutOrder 2, laid out left to right")
	@Test
	public paddingKeepsOrder() {
		withMounted(400, 200, <Button text="Save changes" icon="check" padding="4 12" />, (mounted) => {
			const button = waitForButton(mounted.host);
			const icon = waitForGuiObject<ImageLabel>(button, "ButtonIcon");
			const label = waitForGuiObject<TextLabel>(button, "ButtonText");

			Assert.equal(icon.LayoutOrder, 1);
			Assert.equal(label.LayoutOrder, 2);
			assertStackedHorizontally([icon, label], "padded icon + text row");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without the modal prop the root ImageButton leaves Modal false")
	@Test
	public modalDefaultsOff() {
		withMounted(400, 200, <Button text="Save" />, (mounted) => {
			const button = waitForButton(mounted.host);

			Assert.false(button.Modal, "Expected Modal=false when the modal prop is unset");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("modal={true} is forwarded to the root ImageButton's native Modal property")
	@Test
	public modalForwarded() {
		withMounted(400, 200, <Button text="Save" modal={true} />, (mounted) => {
			const button = waitForButton(mounted.host);

			Assert.true(button.Modal, "Expected Modal=true when modal={true} is passed");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["sm"], ["md"], ["lg"]])
	@DisplayName("A theme button cornerRadius token renders the root UICorner at that token's pixel radius")
	@Test
	public themeRadiusToken(token: CssRadiusToken) {
		const theme = extendTheme(DefaultTheme, { components: { button: { cornerRadius: token } } });

		withMounted(400, 200, <ThemeProvider theme={theme}><Button text="Save" /></ThemeProvider>, (mounted) => {
			const button = waitForButton(mounted.host);
			const corner = button.FindFirstChildWhichIsA("UICorner");

			Assert.notUndefined(corner, "Expected the Button to have a direct UICorner child");
			Assert.equal(corner!.CornerRadius, new UDim(0, DefaultTheme.radius[token]), `cornerRadius="${token}"`);
		});
	}
}

export = ButtonMountValidation;
