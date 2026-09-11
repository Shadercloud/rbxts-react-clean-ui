import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { BoxShadow } from "../../../Components/Decorator/BoxShadow";
import { CssShadow } from "../../../Interfaces/";
import { DefaultTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, findDescendant, waitForGuiObject, withMounted } from "../../Helpers/layout";

function targetWith(decorator: React.ReactNode) {
	return (
		<frame key="Target" Size={UDim2.fromOffset(200, 100)} BackgroundTransparency={0}>
			{decorator}
		</frame>
	);
}

@Tag("Studio")
class BoxShadowMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A CSS shadow value emits a UIShadow named BoxShadow under the parent, behind it (ZIndex -1), with parsed offset/blur/spread and the theme's colour")
	@Test
	public cssValueShadow() {
		withMounted(300, 200, targetWith(<BoxShadow value="2px 4px 6px 8px" />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const shadow = findDescendant<UIShadow>(target, "BoxShadow");

			Assert.equal(shadow.ClassName, "UIShadow");
			Assert.equal(shadow.Parent, target, "Expected the UIShadow to be a direct child of the decorated frame");
			Assert.equal(shadow.ZIndex, -1, "Expected the shadow to sit behind its parent");
			Assert.equal(shadow.Offset, new UDim2(0, 2, 0, 4));
			Assert.equal(shadow.BlurRadius, new UDim(0, 6));
			Assert.equal(shadow.Spread, new UDim2(0, 8, 0, 8));
			Assert.equal(shadow.Color, DefaultTheme.components.boxShadow.color);
			Assert.approximately(shadow.Transparency, DefaultTheme.components.boxShadow.transparency, 1e-6);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("completeShadow uses its own colour and transparency instead of the theme's, and zindex/name are honoured")
	@Test
	public completeShadow() {
		const color = Color3.fromRGB(10, 20, 30);

		withMounted(
			300,
			200,
			targetWith(<BoxShadow name="Glow" zindex={3} completeShadow={{ shadow: "0px 0px 8px 3px", color, transparency: 0.25 }} />),
			(mounted) => {
				const target = waitForGuiObject<Frame>(mounted.host, "Target");
				const shadow = findDescendant<UIShadow>(target, "Glow");

				Assert.equal(shadow.ZIndex, 3);
				Assert.equal(shadow.Offset, new UDim2(0, 0, 0, 0));
				Assert.equal(shadow.BlurRadius, new UDim(0, 8));
				Assert.equal(shadow.Spread, new UDim2(0, 3, 0, 3));
				Assert.equal(shadow.Color, color);
				Assert.approximately(shadow.Transparency, 0.25, 1e-6);
				Assert.undefined(target.FindFirstChild("BoxShadow"), "Expected the default BoxShadow name not to be used when name is set");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[0], ["0px 0px 0px 0px"]])
	@DisplayName("An all-zero shadow value emits no UIShadow at all")
	@Test
	public zeroShadowEmitsNothing(value: CssShadow) {
		withMounted(300, 200, targetWith(<BoxShadow value={value} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UIShadow"), `Expected no UIShadow for shadow value ${value}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With neither value, box-shadow nor completeShadow set, no UIShadow is emitted")
	@Test
	public noValueEmitsNothing() {
		withMounted(300, 200, targetWith(<BoxShadow />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UIShadow"), "Expected no UIShadow when no shadow prop is set");
		});
	}
}

export = BoxShadowMountValidation;
