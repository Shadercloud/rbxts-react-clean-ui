import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { RadialMenu, RadialMenuItem, RadialMenuItemState, RadialMenuPlaceholder } from "../../../Components/Navigation/RadialMenu";
import { fireHostEvent } from "../../Helpers/fiber";
import {
	MountedElement,
	STUDIO_SKIP_MESSAGE,
	findDescendant,
	settleFrames,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	waitForRemoval,
	withMounted,
} from "../../Helpers/layout";

const MENU_SIZE = 200;
const RING_RADIUS = 82;

const PLACEHOLDER: RadialMenuPlaceholder = {
	icon: "cog",
	text: "System Settings",
	description: "Radial Menu",
};

interface MenuFixtureProps {
	items: RadialMenuItem[];
	defaultValue?: string;
	placeholder?: RadialMenuPlaceholder;
	showLabels?: boolean;
	log?: string[];
}

function menuFixture(props: MenuFixtureProps) {
	const log = props.log;

	return (
		<RadialMenu
			items={props.items}
			size={MENU_SIZE}
			defaultValue={props.defaultValue}
			placeholder={props.placeholder}
			showLabels={props.showLabels}
			onValueChange={(value) => {
				if (log !== undefined) log.push(value);
			}}
		/>
	);
}

function badge(name: string) {
	return <imagelabel key={name} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} />;
}

function centreLabel(name: string, text: string) {
	return <textlabel key={name} Text={text} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} />;
}

function stateText(state: RadialMenuItemState): string {
	return `${state.selected}:${state.hovered}`;
}

function probe(name: string) {
	return (state: RadialMenuItemState) => (
		<textlabel key={name} Text={stateText(state)} Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} />
	);
}

function plainItems(): RadialMenuItem[] {
	return [
		{ value: "north", icon: "plane", text: "North", description: "Top item" },
		{ value: "east", icon: "wifi", text: "East", description: "Right item" },
		{ value: "south", icon: "bluetooth", text: "South", description: "Bottom item" },
		{ value: "west", icon: "phone", text: "West", description: "Left item" },
	];
}

function withItem(value: string, patch: Partial<RadialMenuItem>): RadialMenuItem[] {
	return plainItems().map((item) => (item.value === value ? { ...item, ...patch } : item));
}

function waitForHitArea(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "HitArea");
}

function itemFrame(host: Instance, value: string): Frame {
	return findDescendant<Frame>(host, `RadialMenuItem-${value}`);
}

function waitForCenterTitle(host: Instance, text: string): TextLabel {
	return waitForDescendant<TextLabel>(
		host,
		"CenterTitle",
		(label) => label.Text === text,
		`Timed out waiting for CenterTitle to read "${text}"`,
	);
}

function waitForProbe(root: Instance, name: string, expected: string, label: string): TextLabel {
	return waitForDescendant<TextLabel>(
		root,
		name,
		(probeLabel) => probeLabel.Text === expected,
		`${label}: timed out waiting for ${name} to read "${expected}" (reads "${(root.FindFirstChild(name, true) as TextLabel | undefined)?.Text}")`,
	);
}

function pointAt(hitArea: Frame, angle: number, radius: number): Vector3 {
	const centerX = hitArea.AbsolutePosition.X + hitArea.AbsoluteSize.X / 2;
	const centerY = hitArea.AbsolutePosition.Y + hitArea.AbsoluteSize.Y / 2;
	const radians = math.rad(angle);

	return new Vector3(centerX + radius * math.sin(radians), centerY - radius * math.cos(radians), 0);
}

function pointerInput(userInputType: Enum.UserInputType, position: Vector3) {
	return { UserInputType: userInputType, Position: position };
}

function release(mounted: MountedElement, hitArea: Frame, angle: number, radius: number) {
	fireHostEvent(mounted, hitArea, "InputEnded", pointerInput(Enum.UserInputType.MouseButton1, pointAt(hitArea, angle, radius)));
}

function move(mounted: MountedElement, hitArea: Frame, angle: number, radius: number) {
	fireHostEvent(mounted, hitArea, "InputChanged", pointerInput(Enum.UserInputType.MouseMovement, pointAt(hitArea, angle, radius)));
}

function assertDefaultCentreAbsent(host: Instance, label: string) {
	for (const name of ["CenterIcon", "CenterTitle", "CenterDescription"]) {
		Assert.undefined(host.FindFirstChild(name, true), `${label}: expected no ${name} in the centre`);
	}
}

