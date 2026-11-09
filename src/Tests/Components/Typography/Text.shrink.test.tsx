import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	rect,
	settleFrames,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const TITLE = "SHRINK THIS TITLE";
const NARROW_SLOT = 60;
const WIDE_SLOT = 600;
const SCALE_EPSILON = 0.01;
const PROBE_STEP = 0.005;

interface ShrinkCase {
	slot: number;
	spaced?: boolean;
	minScale?: number;
	maxWidth?: number;
	padding?: number;
}

function shrinkApp(options: ShrinkCase) {
	const padding = options.padding;

	return (
		<frame key="Slot" Size={UDim2.fromOffset(options.slot, 40)} BackgroundTransparency={1}>
			{padding !== undefined && (
				<uipadding key="SlotPadding" PaddingLeft={new UDim(0, padding)} PaddingRight={new UDim(0, padding)} />
			)}
			<Text
				text={TITLE}
				TextWrap={false}
				letterSpacing={options.spaced === false ? undefined : 2}
				shrinkToFit={true}
				shrinkMinScale={options.minScale}
				maxWidth={options.maxWidth}
			/>
		</frame>
	);
}

function waitForRoot(host: Instance): GuiObject {
	return waitForGuiObject<GuiObject>(host, "Text");
}

function shrinkScaleOf(host: Instance): UIScale {
	return waitForDescendant<UIScale>(host, "ShrinkScale", () => true);
}

function waitForScale(host: Instance, predicate: (scale: number) => boolean, message: string): number {
	const scale = shrinkScaleOf(host);
	return waitForLayout(() => (predicate(scale.Scale) ? scale.Scale : undefined), `${message} (Scale is ${scale.Scale})`);
}

function assertWidthNear(root: GuiObject, width: number, label: string) {
	const actual = rect(root).width;
	Assert.true(actual <= width + 1, `${label}: expected the visual width ${actual} to fit within ${width}px`);
	Assert.true(actual >= width - 2, `${label}: expected the visual width ${actual} to fill about ${width}px`);
}

function probeApp(scale: number) {
	return (
		<frame key="Probe" Size={UDim2.fromOffset(WIDE_SLOT, 40)} BackgroundTransparency={1}>
			<uiscale key="ProbeScale" Scale={scale} />
			<Text text={TITLE} TextWrap={false} letterSpacing={2} />
		</frame>
	);
}

function assertLargestFit(host: Instance, root: GuiObject, width: number, label: string) {
	settleFrames(3);
	const actual = rect(root).width;
	Assert.true(actual <= width + 1, `${label}: expected the visual width ${actual} to fit within ${width}px`);

	const probeScale = shrinkScaleOf(host).Scale + PROBE_STEP;
	withMounted(800, 200, probeApp(probeScale), (probe) => {
		const probeRoot = waitForRoot(probe.host);
		waitForLayout(
			() => (rect(probeRoot).width > width ? true : undefined),
			`${label}: expected the text at scale ${probeScale} to overflow ${width}px, so ${actual}px is the largest fit (is ${rect(probeRoot).width})`,
		);
	});
}

function spacedFor(kind: string): boolean {
	return kind === "spaced";
}

