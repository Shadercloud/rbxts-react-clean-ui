import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { VStack } from "../../../Components/Layout/VStack";
import { ScaleSize } from "../../../Interfaces/";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedTop,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertSizeApprox,
	assertStackedVertically,
	describeGui,
	findDescendant,
	rect,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const STACK_WIDTH = 300;
const STACK_HEIGHT = 400;
const CHILD_WIDTH = 60;
const CHILD_HEIGHT = 30;

function stackChild(name: string, order: number) {
	return <frame key={name} BackgroundTransparency={1} Size={UDim2.fromOffset(CHILD_WIDTH, CHILD_HEIGHT)} LayoutOrder={order} />;
}

function vstack(
	children: React.ReactNode,
	props: { spacing?: ScaleSize | "None"; valign?: "Center"; HorizontalAlignment?: Enum.HorizontalAlignment; HorizontalFlex?: Enum.UIFlexAlignment } = {},
) {
	return (
		<frame key="Stack" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<VStack spacing={props.spacing} valign={props.valign} HorizontalAlignment={props.HorizontalAlignment} HorizontalFlex={props.HorizontalFlex}>
				{children}
			</VStack>
		</frame>
	);
}

function threeChildren() {
	return (
		<>
			{stackChild("First", 1)}
			{stackChild("Second", 2)}
			{stackChild("Third", 3)}
		</>
	);
}

function assertVerticalGap(above: GuiObject, below: GuiObject, expectedGap: number, label: string) {
	const gap = rect(below).top - rect(above).bottom;

	Assert.true(
		math.abs(gap - expectedGap) <= 1,
		`${label}: expected a ${expectedGap}px gap between ${describeGui(above)} and ${describeGui(below)}, got ${gap}px`,
	);
}

@Tag("Studio")
class VStackMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Children are laid out top-to-bottom in LayoutOrder, starting at the stack's top edge")
	@Test
	public childrenInOrder() {
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const first = waitForGuiObject<Frame>(stack, "First");
			const second = findDescendant<Frame>(stack, "Second");
			const third = findDescendant<Frame>(stack, "Third");

			assertAlignedTop(first, stack, 1, "vstack order");
			assertStackedVertically([first, second, third], "vstack order");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["None", 0],
		["md", 12],
		["xl", 24],
	])
	@DisplayName("The gap between siblings equals the theme spacing value for the given spacing key")
	@Test
	public gapMatchesSpacing(spacing: ScaleSize | "None", expectedGap: number) {
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren(), { spacing }), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const first = waitForGuiObject<Frame>(stack, "First");
			const second = findDescendant<Frame>(stack, "Second");
			const third = findDescendant<Frame>(stack, "Third");

			assertVerticalGap(first, second, expectedGap, `spacing=${spacing}`);
			assertVerticalGap(second, third, expectedGap, `spacing=${spacing}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The default HorizontalFlex=Fill stretches a fixed-width child to the full stack width")
	@Test
	public fillStretchesChildren() {
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const first = waitForGuiObject<Frame>(stack, "First", (gui) => gui.AbsoluteSize.X === STACK_WIDTH, "Timed out waiting for the first child to be stretched to the stack width");

			assertSizeApprox(first, STACK_WIDTH, CHILD_HEIGHT, 1, "fill-stretched child");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With HorizontalFlex=None, valign=Center and HorizontalAlignment=Center place a lone child in the middle of the stack")
	@Test
	public centerAlignment() {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			vstack(stackChild("Only", 1), {
				valign: "Center",
				HorizontalAlignment: Enum.HorizontalAlignment.Center,
				HorizontalFlex: Enum.UIFlexAlignment.None,
			}),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const only = waitForGuiObject<Frame>(stack, "Only");

				assertSizeApprox(only, CHILD_WIDTH, CHILD_HEIGHT, 1, "centered vstack child");
				assertCenteredIn(only, stack, "both", 1, "centered vstack child");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With default props every visible child stays inside the stack's parent frame")
	@Test
	public allContained() {
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			waitForGuiObject<Frame>(stack, "Third");

			assertAllDescendantsContained(stack, "vstack children");
		});
	}
}

export = VStackMountValidation;
