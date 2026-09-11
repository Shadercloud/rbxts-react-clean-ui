import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Tabs } from "../../../Components/Layout/Tabs";
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertStackedHorizontally,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const TAB_VALUES = ["one", "two", "three"];

function tabsFixture(defaultValue?: string) {
	return (
		<Tabs defaultValue={defaultValue}>
			<Tabs.List>
				<Tabs.Title value="one" text="One" />
				<Tabs.Title value="two" text="Two" />
				<Tabs.Title value="three" text="Three" />
			</Tabs.List>
			<Tabs.Body>
				<Tabs.Content value="one">
					<Text text="Panel one" />
				</Tabs.Content>
				<Tabs.Content value="two">
					<Text text="Panel two" />
				</Tabs.Content>
				<Tabs.Content value="three">
					<Text text="Panel three" />
				</Tabs.Content>
			</Tabs.Body>
		</Tabs>
	);
}

function waitForSelectedContent(host: Instance, value: string): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		host,
		`TabContent_${value}`,
		(gui) => gui.Visible && gui.AbsoluteSize.X > 0,
		`Timed out waiting for TabContent_${value} to become the visible panel`,
	);
}

function getVisiblePanels(host: Instance): string[] {
	const visible: string[] = [];
	for (const value of TAB_VALUES) {
		const panel = host.FindFirstChild(`TabContent_${value}`, true) as ImageLabel | undefined;
		if (panel !== undefined && panel.Visible) visible.push(value);
	}
	return visible;
}

function assertOnlySelectedVisible(host: Instance, selected: string) {
	for (const value of TAB_VALUES) {
		const panel = findDescendant<ImageLabel>(host, `TabContent_${value}`);

		Assert.equal(
			panel.Visible,
			value === selected,
			`Expected TabContent_${value} Visible to be ${value === selected} while "${selected}" is selected`,
		);
	}
}

@Tag("Studio")
class TabsMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without defaultValue the first declared tab claims the selection, so only its panel is visible and the rest stay mounted but hidden")
	@Test
	public firstTabSelectedByDefault() {
		withMounted(400, 300, tabsFixture(), (mounted) => {
			const visible = waitForLayout(() => {
				const panels = getVisiblePanels(mounted.host);
				return panels.size() === 1 ? panels : undefined;
			}, "Timed out waiting for exactly one TabContent panel to become visible");

			Assert.equal(
				visible[0],
				"one",
				`Expected the first declared tab "one" to be selected without a defaultValue, but "${visible[0]}" was visible`,
			);

			assertOnlySelectedVisible(mounted.host, "one");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("defaultValue seeds the selection so a non-first tab's panel is the one shown")
	@Test
	public defaultValueSelectsTab() {
		withMounted(400, 300, tabsFixture("two"), (mounted) => {
			waitForSelectedContent(mounted.host, "two");

			assertOnlySelectedVisible(mounted.host, "two");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Tab buttons are laid out left-to-right in declaration order inside the list")
	@Test
	public titlesInOrder() {
		withMounted(400, 300, tabsFixture("one"), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = findDescendant<ImageLabel>(mounted.host, "TabsList");
			const buttons: GuiObject[] = [];
			for (const value of TAB_VALUES) {
				const button = waitForGuiObject<ImageButton>(list, `TabButton-${value}`);
				Assert.equal(button.Parent, list, `Expected TabButton-${value} to be a direct child of TabsList`);
				buttons.push(button);
			}

			assertStackedHorizontally(buttons, "tab buttons");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The list, the body and every visible descendant of each stay inside their container and the host")
	@Test
	public contentsContained() {
		withMounted(400, 300, tabsFixture("one"), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = waitForGuiObject<ImageLabel>(mounted.host, "TabsList");
			const body = waitForGuiObject<ImageLabel>(mounted.host, "TabsBody");

			assertContained(list, mounted.host, "list vs host");
			assertContained(body, mounted.host, "body vs host");
			assertAllDescendantsContained(list, "tabs list");
			assertAllDescendantsContained(body, "tabs body");
		});
	}
}

export = TabsMountValidation;
