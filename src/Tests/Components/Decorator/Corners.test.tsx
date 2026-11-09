import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Corners } from "../../../Components/Decorator/Corners";
import { CssRadiusToken, CssSize } from "../../../Interfaces/";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, extendTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, findDescendant, waitForGuiObject, withMounted } from "../../Helpers/layout";

function targetWith(decorator: React.ReactNode) {
	return (
		<frame key="Target" Size={UDim2.fromOffset(200, 100)} BackgroundTransparency={0}>
			{decorator}
		</frame>
	);
}

@Tag("Studio")
class CornersMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A numeric radius emits a UICorner named Corners under the parent with an offset-only CornerRadius")
	@Test
	public numericRadius() {
		withMounted(300, 200, targetWith(<Corners radius={8} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const corner = findDescendant<UICorner>(target, "Corners");

			Assert.equal(corner.ClassName, "UICorner");
			Assert.equal(corner.Parent, target, "Expected the UICorner to be a direct child of the decorated frame");
			Assert.equal(corner.CornerRadius, new UDim(0, 8));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A percent radius maps to a scale-only CornerRadius, and the name prop renames the UICorner")
	@Test
	public percentRadiusAndName() {
		withMounted(300, 200, targetWith(<Corners radius="50%" name="RoundCorners" />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const corner = findDescendant<UICorner>(target, "RoundCorners");

			Assert.equal(corner.CornerRadius, new UDim(0.5, 0));
			Assert.undefined(target.FindFirstChild("Corners"), "Expected the default Corners name not to be used when name is set");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[0], ["0px"]])
	@DisplayName("A zero radius emits no UICorner at all")
	@Test
	public zeroRadiusEmitsNothing(radius: CssSize) {
		withMounted(300, 200, targetWith(<Corners radius={radius} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UICorner"), `Expected no UICorner for radius ${radius}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Omitting the radius prop emits no UICorner at all")
	@Test
	public noRadiusEmitsNothing() {
		withMounted(300, 200, targetWith(<Corners />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UICorner"), "Expected no UICorner when radius is omitted");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["sm"], ["md"], ["lg"]])
	@DisplayName("A radius token resolves to the matching pixel value from the active theme's radius scale")
	@Test
	public tokenFromTheme(token: CssRadiusToken) {
		withMounted(300, 200, targetWith(<Corners radius={token} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const corner = findDescendant<UICorner>(target, "Corners");

			Assert.equal(corner.CornerRadius, new UDim(0, DefaultTheme.radius[token]), `radius="${token}"`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A radius token follows a ThemeProvider override of the radius scale rather than the default theme")
	@Test
	public tokenFollowsTheme() {
		const theme = extendTheme(DefaultTheme, { radius: { lg: 20 } });

		withMounted(300, 200, <ThemeProvider theme={theme}>{targetWith(<Corners radius="lg" />)}</ThemeProvider>, (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const corner = findDescendant<UICorner>(target, "Corners");

			Assert.equal(corner.CornerRadius, new UDim(0, 20));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A token whose theme value is zero emits no UICorner")
	@Test
	public zeroTokenEmitsNothing() {
		const theme = extendTheme(DefaultTheme, { radius: { sm: 0 } });

		withMounted(300, 200, <ThemeProvider theme={theme}>{targetWith(<Corners radius="sm" />)}</ThemeProvider>, (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UICorner"), "Expected no UICorner for a zero-valued token");
		});
	}
}

export = CornersMountValidation;
