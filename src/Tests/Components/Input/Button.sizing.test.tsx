import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Button, ButtonProps } from "../../../Components/Input/Button";
import { HStack } from "../../../Components/Layout";
import {
	STUDIO_SKIP_MESSAGE,
	assertCenteredIn,
	assertSizeApprox,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const FILL_NAMES = ["FillShort", "FillMedium", "FillLong"];
const FILL_LABELS = ["A", "Medium", "A much longer label"];

function fillRow() {
	return (
		<frame key="Stack" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<HStack Wraps={false}>
				{FILL_NAMES.map((name, index) => (
					<Button key={name} name={name} text={FILL_LABELS[index]} fill={true} LayoutOrder={index + 1} />
				))}
			</HStack>
		</frame>
	);
}

@Tag("Studio")
class ButtonSizingValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[120, 120],
		["50%", 200],
	])
	@DisplayName("A width prop fixes the root's width while AutomaticSize.Y keeps the height hugging the content")
	@Test
	public widthSizes(width: ButtonProps["width"], expected: number) {
		withMounted(HOST_WIDTH, 200, <Button text="Save" width={width} />, (mounted) => {
			const button = waitForGuiObject<ImageButton>(
				mounted.host,
				"Button",
				(gui) => math.abs(gui.AbsoluteSize.X - expected) <= 1 && gui.AbsoluteSize.Y > 0,
				`Timed out waiting for the Button to be ${expected}px wide`,
			);

			assertSizeApprox(button, expected, undefined, 1, `width=${width}`);
			Assert.equal(button.AutomaticSize, Enum.AutomaticSize.Y, `width=${width}: expected AutomaticSize.Y`);
			Assert.undefined(button.FindFirstChildWhichIsA("UIFlexItem"), `width=${width}: expected no UIFlexItem without fill`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With a fixed width the icon and label row is centred horizontally inside the wider button")
	@Test
	public widthCentersRow() {
		withMounted(HOST_WIDTH, 200, <Button text="Go" width={240} />, (mounted) => {
			const button = waitForGuiObject<ImageButton>(
				mounted.host,
				"Button",
				(gui) => math.abs(gui.AbsoluteSize.X - 240) <= 1,
			);
			const label = waitForGuiObject<TextLabel>(button, "ButtonText");

			assertCenteredIn(label, button, "x", 1, "width=240 label");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Three fill Buttons with different label lengths share an HStack row at equal widths")
	@Test
	public fillSharesEqually() {
		withMounted(HOST_WIDTH, 200, fillRow(), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const buttons = waitForLayout(() => {
				const found: ImageButton[] = [];
				for (const name of FILL_NAMES) {
					const button = stack.FindFirstChild(name) as ImageButton | undefined;
					if (button === undefined) return undefined;
					found.push(button);
				}

				const first = found[0].AbsoluteSize.X;
				const settled = found.every((button) => button.AbsoluteSize.X > 0 && math.abs(button.AbsoluteSize.X - first) <= 1);
				return settled ? found : undefined;
			}, "Timed out waiting for the three fill Buttons to settle at equal widths");

			for (const button of buttons) {
				const flexItem = button.FindFirstChild("FlexItem") as UIFlexItem | undefined;
				Assert.notUndefined(flexItem, `Expected ${button.Name} to have a UIFlexItem named FlexItem`);
				Assert.equal(flexItem!.FlexMode, Enum.UIFlexMode.Fill, `Expected ${button.Name}'s FlexItem to use FlexMode Fill`);
			}

			const last = rect(buttons[buttons.size() - 1]);
			Assert.true(
				math.abs(last.right - rect(stack).right) <= 1,
				`Expected the fill row to reach the stack's right edge, last button ends at ${last.right} vs ${rect(stack).right}`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without width or fill the Button keeps AutomaticSize.XY and no UIFlexItem")
	@Test
	public autoUnchanged() {
		withMounted(HOST_WIDTH, 200, <Button text="Save" />, (mounted) => {
			const button = waitForGuiObject<ImageButton>(mounted.host, "Button");

			Assert.equal(button.AutomaticSize, Enum.AutomaticSize.XY);
			Assert.undefined(button.FindFirstChildWhichIsA("UIFlexItem"));
			Assert.true(button.AbsoluteSize.X < HOST_WIDTH, "Expected an auto-sized Button to stay narrower than the host");
		});
	}
}

export = ButtonSizingValidation;
