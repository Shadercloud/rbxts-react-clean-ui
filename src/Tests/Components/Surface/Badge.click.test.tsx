import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Badge, BadgeProps } from "../../../Components/Surface/Badge";
import { ColorHelper } from "../../../Helpers";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DarkTheme, DefaultTheme, ThemeTemplate } from "../../../Theme";
import { activateButton, fireHostEvent } from "../../Helpers/fiber";
import { STUDIO_SKIP_MESSAGE, assertSizeApprox, settleFrames, waitForGuiObject, withMounted } from "../../Helpers/layout";

const HOVER_FILL = Color3.fromRGB(30, 120, 200);
const HOVER_TEXT = Color3.fromRGB(250, 220, 120);
const PRESS_FILL = Color3.fromRGB(150, 40, 60);
const COLOR_TOLERANCE = 1.5 / 255;

function themeFor(label: string): ThemeTemplate {
	return label === "dark" ? DarkTheme : DefaultTheme;
}

function restingBackground(theme: ThemeTemplate): Color3 {
	return ColorHelper.getIntentColors(theme, "primary", "default", theme.components.badge.intents).backgroundColor;
}

function shade(color: Color3, amount: number): Color3 {
	return color.Lerp(amount < 0 ? new Color3(1, 1, 1) : new Color3(0, 0, 0), math.abs(amount));
}

function brightness(color: Color3): number {
	return color.R + color.G + color.B;
}

function assertColorNear(actual: Color3, expected: Color3, label: string) {
	const near =
		math.abs(actual.R - expected.R) <= COLOR_TOLERANCE &&
		math.abs(actual.G - expected.G) <= COLOR_TOLERANCE &&
		math.abs(actual.B - expected.B) <= COLOR_TOLERANCE;

	Assert.true(near, `${label}: expected #${expected.ToHex()}, got #${actual.ToHex()}`);
}

function clickableBadge(theme: ThemeTemplate, props: Omit<Partial<BadgeProps>, "text"> = {}) {
	return (
		<ThemeProvider theme={theme}>
			<Badge text="Clickable" onClick={() => {}} {...props} />
		</ThemeProvider>
	);
}

function waitForBadge(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Badge");
}

function badgeButton(badge: Instance): ImageButton {
	const button = badge.FindFirstChild("BadgeButton") as ImageButton | undefined;
	Assert.notUndefined(button, `Expected ${badge.Name} to have a direct BadgeButton child`);
	return button!;
}

