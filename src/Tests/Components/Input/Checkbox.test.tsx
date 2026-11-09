import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Checkbox } from "../../../Components/Input/Checkbox";
import { FieldsetContext } from "../../../Components/Layout";
import { DefaultTheme } from "../../../Theme";
import { activateButton } from "../../Helpers/fiber";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertSizeApprox,
	findDescendant,
	settleFrames,
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

function assertShowsChecked(checkbox: Instance, expected: boolean, label: string) {
	const icon = findIcon(checkbox);

	Assert.equal(
		icon.Image !== "",
		expected,
		`${label}: expected CheckboxIcon.Image to be ${expected ? "set" : "empty"}, got "${icon.Image}"`,
	);
}

function recorder(values: boolean[]) {
	return (value: boolean) => {
		values.push(value);
	};
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
	@DisplayName("Mounting a controlled Checkbox shows the checked prop and never calls onChange")
	@Test
	public silentControlledMount(variant: string, checked: boolean) {
		const values: boolean[] = [];

		withMounted(200, 200, <Checkbox checked={checked} onChange={recorder(values)} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);
			settleFrames(3);

			Assert.deepEqual(values, [], `${variant}: expected no onChange on mount`);
			assertShowsChecked(checkbox, checked, variant);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["defaultChecked", true],
		["defaultUnchecked", false],
	])
	@DisplayName("An uncontrolled Checkbox starts at defaultChecked without calling onChange")
	@Test
	public defaultCheckedSeeds(variant: string, defaultChecked: boolean) {
		const values: boolean[] = [];

		withMounted(
			200,
			200,
			<Checkbox defaultChecked={defaultChecked} onChange={recorder(values)} />,
			(mounted) => {
				const checkbox = waitForCheckbox(mounted.host);
				settleFrames(3);

				Assert.deepEqual(values, [], `${variant}: expected no onChange on mount`);
				assertShowsChecked(checkbox, defaultChecked, variant);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clicking a controlled Checkbox reports the flipped value but keeps showing the prop until it changes")
	@Test
	public controlledClickReports() {
		const values: boolean[] = [];

		withMounted(200, 200, <Checkbox checked={false} onChange={recorder(values)} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);

			activateButton(mounted, checkbox);
			settleFrames(3);

			Assert.deepEqual(values, [true]);
			assertShowsChecked(checkbox, false, "after click, before the prop changes");

			mounted.update(<Checkbox checked={true} onChange={recorder(values)} />);
			settleFrames(2);

			assertShowsChecked(checkbox, true, "after the prop changes");
			Assert.deepEqual(values, [true], "Expected the prop change not to call onChange");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Flipping a controlled checked prop re-renders the icon without calling onChange")
	@Test
	public propChangeSilent() {
		const values: boolean[] = [];

		withMounted(200, 200, <Checkbox checked={false} onChange={recorder(values)} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);

			mounted.update(<Checkbox checked={true} onChange={recorder(values)} />);
			settleFrames(2);
			assertShowsChecked(checkbox, true, "checked prop on");

			mounted.update(<Checkbox checked={false} onChange={recorder(values)} />);
			settleFrames(2);
			assertShowsChecked(checkbox, false, "checked prop off");

			Assert.deepEqual(values, []);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clicking an uncontrolled Checkbox flips its own state and reports each new value")
	@Test
	public uncontrolledClickToggles() {
		const values: boolean[] = [];

		withMounted(200, 200, <Checkbox onChange={recorder(values)} />, (mounted) => {
			const checkbox = waitForCheckbox(mounted.host);

			activateButton(mounted, checkbox);
			Assert.deepEqual(values, [true]);
			assertShowsChecked(checkbox, true, "after first click");

			activateButton(mounted, checkbox);
			Assert.deepEqual(values, [true, false]);
			assertShowsChecked(checkbox, false, "after second click");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Firing the Fieldset labelActivated event toggles an uncontrolled checkbox on and reports true")
	@Test
	public fieldsetLabelToggles() {
		const labelActivated = new Instance("BindableEvent");
		const values: boolean[] = [];

		try {
			withMounted(
				200,
				200,
				<FieldsetContext.Provider value={{ disabled: false, checkbox: true, labelActivated }}>
					<Checkbox onChange={recorder(values)} />
				</FieldsetContext.Provider>,
				(mounted) => {
					const checkbox = waitForCheckbox(mounted.host);
					settleFrames(2);
					Assert.deepEqual(values, [], "Expected no onChange before the label is activated");

					labelActivated.Fire();

					waitForLayout(
						() => (values.size() >= 1 ? true : undefined),
						"Timed out waiting for onChange to fire after labelActivated",
					);
					settleFrames(1);

					Assert.deepEqual(values, [true]);
					assertShowsChecked(checkbox, true, "after labelActivated");
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
