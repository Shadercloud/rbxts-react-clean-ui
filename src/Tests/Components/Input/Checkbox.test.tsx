import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Checkbox } from "../../../Components/Input/Checkbox";
import { FieldsetContext } from "../../../Components/Layout";
import { DefaultTheme } from "../../../Theme";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertSizeApprox,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

function waitForCheckbox(host: Instance): ImageButton {
	return waitForGuiObject<ImageButton>(host, "Checkbox");
}

function findIcon(checkbox: Instance): ImageLabel {
	return findDescendant<ImageLabel>(checkbox, "CheckboxIcon");
}

@Tag("Studio")
class CheckboxMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A checked Checkbox auto-sizes around its icon and keeps every visible descendant inside itself")
	@Test
	public mountsContained() {
		withMounted(200, 200, <Checkbox checked={true} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);

			assertNonZeroSize(checkbox, "checked checkbox");
			assertAllDescendantsContained(checkbox, "checked checkbox");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["checked", true],
		["unchecked", false],
	])
	@DisplayName("Mounting fires onChange exactly once with the seeded checked value, and only the checked state shows an icon image")
	@Test
	public seedsFromChecked(variant: string, checked: boolean) {
		const onChangeValues: boolean[] = [];

		withMounted(
			200,
			200,
			<Checkbox
				checked={checked}
				onChange={(value) => {
					onChangeValues.push(value);
				}}
			/>,
			(mounted) => {
				const checkbox = waitForCheckbox(mounted.host);
				const icon = findIcon(checkbox);

				Assert.deepEqual(onChangeValues, [checked]);

				Assert.equal(
					icon.Image !== "",
					checked,
					`${variant}: expected CheckboxIcon.Image to be ${checked ? "set" : "empty"}, got "${icon.Image}"`,
				);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Firing the Fieldset labelActivated event toggles the checkbox on, firing onChange with true and showing the check icon")
	@Test
	public labelToggles() {
		const labelActivated = new Instance("BindableEvent");
		const onChangeValues: boolean[] = [];

		try {
			withMounted(
				200,
				200,
				<FieldsetContext.Provider value={{ disabled: false, checkbox: true, labelActivated }}>
					<Checkbox
						onChange={(value) => {
							onChangeValues.push(value);
						}}
					/>
				</FieldsetContext.Provider>,
				(mounted) => {
					const checkbox = waitForCheckbox(mounted.host);
					const icon = findIcon(checkbox);

					Assert.deepEqual(onChangeValues, [false]);
					Assert.equal(icon.Image, "", "Expected no icon image before the label is activated");

					labelActivated.Fire();

					waitForLayout(
						() => (onChangeValues.size() >= 2 ? true : undefined),
						"Timed out waiting for onChange to fire after labelActivated",
					);

					Assert.deepEqual(onChangeValues, [false, true]);
					Assert.true(icon.Image !== "", "Expected the check icon to render once toggled on");
				},
			);
		} finally {
			labelActivated.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["xs"], ["xl"]])
	@DisplayName("The scale prop sizes the icon to the theme's iconSize entry for that scale")
	@Test
	public scaleSizesIcon(scale: "xs" | "xl") {
		withMounted(200, 200, <Checkbox checked={true} scale={scale} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);
			const icon = waitForGuiObject<ImageLabel>(checkbox, "CheckboxIcon");
			const expected = DefaultTheme.iconSize[scale];
			Assert.notUndefined(expected, `Expected DefaultTheme.iconSize to define an entry for scale "${scale}"`);

			assertSizeApprox(icon, expected!, expected!, 0, `scale=${scale} icon`);
			assertAllDescendantsContained(checkbox, `scale=${scale} checkbox`);
		});
	}
}

export = CheckboxMountValidation;
