import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Badge } from "../../../Components/Surface/Badge";
import { STUDIO_SKIP_MESSAGE, waitForGuiObject, withMounted } from "../../Helpers/layout";

const FILL = Color3.fromRGB(40, 90, 160);
const TEXT = Color3.fromRGB(250, 220, 120);
const ICON = Color3.fromRGB(200, 60, 90);
const BORDER = Color3.fromRGB(20, 140, 70);

function waitForBadge(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Badge");
}

function directChild<K extends keyof Instances>(parent: Instance, className: K): Instances[K] {
	const found = parent.FindFirstChildWhichIsA(className);
	Assert.notUndefined(found, `Expected ${parent.Name} to have a direct ${className} child`);
	return found!;
}

@Tag("Studio")
class BadgePropsValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without the new props the root ImageLabel holds the padding, row and text directly, with no BadgeButton")
	@Test
	public treeUnchanged() {
		withMounted(400, 200, <Badge text="New" icon="check" />, (mounted) => {
			const badge = waitForBadge(mounted.host);

			Assert.equal(badge.ClassName, "ImageLabel");
			Assert.false(badge.Active);
			Assert.false(badge.Selectable);
			Assert.undefined(badge.FindFirstChild("BadgeButton", true), "Expected no BadgeButton without onClick");
			Assert.undefined(badge.FindFirstChildWhichIsA("ImageButton", true), "Expected no ImageButton without onClick");
			directChild(badge, "UIPadding");
			directChild(badge, "UIListLayout");
			directChild(badge, "UIStroke");
			Assert.notUndefined(badge.FindFirstChild("BadgeText"), "Expected BadgeText directly under the root");
			Assert.notUndefined(badge.FindFirstChild("BadgeIcon"), "Expected BadgeIcon directly under the root");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Per-instance background, transparency, text, icon and border colours override the intent scheme")
	@Test
	public colourPropsOverride() {
		withMounted(
			400,
			200,
			<Badge
				text="Custom"
				icon="check"
				intent="success"
				BackgroundColor3={FILL}
				BackgroundTransparency={0.25}
				textColor={TEXT}
				iconColor={ICON}
				borderColor={BORDER}
			/>,
			(mounted) => {
				const badge = waitForBadge(mounted.host);
				const text = waitForGuiObject<TextLabel>(badge, "BadgeText");
				const icon = waitForGuiObject<ImageLabel>(badge, "BadgeIcon");

				Assert.equal(badge.BackgroundColor3, FILL, "background");
				Assert.equal(badge.BackgroundTransparency, 0.25, "background transparency");
				Assert.equal(text.TextColor3, TEXT, "text");
				Assert.equal(icon.ImageColor3, ICON, "icon");
				Assert.equal(directChild(badge, "UIStroke").Color, BORDER, "border");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With textColor but no iconColor the icon is tinted with the text colour")
	@Test
	public iconFollowsText() {
		withMounted(400, 200, <Badge text="Tinted" icon="check" intent="danger" textColor={TEXT} />, (mounted) => {
			const badge = waitForBadge(mounted.host);
			const icon = waitForGuiObject<ImageLabel>(badge, "BadgeIcon");

			Assert.equal(icon.ImageColor3, TEXT);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A padding quad replaces the theme's per-scale padding on each side")
	@Test
	public paddingOverrides() {
		withMounted(400, 200, <Badge text="Padded" padding="3 9" />, (mounted) => {
			const padding = directChild(waitForBadge(mounted.host), "UIPadding");

			Assert.equal(padding.PaddingTop, new UDim(0, 3), "PaddingTop");
			Assert.equal(padding.PaddingBottom, new UDim(0, 3), "PaddingBottom");
			Assert.equal(padding.PaddingLeft, new UDim(0, 9), "PaddingLeft");
			Assert.equal(padding.PaddingRight, new UDim(0, 9), "PaddingRight");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("borderThickness={0} renders no UIStroke at all")
	@Test
	public zeroBorderNoStroke() {
		withMounted(400, 200, <Badge text="Flat" borderThickness={0} />, (mounted) => {
			const badge = waitForBadge(mounted.host);

			Assert.undefined(badge.FindFirstChildWhichIsA("UIStroke"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("borderThickness, borderTransparency and borderPosition outer reach the stroke")
	@Test
	public borderShapeProps() {
		withMounted(
			400,
			200,
			<Badge text="Ring" borderThickness={3} borderTransparency={0.5} borderPosition="outer" />,
			(mounted) => {
				const stroke = directChild(waitForBadge(mounted.host), "UIStroke");

				Assert.equal(stroke.Thickness, 3);
				Assert.equal(stroke.Transparency, 0.5);
				Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer);
			},
		);
	}
}

export = BadgePropsValidation;
