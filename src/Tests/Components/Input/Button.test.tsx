import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Button } from "../../../Components/Input/Button";
import { Group, HStack } from "../../../Components/Layout";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertStackedHorizontally,
	assertTextFits,
	findDescendant,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

function waitForButton(host: Instance, name = "Button"): ImageButton {
	return waitForGuiObject<ImageButton>(host, name);
}

@Tag("Studio")
class ButtonMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With an icon and text, the Button auto-sizes and every visible descendant stays inside it")
	@Test
	public mountsContained() {
		withMounted(400, 200, <Button text="Save changes" icon="check" />, (mounted) => {
			const button = waitForButton(mounted.host);

			assertNonZeroSize(button, "icon + text button");
			assertAllDescendantsContained(button, "icon + text button");

			const label = findDescendant<TextLabel>(button, "ButtonText");
			Assert.equal(label.Text, "Save changes");
			assertTextFits(label, "icon + text button");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The icon renders to the left of the label without overlapping it")
	@Test
	public iconLeadsText() {
		withMounted(400, 200, <Button text="Save changes" icon="check" />, (mounted) => {
			const button = waitForButton(mounted.host);
			const icon = waitForGuiObject<ImageLabel>(button, "ButtonIcon");
			const label = waitForGuiObject<TextLabel>(button, "ButtonText");

			assertStackedHorizontally([icon, label], "icon + text row");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("disabled={true} sets the root ImageButton inactive, and re-enabling restores Active")
	@Test
	public disabledInert() {
		withMounted(400, 200, <Button text="Submit" disabled={true} />, (mounted) => {
			const button = waitForButton(mounted.host);
			Assert.false(button.Active, "Expected a disabled Button's root ImageButton to have Active=false");

			mounted.update(<Button text="Submit" />);

			waitForLayout(
				() => (button.Active ? true : undefined),
				"Timed out waiting for the Button to become Active again after disabled was removed",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Two grouped Buttons with different label lengths settle on the same width")
	@Test
	public groupAlignsWidths() {
		withMounted(
			400,
			200,
			<Group>
				<HStack>
					<Button name="ShortButton" group={true} text="OK" />
					<Button name="LongButton" group={true} text="A considerably longer label" />
				</HStack>
			</Group>,
			(mounted) => {
				const short = waitForButton(mounted.host, "ShortButton");
				const long = waitForButton(mounted.host, "LongButton");

				waitForLayout(
					() => (rect(short).width > 0 && rect(short).width === rect(long).width ? true : undefined),
					`Timed out waiting for grouped buttons to share a width (short=${rect(short).width}, long=${rect(long).width})`,
				);

				assertAllDescendantsContained(short, "grouped short button");
				assertAllDescendantsContained(long, "grouped long button");
			},
		);
	}
}

export = ButtonMountValidation;
