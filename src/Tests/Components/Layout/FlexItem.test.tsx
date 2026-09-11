import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { FlexItem } from "../../../Components/Layout/FlexItem";
import { HStack } from "../../../Components/Layout/HStack";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAlignedRight,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertSizeApprox,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const STACK_WIDTH = 400;
const STACK_HEIGHT = 100;
const FIXED_WIDTH = 100;
const REMAINING_WIDTH = STACK_WIDTH - FIXED_WIDTH;
const ITEM_HEIGHT = 40;

type FlexAlign = "Left" | "Center" | "Right";

function stackWithFlexItem(flexItem: React.ReactElement) {
	return (
		<frame key="Stack" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<HStack spacing="None" Wraps={false}>
				<frame key="Fixed" BackgroundTransparency={1} Size={UDim2.fromOffset(FIXED_WIDTH, ITEM_HEIGHT)} LayoutOrder={1} />
				{flexItem}
			</HStack>
		</frame>
	);
}

function child() {
	return <frame key="Child" BackgroundTransparency={1} Size={UDim2.fromOffset(50, 20)} />;
}

function waitForGrownFlexItem(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		host,
		"FlexItem",
		(gui) => gui.AbsoluteSize.X === REMAINING_WIDTH,
		`Timed out waiting for the FlexItem to grow to the remaining ${REMAINING_WIDTH}px`,
	);
}

@Tag("Studio")
class FlexItemMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With the default Grow mode the FlexItem claims all width left over by its fixed sibling")
	@Test
	public growsToFillRemaining() {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			stackWithFlexItem(
				<FlexItem LayoutOrder={2} Size={new UDim2(0, 0, 0, ITEM_HEIGHT)}>
					{child()}
				</FlexItem>,
			),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const flexItem = waitForGrownFlexItem(stack);

				assertSizeApprox(flexItem, REMAINING_WIDTH, ITEM_HEIGHT, 1, "grown flex item");
				assertAlignedRight(flexItem, stack, 1, "grown flex item");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("mode=None leaves the FlexItem at its own explicit Size instead of growing")
	@Test
	public modeNoneKeepsOwnSize() {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			stackWithFlexItem(
				<FlexItem LayoutOrder={2} mode="None" Size={new UDim2(0, 80, 0, ITEM_HEIGHT)}>
					{child()}
				</FlexItem>,
			),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const flexItem = waitForGuiObject<ImageLabel>(stack, "FlexItem");

				assertSizeApprox(flexItem, 80, ITEM_HEIGHT, 1, "mode=None flex item");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["Left"], ["Center"], ["Right"]])
	@DisplayName("The align prop places the FlexItem's child at the matching horizontal edge or center of the grown item")
	@Test
	public alignPlacesChild(align: FlexAlign) {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			stackWithFlexItem(
				<FlexItem LayoutOrder={2} align={align} Size={new UDim2(0, 0, 0, ITEM_HEIGHT)}>
					{child()}
				</FlexItem>,
			),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const flexItem = waitForGrownFlexItem(stack);
				const inner = waitForGuiObject<Frame>(flexItem, "Child");

				if (align === "Left") {
					assertAlignedLeft(inner, flexItem, 1, "align=Left");
				} else if (align === "Right") {
					assertAlignedRight(inner, flexItem, 1, "align=Right");
				} else {
					assertCenteredIn(inner, flexItem, "x", 1, "align=Center");
				}
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every visible descendant of a grown FlexItem stays inside it")
	@Test
	public allContained() {
		withMounted(
			STACK_WIDTH,
			STACK_HEIGHT,
			stackWithFlexItem(
				<FlexItem LayoutOrder={2} Size={new UDim2(0, 0, 0, ITEM_HEIGHT)}>
					{child()}
				</FlexItem>,
			),
			(mounted) => {
				const stack = waitForGuiObject<Frame>(mounted.host, "Stack");
				const flexItem = waitForGrownFlexItem(stack);
				waitForGuiObject<Frame>(flexItem, "Child");

				assertAllDescendantsContained(flexItem, "flex item children");
			},
		);
	}
}

export = FlexItemMountValidation;
