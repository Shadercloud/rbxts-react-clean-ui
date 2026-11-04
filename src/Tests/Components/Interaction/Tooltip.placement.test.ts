import { Test, Assert, Tag, DisplayName } from "@rbxts/lunit";
import {
	TooltipInsets,
	TooltipLayoutInput,
	TooltipPlacement,
	TooltipRect,
	computeTooltipLayout,
	getTooltipPadding,
	getTooltipSafeArea,
	resolveTooltipSide,
} from "../../../Components/Interaction/Tooltip.placement";

const NO_SHADOW: TooltipInsets = { top: 0, bottom: 0, left: 0, right: 0 };
const POINTER_SIZE = 10;
const POINTER_HEIGHT = (1.41421356 * POINTER_SIZE) / 2;
const CORNER_RADIUS = 8;
const BOUNDS = getTooltipSafeArea({ width: 400, height: 300 }, 8, 0);

function targetAt(left: number, top: number, width = 30, height = 20): TooltipRect {
	return { left, top, right: left + width, bottom: top + height };
}

function input(
	target: TooltipRect,
	placement: TooltipPlacement | undefined,
	overrides: Partial<TooltipLayoutInput> = {},
) {
	return {
		target,
		content: { width: 80, height: 20 },
		bounds: BOUNDS,
		placement,
		pointerSize: POINTER_SIZE,
		shadow: NO_SHADOW,
		cornerRadius: CORNER_RADIUS,
		...overrides,
	};
}

function assertNear(actual: number, expected: number, label: string) {
	Assert.true(math.abs(actual - expected) < 1e-6, `${label}: expected ${expected}, got ${actual}`);
}

function assertInside(layoutInput: TooltipLayoutInput, label: string) {
	const layout = computeTooltipLayout(layoutInput);
	const left = layout.position.x - layout.anchor.x * layout.size.width;
	const top = layout.position.y - layout.anchor.y * layout.size.height;
	const bounds = layoutInput.bounds;

	Assert.true(
		left >= bounds.left - 1e-6 &&
			top >= bounds.top - 1e-6 &&
			left + layout.size.width <= bounds.right + 1e-6 &&
			top + layout.size.height <= bounds.bottom + 1e-6,
		`${label}: expected popup [${left}, ${top}, ${layout.size.width}x${layout.size.height}] inside [${bounds.left}, ${bounds.top}, ${bounds.right}, ${bounds.bottom}]`,
	);
}

@Tag("Lune")
class TooltipPlacementValidation {
	@DisplayName("A Top tooltip that fits above the trigger keeps its side and stays centred on it")
	@Test
	public keepsPreferred() {
		const layout = computeTooltipLayout(input(targetAt(185, 140), "Top"));

		Assert.equal(layout.side, "Top");
		Assert.equal(layout.position.x, 200);
		Assert.equal(layout.position.y, 140);
	}

	@DisplayName("Omitting placement behaves like Top, including the flip near the top edge")
	@Test
	public defaultIsTop() {
		Assert.equal(resolveTooltipSide(input(targetAt(185, 140), undefined)), "Top");
		Assert.equal(resolveTooltipSide(input(targetAt(185, 10), undefined)), "Bottom");
	}

	@DisplayName("A Top tooltip with no room above the trigger opens below it instead")
	@Test
	public flipsTopToBottom() {
		Assert.equal(computeTooltipLayout(input(targetAt(185, 10), "Top")).side, "Bottom");
	}

	@DisplayName("A Bottom tooltip with no room below the trigger opens above it instead")
	@Test
	public flipsBottomToTop() {
		Assert.equal(computeTooltipLayout(input(targetAt(185, 270), "Bottom")).side, "Top");
	}

	@DisplayName("A Right tooltip next to the right edge opens to the left and stays inside the safe area")
	@Test
	public flipsRightToLeft() {
		const layoutInput = input(targetAt(360, 140), "Right");

		Assert.equal(computeTooltipLayout(layoutInput).side, "Left");
		assertInside(layoutInput, "flipped Right tooltip");
	}

	@DisplayName("A Left tooltip next to the left edge opens to the right")
	@Test
	public flipsLeftToRight() {
		Assert.equal(computeTooltipLayout(input(targetAt(10, 140), "Left")).side, "Right");
	}

	@DisplayName("When neither side fits, the side with more room wins, and a tie keeps the preferred side")
	@Test
	public bothOverflow() {
		const bounds = getTooltipSafeArea({ width: 400, height: 60 }, 0, 0);
		const content = { width: 80, height: 30 };

		Assert.equal(resolveTooltipSide(input(targetAt(185, 15), "Top", { bounds, content })), "Bottom");
		Assert.equal(resolveTooltipSide(input(targetAt(185, 25), "Bottom", { bounds, content })), "Top");
		Assert.equal(resolveTooltipSide(input(targetAt(185, 20), "Top", { bounds, content })), "Top");
	}

	@DisplayName("Center never flips, even pressed against the top edge, and is still clamped inside the safe area")
	@Test
	public centerNeverFlips() {
		const layoutInput = input(targetAt(185, 0), "Center");
		const layout = computeTooltipLayout(layoutInput);

		Assert.equal(layout.side, "Center");
		Assert.undefined(layout.pointer, "Expected Center to have no pointer");
		assertInside(layoutInput, "Center tooltip");
	}

