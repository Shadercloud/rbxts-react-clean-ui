import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Accordion } from "../../../Components/Layout/Accordion";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertNonZeroSize,
	assertStackedVertically,
	findDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 400;

function accordion(props: { defaultValue?: string; value?: string } = {}) {
	return (
		<Accordion defaultValue={props.defaultValue} value={props.value} animationDuration={0}>
			<Accordion.Item value="one">
				<Accordion.Header text="Section one" />
				<Accordion.Content text="Content for section one." />
			</Accordion.Item>
			<Accordion.Item value="two">
				<Accordion.Header text="Section two" />
				<Accordion.Content text="Content for section two." />
			</Accordion.Item>
		</Accordion>
	);
}

function waitForAccordion(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Accordion");
}

function findItem(root: Instance, value: string): ImageLabel {
	return findDescendant<ImageLabel>(root, `AccordionItem-${value}`);
}

function findHeader(root: Instance, value: string): GuiObject {
	return findDescendant<GuiObject>(root, `AccordionHeaderButton-${value}`);
}

function assertContentUnmounted(item: Instance, value: string) {
	Assert.true(
		item.FindFirstChild("ContentClip", true) === undefined,
		`Expected the closed item "${value}" to have no mounted ContentClip`,
	);
}

@Tag("Studio")
class AccordionMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["one", "two"],
		["two", "one"],
	])
	@DisplayName("defaultValue expands that item's content to a visible height and leaves the other item's content unmounted")
	@Test
	public defaultValueExpandsItem(openValue: string, closedValue: string) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({ defaultValue: openValue }), (mounted) => {
			const root = waitForAccordion(mounted.host);
			const openItem = findItem(root, openValue);
			const closedItem = findItem(root, closedValue);

			const clip = waitForGuiObject<Frame>(openItem, "ContentClip");
			const contentText = findDescendant<TextLabel>(clip, "AccordionContentText");

			assertNonZeroSize(clip, `open item ${openValue}`);
			assertContained(contentText, clip, `open item ${openValue}`);
			assertContained(clip, root, `open item ${openValue}`);
			assertContentUnmounted(closedItem, closedValue);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Headers and the expanded content are stacked top-to-bottom in item order")
	@Test
	public itemsStackVertically() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({ defaultValue: "one" }), (mounted) => {
			const root = waitForAccordion(mounted.host);
			const clip = waitForGuiObject<Frame>(findItem(root, "one"), "ContentClip");
			const headerOne = findHeader(root, "one");
			const headerTwo = findHeader(root, "two");

			assertStackedVertically([headerOne, clip, headerTwo], "accordion items");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Switching a controlled value from one to two unmounts item one's content and expands item two")
	@Test
	public controlledValueSwitches() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({ value: "one" }), (mounted) => {
			const root = waitForAccordion(mounted.host);
			const itemOne = findItem(root, "one");
			const itemTwo = findItem(root, "two");
			waitForGuiObject<Frame>(itemOne, "ContentClip");
			assertContentUnmounted(itemTwo, "two");

			mounted.update(accordion({ value: "two" }));

			waitForLayout(
				() => (itemOne.FindFirstChild("ContentClip", true) === undefined ? true : undefined),
				"Timed out waiting for item one's ContentClip to be unmounted after the controlled value moved to two",
			);
			const clipTwo = waitForGuiObject<Frame>(itemTwo, "ContentClip");

			assertNonZeroSize(clipTwo, "item two after value switch");
			assertContained(clipTwo, root, "item two after value switch");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With one item expanded, every visible descendant stays inside the Accordion")
	@Test
	public allContained() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({ defaultValue: "one" }), (mounted) => {
			const root = waitForAccordion(mounted.host);
			waitForGuiObject<Frame>(findItem(root, "one"), "ContentClip");

			assertAllDescendantsContained(root, "expanded accordion");
		});
	}
}

export = AccordionMountValidation;
