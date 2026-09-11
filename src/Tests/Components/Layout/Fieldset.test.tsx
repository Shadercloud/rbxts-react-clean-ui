import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Fieldset } from "../../../Components/Layout/Fieldset";
import { VStack } from "../../../Components/Layout/VStack";
import { Text } from "../../../Components/Typography/Text";
import { Breakpoint } from "../../../Interfaces/";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAlignedRight,
	assertAllDescendantsContained,
	assertSizeApprox,
	assertStackedHorizontally,
	findDescendant,
	rect,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const WIDE_HOST = 600;
const HOST_HEIGHT = 200;
const CONTROL_WIDTH = 120;
const CONTROL_HEIGHT = 32;

function fieldset(props: { checkbox?: boolean; wrap?: Breakpoint } = {}) {
	return (
		<frame key="Form" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
			<VStack>
				<Fieldset checkbox={props.checkbox} wrap={props.wrap}>
					<Fieldset.Label>
						<Text text="Label" />
					</Fieldset.Label>
					<Fieldset.Control>
						<frame key="ControlContent" BackgroundTransparency={1} Size={UDim2.fromOffset(CONTROL_WIDTH, CONTROL_HEIGHT)} />
					</Fieldset.Control>
				</Fieldset>
			</VStack>
		</frame>
	);
}

function waitForFieldset(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		host,
		"Fieldset",
		(gui) => gui.AbsoluteSize.X === WIDE_HOST,
		`Timed out waiting for the Fieldset to be stretched to the ${WIDE_HOST}px host width`,
	);
}

function findLabelButton(root: Instance): ImageButton {
	return findDescendant<ImageButton>(root, "FieldsetLabelButton");
}

function findControlContent(root: Instance): Frame {
	return findDescendant<Frame>(root, "ControlContent");
}

function parentGui(instance: Instance): GuiObject {
	const parent = instance.Parent;
	Assert.notUndefined(parent, `Expected ${instance.GetFullName()} to have a parent`);
	Assert.true(parent!.IsA("GuiObject"), `Expected the parent of ${instance.GetFullName()} to be a GuiObject`);
	return parent! as GuiObject;
}

@Tag("Studio")
class FieldsetMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("At 600px the label and control sit side by side, label first, starting at the Fieldset's left edge")
	@Test
	public inlineAtWideWidth() {
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), (mounted) => {
			const root = waitForFieldset(mounted.host);
			const label = waitForGuiObject<ImageButton>(root, "FieldsetLabelButton");
			const control = waitForGuiObject<Frame>(root, "ControlContent");

			assertAlignedLeft(label, root, 1, "inline fieldset");
			assertStackedHorizontally([label, control], "inline fieldset");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In the default mode Fieldset.Control grows to the Fieldset's right edge while the label keeps its own width")
	@Test
	public controlFillsRemainingWidth() {
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), (mounted) => {
			const root = waitForFieldset(mounted.host);
			waitForGuiObject<Frame>(root, "ControlContent");
			const labelSlot = parentGui(findLabelButton(root));
			const controlSlot = parentGui(findControlContent(root));

			waitForLayout(
				() => (rect(controlSlot).right >= rect(root).right - 1 ? true : undefined),
				"Timed out waiting for Fieldset.Control's FlexItem to grow to the Fieldset's right edge",
			);

			assertAlignedRight(controlSlot, root, 1, "control slot");
			Assert.true(
				rect(controlSlot).width > rect(labelSlot).width,
				`Expected the control slot (${rect(controlSlot).width}px) to be wider than the label slot (${rect(labelSlot).width}px)`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("checkbox={true} keeps Fieldset.Control at its content width instead of growing")
	@Test
	public checkboxControlKeepsContentWidth() {
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset({ checkbox: true }), (mounted) => {
			const root = waitForFieldset(mounted.host);
			waitForGuiObject<Frame>(root, "ControlContent");
			const controlSlot = parentGui(findControlContent(root));

			assertSizeApprox(controlSlot, CONTROL_WIDTH, undefined, 1, "checkbox control slot");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[600, "lg", false],
		[250, "lg", true],
		[250, "xs", false],
	])
	@DisplayName("The HStack's Wraps flag is on only when the Fieldset's breakpoint is at or below the wrap prop")
	@Test
	public wrapFollowsBreakpoint(hostWidth: number, wrap: Breakpoint, expectedWraps: boolean) {
		withMounted(hostWidth, HOST_HEIGHT, fieldset({ wrap }), (mounted) => {
			const root = waitForGuiObject<ImageLabel>(mounted.host, "Fieldset", (gui) => gui.AbsoluteSize.X === hostWidth);

			waitForDescendant<UIListLayout>(
				root,
				"HStack",
				(layout) => layout.Wraps === expectedWraps,
				`Timed out waiting for the Fieldset's UIListLayout to report Wraps=${expectedWraps} at ${hostWidth}px with wrap="${wrap}"`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every visible descendant of an inline Fieldset stays inside it")
	@Test
	public allContained() {
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), (mounted) => {
			const root = waitForFieldset(mounted.host);
			waitForGuiObject<Frame>(root, "ControlContent");

			assertAllDescendantsContained(root, "fieldset");
		});
	}
}

export = FieldsetMountValidation;