@Tag("Studio")
class BadgeClickValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("onClick moves the padding and row into a transparent BadgeButton while the root still hugs it")
	@Test
	public clickableTree() {
		withMounted(400, 200, clickableBadge(DefaultTheme), (mounted) => {
			const badge = waitForBadge(mounted.host);
			const button = badgeButton(badge);
			waitForGuiObject<TextLabel>(button, "BadgeText");

			Assert.equal(badge.ClassName, "ImageLabel", "Expected the root to stay an ImageLabel");
			Assert.equal(button.BackgroundTransparency, 1);
			Assert.false(button.AutoButtonColor);
			Assert.notUndefined(button.FindFirstChildWhichIsA("UIPadding"), "Expected the UIPadding inside BadgeButton");
			Assert.undefined(badge.FindFirstChildWhichIsA("UIPadding"), "Expected no UIPadding directly on the root");
			Assert.notUndefined(badge.FindFirstChildWhichIsA("UIStroke"), "Expected the stroke to stay on the root");
			assertSizeApprox(badge, button.AbsoluteSize.X, button.AbsoluteSize.Y, 1, "root vs BadgeButton");
			Assert.true(badge.AbsoluteSize.X < 400, "Expected a clickable Badge to stay content-sized");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Activating BadgeButton calls onClick once per activation")
	@Test
	public activatedCallsOnClick() {
		let clicks = 0;

		withMounted(
			400,
			200,
			clickableBadge(DefaultTheme, {
				onClick: () => {
					clicks += 1;
				},
			}),
			(mounted) => {
				const button = badgeButton(waitForBadge(mounted.host));

				activateButton(mounted, button);
				Assert.equal(clicks, 1);

				activateButton(mounted, button);
				Assert.equal(clicks, 2);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["default"], ["dark"]])
	@DisplayName("Hover shades the resting background by hoverDarken and press by pressDarken, then leaving restores it")
	@Test
	public themeShading(label: string) {
		const theme = themeFor(label);
		const resting = restingBackground(theme);
		const hoverDarken = theme.components.badge.hoverDarken ?? 0;
		const pressDarken = theme.components.badge.pressDarken ?? hoverDarken;

		withMounted(400, 200, clickableBadge(theme), (mounted) => {
			const badge = waitForBadge(mounted.host);
			const button = badgeButton(badge);

			assertColorNear(badge.BackgroundColor3, resting, `${label} resting`);

			fireHostEvent(mounted, button, "MouseEnter");
			assertColorNear(badge.BackgroundColor3, shade(resting, hoverDarken), `${label} hovered`);

			fireHostEvent(mounted, button, "MouseButton1Down");
			assertColorNear(badge.BackgroundColor3, shade(resting, pressDarken), `${label} pressed`);

			fireHostEvent(mounted, button, "MouseLeave");
			assertColorNear(badge.BackgroundColor3, resting, `${label} after leave`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Under DarkTheme hovering lightens the badge instead of darkening it")
	@Test
	public darkLightens() {
		const resting = restingBackground(DarkTheme);

		withMounted(400, 200, clickableBadge(DarkTheme), (mounted) => {
			const badge = waitForBadge(mounted.host);

			fireHostEvent(mounted, badgeButton(badge), "MouseEnter");

			Assert.true(
				brightness(badge.BackgroundColor3) > brightness(resting),
				`Expected hovered #${badge.BackgroundColor3.ToHex()} to be lighter than resting #${resting.ToHex()}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("hoverStyle and pressStyle colours replace the shading, and pressed falls back to hoverStyle fields")
	@Test
	public stateStylesWin() {
		withMounted(
			400,
			200,
			clickableBadge(DefaultTheme, {
				hoverStyle: { backgroundColor: HOVER_FILL, textColor: HOVER_TEXT },
				pressStyle: { backgroundColor: PRESS_FILL },
			}),
			(mounted) => {
				const badge = waitForBadge(mounted.host);
				const button = badgeButton(badge);
				const text = waitForGuiObject<TextLabel>(button, "BadgeText");

				fireHostEvent(mounted, button, "MouseEnter");
				Assert.equal(badge.BackgroundColor3, HOVER_FILL, "hovered background");
				Assert.equal(text.TextColor3, HOVER_TEXT, "hovered text");

				fireHostEvent(mounted, button, "MouseButton1Down");
				Assert.equal(badge.BackgroundColor3, PRESS_FILL, "pressed background");
				Assert.equal(text.TextColor3, HOVER_TEXT, "pressed text falls back to hoverStyle");

				fireHostEvent(mounted, button, "MouseButton1Up");
				Assert.equal(badge.BackgroundColor3, HOVER_FILL, "released background");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Removing onClick while hovered drops the hover look, and re-adding it does not bring it back")
	@Test
	public removingClickResets() {
		const resting = restingBackground(DefaultTheme);

		withMounted(400, 200, clickableBadge(DefaultTheme), (mounted) => {
			const badge = waitForBadge(mounted.host);

			fireHostEvent(mounted, badgeButton(badge), "MouseEnter");

			mounted.update(
				<ThemeProvider theme={DefaultTheme}>
					<Badge text="Clickable" />
				</ThemeProvider>,
			);
			settleFrames(2);
			assertColorNear(badge.BackgroundColor3, resting, "without onClick");

			mounted.update(clickableBadge(DefaultTheme));
			assertColorNear(waitForBadge(mounted.host).BackgroundColor3, resting, "onClick re-added");
		});
	}
}

export = BadgeClickValidation;
