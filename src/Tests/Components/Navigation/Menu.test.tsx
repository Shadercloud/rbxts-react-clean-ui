import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Menu } from "../../../Components/Navigation/Menu";
import { Box } from "../../../Components/Surface/Box";
import { RegistryProvider } from "../../../Providers/registry.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertStackedVertically,
	assertTextFits,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const MENU_TITLE = "Main";
const ITEM_TITLES = ["Home", "Settings", "Tools"];
const STORY_ITEM_TITLES = ["New Game", "Create Character and Start", "Load Game ", "Quit"];

function menuFixture(collapsed?: boolean) {
	return (
		<RegistryProvider>
			<Menu title={MENU_TITLE} collapsed={collapsed}>
				<Menu.Item title="Home" icon="home" />
				<Menu.Item title="Settings" icon="gear" />
				<Menu.Item title="Tools" icon="gears" />
			</Menu>
		</RegistryProvider>
	);
}

function storyFixture() {
	return (
		<RegistryProvider>
			<Box width="Auto" height="100%">
				<Menu title="Main Menu">
					<Menu.Item title={STORY_ITEM_TITLES[0]} icon="plus-circle" />
					<Menu.Item title={STORY_ITEM_TITLES[1]} icon="user-plus" />
					<Menu.Item title={STORY_ITEM_TITLES[2]} icon="database" />
					<Menu.Item title={STORY_ITEM_TITLES[3]} icon="sign-out" />
				</Menu>
			</Box>
		</RegistryProvider>
	);
}

const ignoreScrollerChrome = (gui: GuiObject) => gui.IsA("ScrollingFrame") || gui.Name === "ScrollerContent";

function waitForMenu(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Menu");
}

function waitForItems(menu: Instance, expected = ITEM_TITLES.size()): ImageButton[] {
	return waitForLayout(() => {
		const first = menu.FindFirstChild("MenuItem", true);
		if (first === undefined || first.Parent === undefined) return undefined;

		const items: ImageButton[] = [];
		for (const child of first.Parent.GetChildren()) {
			if (child.IsA("ImageButton") && child.Name === "MenuItem") items.push(child);
		}

		if (items.size() !== expected) return undefined;
		return items.every((item) => item.AbsoluteSize.X > 0 && item.AbsoluteSize.Y > 0) ? items : undefined;
	}, `Timed out waiting for ${expected} laid-out MenuItem buttons`);
}

function itemLabel(item: Instance): TextLabel | undefined {
	return item.FindFirstChild("ButtonText", true) as TextLabel | undefined;
}

function widestItemWidth(items: ImageButton[]): number {
	let widest = 0;
	for (const item of items) widest = math.max(widest, item.AbsoluteSize.X);
	return widest;
}

function waitForGroupSettled(menu: Instance, items: ImageButton[]): ImageLabel {
	const header = findDescendant<ImageLabel>(menu, "MenuHeader");

	for (let attempt = 0; attempt < 30; attempt++) {
		const laidOut = items.every((item) => item.AbsoluteSize.X > 0 && item.AbsoluteSize.Y > 0);
		if (laidOut && header.AbsoluteSize.X >= widestItemWidth(items)) return header;

		task.wait();
	}

	return Assert.fail(
		`Timed out waiting for the Menu's Group to settle: MenuHeader is ${header.AbsoluteSize.X}px wide but the widest MenuItem is ${widestItemWidth(items)}px`,
	);
}

@Tag("Studio")
class MenuMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Expanded, the title is shown and the items render top-to-bottom in declaration order with their labels")
	@Test
	public itemsRenderInOrder() {
		withMounted(300, 400, menuFixture(), (mounted) => {
			const menu = waitForMenu(mounted.host);
			const items = waitForItems(menu);

			const title = findDescendant<TextLabel>(menu, "MenuTitle");
			Assert.equal(title.Text, MENU_TITLE);

			const labels: string[] = [];
			for (const item of items) {
				const label = itemLabel(item);
				Assert.notUndefined(label, `Expected a ButtonText label under ${item.GetFullName()}`);
				labels.push(label!.Text);
			}
			Assert.deepEqual(labels, ITEM_TITLES);

			assertStackedVertically(items, "menu items");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every visible descendant stays inside the Menu, and the Menu inside its host")
	@Test
	public everythingContained() {
		withMounted(300, 400, menuFixture(), (mounted) => {
			const menu = waitForMenu(mounted.host);
			const items = waitForItems(menu);
			const header = waitForGroupSettled(menu, items);

			assertContained(menu, mounted.host, "menu vs host");
			assertContained(header, menu, "header vs menu");
			for (const item of items) {
				assertContained(item, menu, "item vs menu");
			}
			assertAllDescendantsContained(menu, "expanded menu", ignoreScrollerChrome);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("collapsed={true} omits the menu title and every item label while keeping the toggle and item icons")
	@Test
	public collapsedHidesLabels() {
		withMounted(300, 400, menuFixture(true), (mounted) => {
			const menu = waitForMenu(mounted.host);
			const items = waitForItems(menu);

			Assert.undefined(menu.FindFirstChild("MenuTitle", true), "Expected no MenuTitle while collapsed");
			Assert.notUndefined(menu.FindFirstChild("MenuToggleButton", true), "Expected the toggle button to remain");

			for (const item of items) {
				Assert.undefined(itemLabel(item), `Expected no ButtonText under ${item.GetFullName()} while collapsed`);
				Assert.notUndefined(
					item.FindFirstChild("ButtonIcon", true),
					`Expected the ButtonIcon under ${item.GetFullName()} to remain while collapsed`,
				);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Inside an auto-width Box under a RegistryProvider (story shape) no label wraps and the Menu's content stays inside the Menu, Box and host")
	@Test
	public storyShapeContained() {
		withMounted(1200, 800, storyFixture(), (mounted) => {
			const box = waitForGuiObject<ImageLabel>(mounted.host, "Box");
			const menu = waitForMenu(mounted.host);
			const items = waitForItems(menu, STORY_ITEM_TITLES.size());
			const header = waitForGroupSettled(menu, items);

			waitForLayout(() => {
				const settled = items.every((item) => {
					const label = itemLabel(item);
					return label !== undefined && label.TextFits;
				});
				return settled ? true : undefined;
			}, "Timed out waiting for every Menu label inside the Box to fit on one line");

			assertContained(box, mounted.host, "box vs host");
			assertContained(menu, box, "menu vs box");
			assertContained(header, menu, "header vs menu");
			for (const item of items) {
				const label = itemLabel(item);
				Assert.notUndefined(label, `Expected a ButtonText label under ${item.GetFullName()}`);
				assertTextFits(label!, `label "${label!.Text}"`);
				assertContained(item, menu, "item vs menu");
			}
			assertAllDescendantsContained(menu, "menu inside auto-width box", ignoreScrollerChrome);
		});
	}
}

export = MenuMountValidation;
