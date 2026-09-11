import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Select } from "../../../Components/Input/Select";
import { FieldsetContext } from "../../../Components/Layout";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	findDescendant,
	rect,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const OPTIONS = ["Alpha", "Beta", "Gamma"];

function selectWithOptions(props: { selected?: number } = {}) {
	return (
		<Select selected={props.selected}>
			{OPTIONS.map((text) => (
				<Select.Option key={text} text={text} />
			))}
		</Select>
	);
}

function waitForSelect(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Select");
}

function findSelectedText(selectRoot: Instance): TextLabel {
	return findDescendant<TextLabel>(selectRoot, "SelectedText");
}

@Tag("Studio")
class SelectMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With three options and no selected prop, the closed control shows the first option and stays self-contained")
	@Test
	public mountsContained() {
		withMounted(400, 200, selectWithOptions(), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			assertNonZeroSize(selectRoot, "closed selectRoot");
			Assert.equal(findSelectedText(selectRoot).Text, "Alpha");
			assertAllDescendantsContained(selectRoot, "closed selectRoot");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("selected={2} seeds the closed control with the third option's text")
	@Test
	public seedsFromSelected() {
		withMounted(400, 200, selectWithOptions({ selected: 2 }), (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(findSelectedText(selectRoot).Text, "Gamma");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no Select.Option children the closed control falls back to \"No Options\"")
	@Test
	public noOptionsFallback() {
		withMounted(400, 200, <Select />, (mounted) => {
			const selectRoot = waitForSelect(mounted.host);

			Assert.equal(findSelectedText(selectRoot).Text, "No Options");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Firing the Fieldset labelActivated event opens the dropdown directly below the control with every option inside it, and firing again closes it")
	@Test
	public labelTogglesDropdown() {
		const labelActivated = new Instance("BindableEvent");

		try {
			withMounted(
				400,
				400,
				<OverlayProvider>
					<FieldsetContext.Provider value={{ disabled: false, checkbox: false, labelActivated }}>
						{selectWithOptions()}
					</FieldsetContext.Provider>
				</OverlayProvider>,
				(mounted) => {
					const selectRoot = waitForSelect(mounted.host);
					const control = waitForGuiObject<ImageButton>(selectRoot, "SelectButton");
					waitForGuiObject<Frame>(mounted.host, "OverlayProvider");

					Assert.undefined(mounted.host.FindFirstChild("SelectDropdown", true));

					labelActivated.Fire();

					const dropdown = waitForGuiObject<Frame>(mounted.host, "SelectDropdown");

					const controlRect = rect(control);
					const dropdownRect = rect(dropdown);
					Assert.true(
						math.abs(dropdownRect.top - controlRect.bottom) <= 1,
						`Expected the dropdown top (${dropdownRect.top}) to sit at the control's bottom edge (${controlRect.bottom})`,
					);
					Assert.true(
						math.abs(dropdownRect.width - controlRect.width) <= 1,
						`Expected the dropdown width (${dropdownRect.width}) to match the control width (${controlRect.width})`,
					);

					waitForLayout(() => {
						const options = dropdown.GetDescendants().filter((d) => d.Name === "Option" && d.IsA("GuiObject"));
						return options.size() === OPTIONS.size() && options.every((o) => (o as GuiObject).AbsoluteSize.Y > 0) ? true : undefined;
					}, `Timed out waiting for ${OPTIONS.size()} laid-out options inside the dropdown`);

					assertAllDescendantsContained(dropdown, "open dropdown");

					labelActivated.Fire();

					waitForLayout(
						() => (mounted.host.FindFirstChild("SelectDropdown", true) === undefined ? true : undefined),
						"Timed out waiting for the dropdown to close after a second labelActivated",
					);
				},
			);
		} finally {
			labelActivated.Destroy();
		}
	}
}

export = SelectMountValidation;
