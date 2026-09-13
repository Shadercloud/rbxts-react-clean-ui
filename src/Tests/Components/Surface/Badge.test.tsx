import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Badge } from "../../../Components/Surface/Badge";
import { Intent, ScaleSize } from "../../../Interfaces";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { WoodenTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertTextFits,
	findDescendantOfClass,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

function waitForBadge(host: Instance, name = "Badge"): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, name);
}

function assertColor(actual: Color3, expectedHex: string, label: string) {
	Assert.equal(
		actual.ToHex().lower(),
		expectedHex.lower(),
		`${label}: expected #${expectedHex}, got #${actual.ToHex()}`,
	);
}

function assertIntentColors(badge: ImageLabel, textHex: string, backgroundHex: string, borderHex: string, label: string) {
	const text = waitForGuiObject<TextLabel>(badge, "BadgeText");
	const stroke = findDescendantOfClass(badge, "UIStroke");

	assertColor(badge.BackgroundColor3, backgroundHex, `${label} background`);
	assertColor(stroke.Color, borderHex, `${label} border`);
	assertColor(text.TextColor3, textHex, `${label} text`);
	Assert.equal(badge.BackgroundTransparency, 0, `${label}: expected an opaque background`);
}

@Tag("Studio")
class BadgeMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Renders its label in a content-sized, non-interactive root that contains the text")
	@Test
	public mountsWithText() {
		withMounted(400, 200, <Badge text="New" />, (mounted) => {
			const badge = waitForBadge(mounted.host);
			const label = waitForGuiObject<TextLabel>(badge, "BadgeText");

			Assert.equal(label.Text, "New");
			Assert.false(badge.Active, "Expected the Badge root to have Active=false");
			assertNonZeroSize(badge, "badge");
			assertTextFits(label, "badge");
			assertAllDescendantsContained(badge, "badge");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Default theme intent colours reach the background, UIStroke and text")
	@Each([
		["primary", "1D2433", "EEF1F6", "D9DEE8"],
		["success", "FFFFFF", "2E9D63", "237D4D"],
		["danger", "FFFFFF", "D64545", "B53535"],
	])
	@Test
	public defaultIntentColors(intent: Intent, textHex: string, backgroundHex: string, borderHex: string) {
		withMounted(400, 200, <Badge text="3" intent={intent} />, (mounted) => {
			const badge = waitForBadge(mounted.host);
			assertIntentColors(badge, textHex, backgroundHex, borderHex, `default ${intent}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Wooden primary renders a flat brown background, 2px dark border and cream text")
	@Test
	public woodenPrimary() {
		withMounted(
			400,
			200,
			<ThemeProvider theme={WoodenTheme}>
				<Badge text="Wooden" intent="primary" />
			</ThemeProvider>,
			(mounted) => {
				const badge = waitForBadge(mounted.host);
				assertIntentColors(badge, "FFF7CF", "7A4A20", "3D2712", "wooden primary");

				const stroke = findDescendantOfClass(badge, "UIStroke");
				Assert.equal(stroke.Thickness, 2, "Expected the Wooden badge border to be 2px");
				Assert.equal(badge.Image, "", "Expected a flat Wooden badge to have no background image");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Each scale applies the default theme's per-scale badge text size")
	@Each([
		["xs", 10],
		["sm", 12],
		["md", 14],
		["lg", 18],
		["xl", 24],
	])
	@Test
	public scaleSetsTextSize(scale: ScaleSize, expectedSize: number) {
		withMounted(400, 200, <Badge text="Scaled" scale={scale} />, (mounted) => {
			const badge = waitForBadge(mounted.host);
			const label = waitForGuiObject<TextLabel>(badge, "BadgeText");

			Assert.equal(label.TextSize, expectedSize, `Expected scale ${scale} to give TextSize ${expectedSize}, got ${label.TextSize}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A larger scale renders a taller badge than a smaller one")
	@Test
	public largerScaleTaller() {
		withMounted(
			400,
			200,
			<frame key="Stack" Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1}>
				<Badge name="SmallBadge" text="Scaled" scale="xs" Position={UDim2.fromOffset(0, 0)} />
				<Badge name="LargeBadge" text="Scaled" scale="xl" Position={UDim2.fromOffset(0, 80)} />
			</frame>,
			(mounted) => {
				const small = waitForBadge(mounted.host, "SmallBadge");
				const large = waitForBadge(mounted.host, "LargeBadge");

				Assert.true(
					large.AbsoluteSize.Y > small.AbsoluteSize.Y,
					`Expected the xl badge (${large.AbsoluteSize.Y}px) to be taller than the xs badge (${small.AbsoluteSize.Y}px)`,
				);
			},
		);
	}
}

export = BadgeMountValidation;
