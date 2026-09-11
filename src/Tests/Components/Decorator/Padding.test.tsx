import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Padding } from "../../../Components/Decorator/Padding";
import { DefaultTheme } from "../../../Theme";
import { STUDIO_SKIP_MESSAGE, assertSizeApprox, findDescendant, rect, waitForGuiObject, withMounted } from "../../Helpers/layout";

function targetWith(children: React.ReactNode) {
	return (
		<frame key="Target" Size={UDim2.fromOffset(200, 100)} BackgroundTransparency={0}>
			{children}
		</frame>
	);
}

function assertSides(padding: UIPadding, top: number, right: number, bottom: number, left: number, label: string) {
	Assert.equal(padding.PaddingTop, new UDim(0, top), `${label}: PaddingTop`);
	Assert.equal(padding.PaddingRight, new UDim(0, right), `${label}: PaddingRight`);
	Assert.equal(padding.PaddingBottom, new UDim(0, bottom), `${label}: PaddingBottom`);
	Assert.equal(padding.PaddingLeft, new UDim(0, left), `${label}: PaddingLeft`);
}

@Tag("Studio")
class PaddingMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A four-value CSS padding quad emits a UIPadding under the parent with top/right/bottom/left in that order, renamed via name")
	@Test
	public cssQuadSides() {
		withMounted(300, 200, targetWith(<Padding name="Inset" padding="4px 8px 12px 16px" />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const padding = findDescendant<UIPadding>(target, "Inset");

			Assert.equal(padding.ClassName, "UIPadding");
			Assert.equal(padding.Parent, target, "Expected the UIPadding to be a direct child of the decorated frame");
			assertSides(padding, 4, 8, 12, 16, "css quad");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A spacing scale key applies the theme's pixel value for that key to all four sides")
	@Test
	public spacingKeyAllSides() {
		const expected = DefaultTheme.spacing.lg;
		Assert.notUndefined(expected, "Expected the default theme to define spacing.lg");

		withMounted(300, 200, targetWith(<Padding spacing="lg" />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const padding = findDescendant<UIPadding>(target, "Padding");

			assertSides(padding, expected!, expected!, expected!, expected!, "spacing=lg");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("spacing=None zeroes every side, and a per-side key overrides just that side")
	@Test
	public noneWithSideOverride() {
		const expectedTop = DefaultTheme.spacing.sm;
		Assert.notUndefined(expectedTop, "Expected the default theme to define spacing.sm");

		withMounted(300, 200, targetWith(<Padding spacing="None" top="sm" />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const padding = findDescendant<UIPadding>(target, "Padding");

			assertSides(padding, expectedTop!, 0, 0, 0, "spacing=None top=sm");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Padding shrinks a full-size child's rect by the given amounts on each side")
	@Test
	public shrinksChildRect() {
		withMounted(
			300,
			200,
			targetWith(
				<>
					<Padding padding="10px 20px 30px 40px" />
					<frame key="Child" Size={UDim2.fromScale(1, 1)} BackgroundTransparency={0} />
				</>,
			),
			(mounted) => {
				const target = waitForGuiObject<Frame>(mounted.host, "Target");
				const child = waitForGuiObject<Frame>(target, "Child", (gui) => gui.AbsoluteSize.X < target.AbsoluteSize.X);

				assertSizeApprox(child, 140, 60, 1, "padded child");

				const childRect = rect(child);
				const targetRect = rect(target);
				Assert.approximately(childRect.left - targetRect.left, 40, 1);
				Assert.approximately(childRect.top - targetRect.top, 10, 1);
				Assert.approximately(targetRect.right - childRect.right, 20, 1);
				Assert.approximately(targetRect.bottom - childRect.bottom, 30, 1);
			},
		);
	}
}

export = PaddingMountValidation;
