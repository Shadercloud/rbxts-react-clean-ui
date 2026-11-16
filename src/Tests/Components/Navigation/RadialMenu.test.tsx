import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { RadialMenu, RadialMenuItem, RadialMenuPlaceholder } from "../../../Components/Navigation/RadialMenu";
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

const ITEMS: RadialMenuItem[] = [
	{ value: "north", icon: "plane", text: "North", description: "Top item" },
	{ value: "east", icon: "wifi", text: "East", description: "Right item" },
	{ value: "south", icon: "bluetooth", text: "South", description: "Bottom item" },
	{ value: "west", icon: "phone", text: "West", description: "Left item" },
];

const PLACEHOLDER: RadialMenuPlaceholder = {
	icon: "cog",
	text: "System Settings",
	description: "Radial Menu",
};

interface MenuFixtureProps {
	value?: string;
	defaultValue?: string;
	placeholder?: RadialMenuPlaceholder;
	log?: string[];
}

function menuFixture(props: MenuFixtureProps = {}) {
	const log = props.log;

	return (
		<RadialMenu
			items={ITEMS}
			size={MENU_SIZE}
			value={props.value}
			defaultValue={props.defaultValue}
			placeholder={props.placeholder}
			onValueChange={(value) => {
				if (log !== undefined) log.push(value);
			}}
		/>
	);
}

function waitForHitArea(host: Instance): Frame {
	return waitForGuiObject<Frame>(host, "HitArea");
}

function waitForCenterTitle(host: Instance, text: string): TextLabel {
	return waitForDescendant<TextLabel>(
		host,
		"CenterTitle",
		(label) => label.Text === text,
		`Timed out waiting for CenterTitle to read "${text}"`,
	);
}

