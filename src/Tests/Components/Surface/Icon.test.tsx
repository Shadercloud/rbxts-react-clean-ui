import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Icon } from "../../../Components/Surface/Icon";
import {
	STUDIO_SKIP_MESSAGE,
	assertContained,
	assertSizeApprox,
	findDescendant,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const DEFAULT_SCALE_SIZE = 20;

@Tag("Studio")
class IconMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a scale prop the Icon renders at the theme's default (md) icon size")
	@Test
	public defaultScaleSize() {
		withMounted(200, 200, <Icon icon="check" />, (mounted) => {
			const icon = waitForGuiObject<ImageLabel>(mounted.host, "Icon");

			Assert.true(icon.IsA("ImageLabel"), "Expected a non-spinning Icon to render as an ImageLabel");
			assertSizeApprox(icon, DEFAULT_SCALE_SIZE, DEFAULT_SCALE_SIZE, 0, "default scale icon");
			assertContained(icon, mounted.host, "default scale icon");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["sm", 16],
		["lg", 24],
		["xl", 30],
	])
	@DisplayName("The scale prop picks the matching square pixel size from theme.iconSize")
	@Test
	public scaleSize(scale: "sm" | "lg" | "xl", expected: number) {
		withMounted(200, 200, <Icon icon="check" scale={scale} />, (mounted) => {
			const icon = waitForGuiObject<ImageLabel>(mounted.host, "Icon");

			assertSizeApprox(icon, expected, expected, 0, `${scale} icon`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An explicit Size prop overrides the scale-derived size")
	@Test
	public explicitSize() {
		withMounted(200, 200, <Icon icon="check" scale="sm" Size={UDim2.fromOffset(48, 32)} />, (mounted) => {
			const icon = waitForGuiObject<ImageLabel>(mounted.host, "Icon");

			assertSizeApprox(icon, 48, 32, 0, "explicit size icon");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("spinning={true} wraps the ImageLabel in an auto-sized Frame that contains it")
	@Test
	public spinningWrapped() {
		withMounted(200, 200, <Icon icon="check" scale="lg" spinning={true} />, (mounted) => {
			const wrapper = waitForGuiObject<Frame>(mounted.host, "Icon");
			Assert.true(wrapper.IsA("Frame"), "Expected the spinning Icon's outer instance to be the wrapper Frame");

			const inner = findDescendant<ImageLabel>(wrapper, "Icon");
			Assert.true(inner.IsA("ImageLabel"), "Expected the wrapper Frame to contain the rotating ImageLabel");

			assertSizeApprox(inner, 24, 24, 0, "spinning inner icon");
			assertSizeApprox(wrapper, 24, 24, 1, "spinning wrapper");
			assertContained(inner, wrapper, "spinning inner icon");
		});
	}
}

export = IconMountValidation;
