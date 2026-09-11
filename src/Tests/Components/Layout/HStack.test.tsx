import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { HStack } from "../../../Components/Layout/HStack";
import { ScaleSize } from "../../../Interfaces/";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertStackedHorizontally,
	describeGui,
	findDescendant,
	rect,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const STACK_WIDTH = 400;
const STACK_HEIGHT = 200;

function stackChild(name: string, order: number) {
	return <frame key={name} BackgroundTransparency={1} Size={UDim2.fromOffset(60, 30)} LayoutOrder={order} />;
}

function hstack(
	children: React.ReactNode,
	props: { spacing?: ScaleSize | "None"; valign?: "Center"; HorizontalAlignment?: Enum.HorizontalAlignment } = {},
) {
	return (
		<frame key="Stack" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<HStack spacing={props.spacing} valign={props.valign} HorizontalAlignment={props.HorizontalAlignment}>
				{children}
			</HStack>
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

function assertHorizontalGap(leading: GuiObject, trailing: GuiObject, expectedGap: number, label: string) {
	const gap = rect(trailing).left - rect(leading).right;

	Assert.true(
		math.abs(gap - expectedGap) <= 1,
		`${label}: expected a ${expectedGap}px gap between ${describeGui(leading)} and ${describeGui(trailing)}, got ${gap}px`,
	);
}

@Tag("Studio")
class HStackMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Children are laid out left-to-right in LayoutOrder, starting at the stack's left edge")
	@Test
	public childrenInOrder() {
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren()), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const first = waitForGuiObject<Frame>(stack, "First");
			const second = findDescendant<Frame>(stack, "Second");
			const third = findDescendant<Frame>(stack, "Third");

			assertAlignedLeft(first, stack, 1, "hstack order");
			assertStackedHorizontally([first, second, third], "hstack order");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["None", 0],
		["md", 6],
		["xl", 12],
	])
	@DisplayName("The gap between siblings is half the theme spacing value for the given spacing key")
	@Test
	public gapMatchesSpacing(spacing: ScaleSize | "None", expectedGap: number) {
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren(), { spacing }), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			const first = waitForGuiObject<Frame>(stack, "First");
			const second = findDescendant<Frame>(stack, "Second");
			const third = findDescendant<Frame>(stack, "Third");

			assertHorizontalGap(first, second, expectedGap, `spacing=${spacing}`);
			assertHorizontalGap(second, third, expectedGap, `spacing=${spacing}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("valign=Center with HorizontalAlignment=Center places a lone child in the middle of the stack")
	@Test
	public centerAlignment() {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			hstack(stackChild("Only", 1), { valign: "Center", HorizontalAlignment: Enum.HorizontalAlignment.Center }),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const only = waitForGuiObject<Frame>(stack, "Only");

				assertCenteredIn(only, stack, "both", 1, "centered hstack child");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With default props every visible child stays inside the stack's parent frame")
	@Test
	public allContained() {
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren()), (mounted) => {
			const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
			waitForGuiObject<Frame>(stack, "Third");

			assertAllDescendantsContained(stack, "hstack children");
		});
	}
}

export = HStackMountValidation;
