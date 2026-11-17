import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Select } from "../../../Components/Input/Select";
import { OverlayProvider } from "../../../Providers/overlay.provider";
import { activateButton } from "../../Helpers/fiber";
import {
	MountedElement,
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const SEPARATOR = "|";
const OPTIONS = ["École", "Été", "CAFÉ", "Москва", "Alpha", "Beta"];

function searchableSelect() {
	return (
		<OverlayProvider>
			<Select searchable>
				{OPTIONS.map((text) => (
					<Select.Option key={text} text={text} />
				))}
			</Select>
		</OverlayProvider>
	);
}

function openDropdown(mounted: MountedElement): Frame {
	const selectRoot = waitForGuiObject<ImageLabel>(mounted.host, "Select");
	waitForGuiObject<Frame>(mounted.host, "OverlayProvider");
	activateButton(mounted, waitForGuiObject<ImageButton>(selectRoot, "SelectButton"));
	return waitForGuiObject<Frame>(mounted.host, "SelectDropdown");
}

function searchBox(dropdown: Instance): TextBox {
	return findDescendant<TextBox>(waitForGuiObject<Frame>(dropdown, "SearchInput"), "TextBox");
}

function sortedJoin(texts: string[]): string {
	const sorted = [...texts];
	sorted.sort();
	return sorted.join(SEPARATOR);
}

function visibleOptions(dropdown: Instance): string {
	const texts: string[] = [];
	for (const descendant of dropdown.GetDescendants()) {
		if (descendant.Name === "OptionText" && descendant.IsA("TextLabel")) texts.push(descendant.Text);
	}
	return sortedJoin(texts);
}

function waitForOptions(dropdown: Instance, expected: string, label: string) {
	const wanted = sortedJoin(expected === "" ? [] : expected.split(SEPARATOR));

	for (let attempt = 0; attempt < 30; attempt++) {
		if (visibleOptions(dropdown) === wanted) return;
		task.wait();
	}

	Assert.equal(visibleOptions(dropdown), wanted, `${label}: unexpected options left in the dropdown`);
}

@Tag("Studio")
class SelectSearchValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An empty search box lists every option")
	@Test
	public emptyQueryListsAll() {
		withMounted(400, 500, searchableSelect(), (mounted) => {
			const dropdown = openDropdown(mounted);

			Assert.equal(searchBox(dropdown).Text, "");
			waitForOptions(dropdown, OPTIONS.join(SEPARATOR), "empty query");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["é", "École|Été|CAFÉ"],
		["É", "École|Été|CAFÉ"],
		["école", "École"],
		["ÉCOLE", "École"],
		["моск", "Москва"],
		["МОСКВА", "Москва"],
	])
	@DisplayName("An accented or Cyrillic query matches options regardless of the case of either side")
	@Test
	public nonAsciiIgnoresCase(query: string, expected: string) {
		withMounted(400, 500, searchableSelect(), (mounted) => {
			const dropdown = openDropdown(mounted);
			waitForOptions(dropdown, OPTIONS.join(SEPARATOR), "before typing");

			searchBox(dropdown).Text = query;

			waitForOptions(dropdown, expected, `query "${query}"`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["al", "Alpha"],
		["BET", "Beta"],
		["a", "CAFÉ|Alpha|Beta"],
		["CAF", "CAFÉ"],
	])
	@DisplayName("An ASCII query still matches case-insensitively as a substring, and does not match look-alike Cyrillic letters")
	@Test
	public asciiIgnoresCase(query: string, expected: string) {
		withMounted(400, 500, searchableSelect(), (mounted) => {
			const dropdown = openDropdown(mounted);
			waitForOptions(dropdown, OPTIONS.join(SEPARATOR), "before typing");

			searchBox(dropdown).Text = query;

			waitForOptions(dropdown, expected, `query "${query}"`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["zz"], ["ж"], ["ñ"]])
	@DisplayName("A query no option contains shows the No Results text instead of any option")
	@Test
	public noMatchShowsNoResults(query: string) {
		withMounted(400, 500, searchableSelect(), (mounted) => {
			const dropdown = openDropdown(mounted);
			waitForOptions(dropdown, OPTIONS.join(SEPARATOR), "before typing");

			searchBox(dropdown).Text = query;

			waitForOptions(dropdown, "", `query "${query}"`);
			const noResults = waitForGuiObject<TextLabel>(dropdown, "NoResultsText");
			Assert.equal(noResults.Text, "No Results");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Clearing an accented query brings every option back")
	@Test
	public clearingRestoresAll() {
		withMounted(400, 500, searchableSelect(), (mounted) => {
			const dropdown = openDropdown(mounted);
			const textBox = searchBox(dropdown);

			textBox.Text = "é";
			waitForOptions(dropdown, "École|Été|CAFÉ", "query \"é\"");
			settleFrames(2);

			textBox.Text = "";
			waitForOptions(dropdown, OPTIONS.join(SEPARATOR), "cleared query");
		});
	}
}

export = SelectSearchValidation;