@Tag("Studio")
class RadialMenuContentValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Node content renders inside an ItemContent slot in place of the item's ItemIcon")
	@Test
	public contentReplacesIcon() {
		withMounted(300, 300, menuFixture({ items: withItem("east", { content: badge("EastBadge") }) }), (mounted) => {
			waitForHitArea(mounted.host);
			settleFrames(2);

			const east = itemFrame(mounted.host, "east");
			const slot = findDescendant<Frame>(east, "ItemContent");
			Assert.notUndefined(slot.FindFirstChild("EastBadge"), "Expected the content to be parented directly to ItemContent");
			Assert.undefined(east.FindFirstChild("ItemIcon", true), "Expected no ItemIcon for an item with content");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With showLabels on, an item with content renders no ItemLabel while plain items keep theirs")
	@Test
	public contentHidesLabel() {
		withMounted(300, 300, menuFixture({ items: withItem("east", { content: badge("EastBadge") }), showLabels: true }), (mounted) => {
			waitForHitArea(mounted.host);
			settleFrames(2);

			const east = itemFrame(mounted.host, "east");
			findDescendant<Frame>(east, "ItemContent");
			Assert.undefined(east.FindFirstChild("ItemLabel", true), "Expected no ItemLabel for an item with content");

			const north = itemFrame(mounted.host, "north");
			Assert.equal(findDescendant<TextLabel>(north, "ItemLabel").Text, "North", "Expected the plain item's label to stay");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In a mixed menu plain items still render ItemIcon and only the custom item gets an ItemContent slot")
	@Test
	public mixedItems() {
		withMounted(300, 300, menuFixture({ items: withItem("east", { content: badge("EastBadge") }) }), (mounted) => {
			waitForHitArea(mounted.host);
			settleFrames(2);

			for (const value of ["north", "south", "west"]) {
				const item = itemFrame(mounted.host, value);
				Assert.true(findDescendant<ImageLabel>(item, "ItemIcon").Image !== "", `Expected ${value} to render an ItemIcon with an image`);
				Assert.undefined(item.FindFirstChild("ItemContent", true), `Expected no ItemContent for plain item ${value}`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Function content gets raw hover and selection per item, with both true while hovering the selected item")
	@Test
	public functionContentState() {
		const items = plainItems().map((item) => ({ ...item, content: probe(`Probe-${item.value}`) }));

		withMounted(300, 300, menuFixture({ items }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			for (const item of items) {
				waitForProbe(mounted.host, `Probe-${item.value}`, "false:false", "on mount");
			}

			move(mounted, hitArea, 90, RING_RADIUS);
			waitForProbe(mounted.host, "Probe-east", "false:true", "hovering east");
			waitForProbe(mounted.host, "Probe-north", "false:false", "hovering east");

			release(mounted, hitArea, 90, RING_RADIUS);
			waitForProbe(mounted.host, "Probe-east", "true:true", "after selecting east under the pointer");

			move(mounted, hitArea, 0, RING_RADIUS);
			waitForProbe(mounted.host, "Probe-east", "true:false", "hovering north with east selected");
			waitForProbe(mounted.host, "Probe-north", "false:true", "hovering north with east selected");

			move(mounted, hitArea, 0, 20);
			waitForProbe(mounted.host, "Probe-north", "false:false", "pointer in the centre hole");
			waitForProbe(mounted.host, "Probe-east", "true:false", "pointer in the centre hole");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Function centreContent always gets selected true and follows hover of the selected item's segment")
	@Test
	public functionCentreState() {
		const items = withItem("east", { centerContent: probe("CentreProbe") });

		withMounted(300, 300, menuFixture({ items, defaultValue: "east" }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			const slot = waitForGuiObject<Frame>(mounted.host, "CenterSlot", () => true);
			waitForProbe(slot, "CentreProbe", "true:false", "east selected, no hover");

			move(mounted, hitArea, 90, RING_RADIUS);
			waitForProbe(slot, "CentreProbe", "true:true", "hovering selected east");

			move(mounted, hitArea, 180, RING_RADIUS);
			waitForProbe(slot, "CentreProbe", "true:false", "hovering south");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An item's centreContent fills the centre while it is selected and the default centre returns for other items")
	@Test
	public itemCentreContent() {
		const items = withItem("east", { centerContent: centreLabel("EastCentre", "Custom east") });

		withMounted(300, 300, menuFixture({ items, placeholder: PLACEHOLDER }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			release(mounted, hitArea, 90, RING_RADIUS);
			const slot = waitForGuiObject<Frame>(mounted.host, "CenterSlot", () => true);
			Assert.equal(findDescendant<Frame>(mounted.host, "CenterContent"), slot.Parent, "Expected CenterSlot inside CenterContent");
			Assert.equal(findDescendant<TextLabel>(slot, "EastCentre").Text, "Custom east", "Expected east's centreContent in the slot");
			assertDefaultCentreAbsent(mounted.host, "east selected");

			release(mounted, hitArea, 180, RING_RADIUS);
			waitForCenterTitle(mounted.host, "South");
			waitForRemoval(mounted.host, "CenterSlot", 30);
			Assert.undefined(mounted.host.FindFirstChild("EastCentre", true), "Expected east's centreContent gone once south is selected");
			Assert.equal(findDescendant<TextLabel>(mounted.host, "CenterDescription").Text, "Bottom item", "Expected south's default description");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With nothing selected the placeholder's centreContent replaces its icon, title and description")
	@Test
	public placeholderCentreContent() {
		const placeholder: RadialMenuPlaceholder = { ...PLACEHOLDER, centerContent: centreLabel("PlaceholderCentre", "Pick one") };

		withMounted(300, 300, menuFixture({ items: plainItems(), placeholder }), (mounted) => {
			waitForHitArea(mounted.host);
			const slot = waitForGuiObject<Frame>(mounted.host, "CenterSlot", () => true);

			Assert.equal(findDescendant<TextLabel>(slot, "PlaceholderCentre").Text, "Pick one", "Expected the placeholder's centreContent in the slot");
			assertDefaultCentreAbsent(mounted.host, "placeholder centreContent");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A selected item without centreContent shows its own default centre, never the placeholder's centreContent")
	@Test
	public selectedIgnoresPlaceholder() {
		const placeholder: RadialMenuPlaceholder = { ...PLACEHOLDER, centerContent: centreLabel("PlaceholderCentre", "Pick one") };

		withMounted(300, 300, menuFixture({ items: plainItems(), placeholder, defaultValue: "north" }), (mounted) => {
			waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "North");
			settleFrames(3);

			Assert.undefined(mounted.host.FindFirstChild("CenterSlot", true), "Expected no CenterSlot for a selected plain item");
			Assert.undefined(mounted.host.FindFirstChild("PlaceholderCentre", true), "Expected the placeholder's centreContent not to render");
			Assert.equal(findDescendant<TextLabel>(mounted.host, "CenterDescription").Text, "Top item", "Expected north's default description");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An Active TextButton in an item's content sits under HitArea and a release over it still selects the item")
	@Test
	public activeButtonInert() {
		const log: string[] = [];
		const button = <textbutton key="ContentButton" Active Text="" Size={UDim2.fromScale(1, 1)} BackgroundTransparency={1} />;
		const items = withItem("east", { content: button, centerContent: centreLabel("EastCentre", "Custom east") });

		withMounted(300, 300, menuFixture({ items, placeholder: PLACEHOLDER, log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			const contentButton = waitForGuiObject<TextButton>(mounted.host, "ContentButton");
			waitForCenterTitle(mounted.host, "System Settings");

			Assert.false(findDescendant<Frame>(mounted.host, "ItemContent").Interactable, "Expected ItemContent to be non-interactable");

			const centre = contentButton.AbsolutePosition.add(contentButton.AbsoluteSize.div(2));
			let layer: Instance = contentButton;
			while (layer.Parent !== undefined && layer.Parent !== hitArea.Parent) layer = layer.Parent;
			Assert.equal(layer.Parent, hitArea.Parent, "Expected the content to share a sibling layer with HitArea");
			Assert.true((layer as GuiObject).ZIndex < hitArea.ZIndex, `Expected HitArea (ZIndex ${hitArea.ZIndex}) above the content's layer ${layer.Name} (ZIndex ${(layer as GuiObject).ZIndex})`);

			const hitCentreX = hitArea.AbsolutePosition.X + hitArea.AbsoluteSize.X / 2;
			const hitCentreY = hitArea.AbsolutePosition.Y + hitArea.AbsoluteSize.Y / 2;
			const angle = math.deg(math.atan2(centre.X - hitCentreX, -(centre.Y - hitCentreY)));
			const radius = math.sqrt((centre.X - hitCentreX) ** 2 + (centre.Y - hitCentreY) ** 2);
			release(mounted, hitArea, angle, radius);

			const slot = waitForGuiObject<Frame>(mounted.host, "CenterSlot", () => true);
			Assert.false(slot.Interactable, "Expected CenterSlot to be non-interactable");
			waitForLayout(() => (log.size() > 0 ? true : undefined), "Expected a release over the content button to select east");
			Assert.equal(log.join(","), "east", "Expected onValueChange to report east");
		});
	}
}

export = RadialMenuContentValidation;