	@DisplayName(
		"A Top tooltip at the left edge shifts right into the safe area and its pointer moves back by the same amount",
	)
	@Test
	public shiftsAtEdge() {
		const layout = computeTooltipLayout(input(targetAt(30, 140, 20), "Top"));

		Assert.equal(layout.side, "Top");
		Assert.equal(layout.position.x, 48);
		Assert.equal(layout.pointer!.offset.x, -8);
	}

	@DisplayName("At the top-left corner a Top tooltip flips below and shifts right, staying inside the safe area")
	@Test
	public shiftsAtCorner() {
		const layoutInput = input(targetAt(0, 0, 20), "Top");
		const layout = computeTooltipLayout(layoutInput);

		Assert.equal(layout.side, "Bottom");
		Assert.true(layout.position.x > 10, "Expected the popup to shift right of the trigger centre");
		assertInside(layoutInput, "corner tooltip");
	}

	@DisplayName("A large shift clamps the pointer to the popup's straight edge, clear of the rounded corners")
	@Test
	public pointerClamped() {
		const layout = computeTooltipLayout(input(targetAt(0, 140, 20), "Top"));
		const limit = 80 / 2 - CORNER_RADIUS - POINTER_HEIGHT;

		Assert.equal(layout.position.x, 48);
		assertNear(layout.pointer!.offset.x, -limit, "clamped pointer offset");
	}

	@DisplayName("A popup too narrow for the pointer to move keeps the pointer centred on the content")
	@Test
	public pointerNoRoom() {
		const layout = computeTooltipLayout(input(targetAt(0, 140, 20), "Top", { content: { width: 24, height: 20 } }));

		Assert.equal(layout.pointer!.offset.x, 0);
	}

	@DisplayName("Left and Right tooltips shift vertically at the top edge and move their pointer along the side")
	@Test
	public shiftsVertically() {
		const layout = computeTooltipLayout(
			input(targetAt(185, 20, 30, 6), "Right", { content: { width: 80, height: 60 }, cornerRadius: 0 }),
		);

		Assert.equal(layout.side, "Right");
		Assert.equal(layout.position.y, 38);
		Assert.equal(layout.pointer!.offset.y, -15);
	}

	@DisplayName("The topbar band pushes the safe area down, so a Top tooltip just below the band opens below")
	@Test
	public topbarFlips() {
		const withBand = getTooltipSafeArea({ width: 400, height: 300 }, 8, 58);

		Assert.equal(withBand.top, 66);
		Assert.equal(resolveTooltipSide(input(targetAt(185, 80), "Top")), "Top");
		Assert.equal(resolveTooltipSide(input(targetAt(185, 80), "Top", { bounds: withBand })), "Bottom");
	}

	@DisplayName("A topbar band above the overlay (negative local bottom) does not move the safe area")
	@Test
	public topbarAboveOverlay() {
		Assert.equal(getTooltipSafeArea({ width: 400, height: 300 }, 8, -100).top, 8);
	}

	@DisplayName("Auto picks Top for a centred trigger, where every side fits without a shift and Top ties Bottom")
	@Test
	public autoCentred() {
		Assert.equal(resolveTooltipSide(input(targetAt(180, 140, 40, 20), "Auto")), "Top");
	}

	@DisplayName("Auto prefers the fitting side with the most room when no side needs a shift")
	@Test
	public autoMostRoom() {
		Assert.equal(resolveTooltipSide(input(targetAt(180, 60, 40, 20), "Auto")), "Bottom");
	}

	@DisplayName(
		"Auto at the top-left corner picks Right, which needs no shift, over Bottom, which comes first in order",
	)
	@Test
	public autoTopLeft() {
		Assert.equal(resolveTooltipSide(input(targetAt(10, 10, 40, 20), "Auto")), "Right");
	}

	@DisplayName("Auto near the right edge picks Left, because Top and Bottom would need a large sideways shift")
	@Test
	public autoRightEdge() {
		Assert.equal(resolveTooltipSide(input(targetAt(360, 140), "Auto")), "Left");
	}

	@DisplayName("Auto with no side that fits takes the side with the most room")
	@Test
	public autoNoneFit() {
		const bounds = getTooltipSafeArea({ width: 120, height: 60 }, 0, 0);
		const content = { width: 100, height: 40 };

		Assert.equal(resolveTooltipSide(input(targetAt(40, 5, 40, 20), "Auto", { bounds, content })), "Bottom");
	}

	@DisplayName("The pointer side gets at least the pointer's height of padding, or the shadow's if that is larger")
	@Test
	public pointerPadding() {
		const shadow = { top: 2, bottom: 10, left: 2, right: 6 };

		Assert.equal(getTooltipPadding("Top", POINTER_SIZE, shadow).bottom, 10);
		Assert.equal(getTooltipPadding("Bottom", POINTER_SIZE, shadow).top, 7);
		Assert.equal(getTooltipPadding("Left", POINTER_SIZE, shadow).right, 7);
		Assert.equal(getTooltipPadding("Center", POINTER_SIZE, shadow).bottom, 10);
	}

	@DisplayName("An uneven shadow offsets the pointer so it stays centred on the content, as before")
	@Test
	public shadowPointerOffset() {
		const shadow = { top: 2, bottom: 6, left: 2, right: 6 };
		const layout = computeTooltipLayout(input(targetAt(185, 140), "Top", { shadow }));

		Assert.equal(layout.pointer!.offset.x, -2);
		Assert.equal(layout.pointer!.offset.y, -math.max(math.ceil(POINTER_HEIGHT - 5), 6 - (POINTER_HEIGHT - 5)));
	}
}

export = TooltipPlacementValidation;