function centerTitleText(host: Instance): string | undefined {
	const label = host.FindFirstChild("CenterTitle", true) as TextLabel | undefined;
	return label?.Text;
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

function release(mounted: MountedElement, hitArea: Frame, angle: number, radius: number, userInputType: Enum.UserInputType = Enum.UserInputType.MouseButton1) {
	fireHostEvent(mounted, hitArea, "InputEnded", pointerInput(userInputType, pointAt(hitArea, angle, radius)));
}

function move(mounted: MountedElement, hitArea: Frame, angle: number, radius: number) {
	fireHostEvent(mounted, hitArea, "InputChanged", pointerInput(Enum.UserInputType.MouseMovement, pointAt(hitArea, angle, radius)));
}

function assertCenterEmpty(host: Instance, label: string) {
	for (const name of ["CenterIcon", "CenterTitle", "CenterDescription"]) {
		Assert.undefined(host.FindFirstChild(name, true), `${label}: expected no ${name} in the centre`);
	}
}

function itemIconImage(host: Instance, value: string): string {
	const item = findDescendant<Frame>(host, `RadialMenuItem-${value}`);
	return findDescendant<ImageLabel>(item, "ItemIcon").Image;
}

@Tag("Studio")
class RadialMenuMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With nothing selected the centre shows the placeholder icon, title and description and the selected wedge is hidden")
	@Test
	public placeholderCentre() {
		withMounted(300, 300, menuFixture({ placeholder: PLACEHOLDER }), (mounted) => {
			waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			const description = findDescendant<TextLabel>(mounted.host, "CenterDescription");
			Assert.equal(description.Text, "Radial Menu", "Expected the placeholder description in the centre");

			const icon = findDescendant<ImageLabel>(mounted.host, "CenterIcon");
			Assert.true(icon.Image !== "", "Expected the placeholder icon to have an image");
			for (const item of ITEMS) {
				Assert.true(icon.Image !== itemIconImage(mounted.host, item.value), `Expected the centre icon not to be ${item.value}'s icon`);
			}

			const wedge = findDescendant<Frame>(mounted.host, "SelectedWedge");
			Assert.false(wedge.Visible, "Expected SelectedWedge to be hidden while nothing is selected");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no selection and no placeholder the centre renders no icon, title or description")
	@Test
	public emptyCentre() {
		withMounted(300, 300, menuFixture(), (mounted) => {
			waitForHitArea(mounted.host);
			settleFrames(2);

			assertCenterEmpty(mounted.host, "no placeholder");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("defaultValue selects its item on mount so the centre shows that item's icon, text and description")
	@Test
	public defaultValueCentre() {
		withMounted(300, 300, menuFixture({ defaultValue: "south", placeholder: PLACEHOLDER }), (mounted) => {
			waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "South");

			const description = findDescendant<TextLabel>(mounted.host, "CenterDescription");
			Assert.equal(description.Text, "Bottom item", "Expected the default item's description in the centre");

			const icon = findDescendant<ImageLabel>(mounted.host, "CenterIcon");
			Assert.equal(icon.Image, itemIconImage(mounted.host, "south"), "Expected the centre icon to match the selected item's icon");

			const wedge = findDescendant<Frame>(mounted.host, "SelectedWedge");
			Assert.true(wedge.Visible, "Expected SelectedWedge to be visible once an item is selected");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("An unknown defaultValue selects nothing and the centre falls back to the placeholder")
	@Test
	public unknownDefault() {
		withMounted(300, 300, menuFixture({ defaultValue: "missing", placeholder: PLACEHOLDER }), (mounted) => {
			waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			Assert.false(findDescendant<Frame>(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge to stay hidden");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A controlled value drives the centre and a rerender with a new value swaps the centre content")
	@Test
	public controlledRerender() {
		withMounted(300, 300, menuFixture({ value: "east", placeholder: PLACEHOLDER }), (mounted) => {
			waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "East");

			mounted.update(menuFixture({ value: "west", placeholder: PLACEHOLDER }));
			waitForCenterTitle(mounted.host, "West");
			Assert.equal(findDescendant<TextLabel>(mounted.host, "CenterDescription").Text, "Left item", "Expected west's description");

			mounted.update(menuFixture({ value: "missing", placeholder: PLACEHOLDER }));
			waitForCenterTitle(mounted.host, "System Settings");
			Assert.false(findDescendant<Frame>(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge hidden for an unmatched value");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[0, RING_RADIUS, "north"],
		[90, RING_RADIUS, "east"],
		[180, RING_RADIUS, "south"],
		[270, RING_RADIUS, "west"],
		[350, RING_RADIUS, "north"],
		[44, RING_RADIUS, "north"],
		[46, RING_RADIUS, "east"],
		[224, RING_RADIUS, "south"],
		[316, RING_RADIUS, "north"],
		[0, 66, "north"],
		[90, 98, "east"],
	])
	@DisplayName("A mouse release on the ring selects the segment under it by clockwise angle from 12 o'clock and reports it")
	@Test
	public selectsByAngle(angle: number, radius: number, expected: string) {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ placeholder: PLACEHOLDER, log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			release(mounted, hitArea, angle, radius);

			const item = ITEMS.find((entry) => entry.value === expected)!;
			waitForCenterTitle(mounted.host, item.text!);
			Assert.equal(log.join(","), expected, `Expected onValueChange to report only ${expected} at ${angle} degrees, radius ${radius}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[0, 0],
		[0, 30],
		[90, 60],
		[45, 130],
		[180, 104],
	])
	@DisplayName("A release in the centre hole or outside the ring's outer edge selects nothing and fires no callback")
	@Test
	public missSelectsNothing(angle: number, radius: number) {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ placeholder: PLACEHOLDER, log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			release(mounted, hitArea, angle, radius);
			settleFrames(3);

			Assert.equal(log.size(), 0, `Expected no onValueChange for a release at ${angle} degrees, radius ${radius}, got [${log.join(",")}]`);
			Assert.equal(centerTitleText(mounted.host), "System Settings", "Expected the placeholder to remain in the centre");
			Assert.false(findDescendant<Frame>(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge to stay hidden");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A miss leaves an existing selection untouched rather than clearing it")
	@Test
	public missKeepsSelection() {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ defaultValue: "east", log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "East");

			release(mounted, hitArea, 0, 20);
			settleFrames(3);

			Assert.equal(log.size(), 0, "Expected no onValueChange for a centre-hole release");
			Assert.equal(centerTitleText(mounted.host), "East", "Expected east to stay selected");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A touch release selects like a mouse release, while a right-button release is ignored")
	@Test
	public releaseInputTypes() {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ placeholder: PLACEHOLDER, log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "System Settings");

			release(mounted, hitArea, 90, RING_RADIUS, Enum.UserInputType.MouseButton2);
			settleFrames(3);
			Assert.equal(log.size(), 0, "Expected a MouseButton2 release to select nothing");
			Assert.equal(centerTitleText(mounted.host), "System Settings", "Expected the placeholder after a MouseButton2 release");

			release(mounted, hitArea, 180, RING_RADIUS, Enum.UserInputType.Touch);
			waitForCenterTitle(mounted.host, "South");
			Assert.equal(log.join(","), "south", "Expected the touch release to report south");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Releasing on the already-selected item still fires onValueChange and keeps it selected")
	@Test
	public reselectFires() {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ defaultValue: "north", log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "North");
			settleFrames(2);
			Assert.equal(log.size(), 0, "Expected onValueChange not to fire on mount");

			release(mounted, hitArea, 0, RING_RADIUS);
			settleFrames(2);

			Assert.equal(log.join(","), "north", "Expected one onValueChange for the reselect");
			Assert.equal(centerTitleText(mounted.host), "North", "Expected north to stay selected");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In controlled mode a release only reports the hit item and the centre waits for the parent's new value")
	@Test
	public controlledClickReports() {
		const log: string[] = [];

		withMounted(300, 300, menuFixture({ value: "north", log }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "North");

			release(mounted, hitArea, 270, RING_RADIUS);
			settleFrames(3);

			Assert.equal(log.join(","), "west", "Expected onValueChange to report west");
			Assert.equal(centerTitleText(mounted.host), "North", "Expected the controlled centre to keep north until value changes");

			mounted.update(menuFixture({ value: "west", log }));
			waitForCenterTitle(mounted.host, "West");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Moving over an unselected segment shows the hover wedge and moving into the centre hole clears it")
	@Test
	public hoverFollowsPointer() {
		withMounted(300, 300, menuFixture({ defaultValue: "north" }), (mounted) => {
			const hitArea = waitForHitArea(mounted.host);
			waitForCenterTitle(mounted.host, "North");
			Assert.undefined(mounted.host.FindFirstChild("HoverWedge", true), "Expected no HoverWedge before any pointer movement");

			move(mounted, hitArea, 90, RING_RADIUS);
			waitForDescendant<Frame>(mounted.host, "HoverWedge", () => true, "Timed out waiting for HoverWedge over east");

			move(mounted, hitArea, 0, 20);
			waitForRemoval(mounted.host, "HoverWedge", 30);

			move(mounted, hitArea, 0, RING_RADIUS);
			settleFrames(3);
			Assert.undefined(mounted.host.FindFirstChild("HoverWedge", true), "Expected no HoverWedge over the already-selected segment");

			waitForLayout(() => (centerTitleText(mounted.host) === "North" ? true : undefined), "Expected hover not to change the selection");
		});
	}
}

export = RadialMenuMountValidation;