@Tag("Studio")
class TextShrinkToFit {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In a slot narrower than the text, the ShrinkScale drops below 1 until the text fits the slot")
	@Each([["spaced"], ["plain"]])
	@Test
	public shrinksIntoSlot(kind: string) {
		withMounted(400, 200, shrinkApp({ slot: NARROW_SLOT, spaced: spacedFor(kind) }), (mounted) => {
			const root = waitForRoot(mounted.host);
			const scale = waitForScale(
				mounted.host,
				(value) => value < 1 - SCALE_EPSILON && rect(root).width <= NARROW_SLOT + 1,
				`Timed out waiting for ${kind} text to shrink into ${NARROW_SLOT}px`,
			);

			Assert.true(scale > 0 && scale < 1, `Expected a scale between 0 and 1, got ${scale}`);
			if (spacedFor(kind)) {
				assertLargestFit(mounted.host, root, NARROW_SLOT, `${kind} text`);
			} else {
				assertWidthNear(root, NARROW_SLOT, `${kind} text`);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The slot's UIPadding is taken off the width the text shrinks into")
	@Test
	public respectsSlotPadding() {
		withMounted(400, 200, shrinkApp({ slot: 80, padding: 10 }), (mounted) => {
			const root = waitForRoot(mounted.host);
			waitForScale(
				mounted.host,
				() => rect(root).width <= 61,
				"Timed out waiting for the text to shrink into the 60px padded content width",
			);

			assertLargestFit(mounted.host, root, 60, "padded slot");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("shrinkMinScale stops the shrink at its floor and the text then overflows the slot")
	@Test
	public stopsAtMinScale() {
		withMounted(400, 200, shrinkApp({ slot: 20, minScale: 0.75 }), (mounted) => {
			const root = waitForRoot(mounted.host);
			waitForScale(
				mounted.host,
				(value) => math.abs(value - 0.75) <= SCALE_EPSILON,
				"Timed out waiting for the scale to settle at shrinkMinScale 0.75",
			);
			settleFrames(3);

			const scale = shrinkScaleOf(mounted.host).Scale;
			Assert.true(math.abs(scale - 0.75) <= SCALE_EPSILON, `Expected the scale to stay at 0.75, got ${scale}`);
			Assert.true(rect(root).width > 20, `Expected the floored text ${rect(root).width}px to overflow the 20px slot`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A shrinkMinScale above 1 is clamped to 1, so the text never shrinks")
	@Test
	public minScaleClamped() {
		withMounted(400, 200, shrinkApp({ slot: NARROW_SLOT, minScale: 2 }), (mounted) => {
			waitForRoot(mounted.host);
			settleFrames(5);

			const scale = shrinkScaleOf(mounted.host).Scale;
			Assert.true(math.abs(scale - 1) <= 0.001, `Expected the scale to stay at 1, got ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In a slot wider than the text, the scale stays exactly 1 and never grows")
	@Test
	public neverScalesUp() {
		withMounted(800, 200, shrinkApp({ slot: WIDE_SLOT }), (mounted) => {
			const root = waitForRoot(mounted.host);
			settleFrames(5);

			const scale = shrinkScaleOf(mounted.host).Scale;
			Assert.true(math.abs(scale - 1) <= 0.001, `Expected the scale to stay at 1, got ${scale}`);
			Assert.true(rect(root).width < WIDE_SLOT, `Expected the natural width ${rect(root).width} to be under ${WIDE_SLOT}px`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Widening the slot after a shrink brings the scale back to 1 and no higher")
	@Test
	public recoversWhenWidened() {
		withMounted(800, 200, shrinkApp({ slot: NARROW_SLOT }), (mounted) => {
			waitForRoot(mounted.host);
			waitForScale(mounted.host, (value) => value < 1 - SCALE_EPSILON, "Timed out waiting for the initial shrink");

			mounted.update(shrinkApp({ slot: WIDE_SLOT }));

			waitForScale(
				mounted.host,
				(value) => math.abs(value - 1) <= 0.001,
				`Timed out waiting for the scale to return to 1 in a ${WIDE_SLOT}px slot`,
			);
			settleFrames(3);

			const scale = shrinkScaleOf(mounted.host).Scale;
			Assert.true(scale <= 1, `Expected the scale never to exceed 1, got ${scale}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With maxWidth set, the text shrinks into maxWidth even inside a much wider slot")
	@Test
	public shrinksIntoMaxWidth() {
		withMounted(800, 200, shrinkApp({ slot: WIDE_SLOT, maxWidth: NARROW_SLOT }), (mounted) => {
			const root = waitForRoot(mounted.host);
			waitForScale(
				mounted.host,
				(value) => value < 1 - SCALE_EPSILON && rect(root).width <= NARROW_SLOT + 1,
				`Timed out waiting for the text to shrink into maxWidth ${NARROW_SLOT}px`,
			);

			assertLargestFit(mounted.host, root, NARROW_SLOT, "maxWidth target");
		});
	}
}

export = TextShrinkToFit;
