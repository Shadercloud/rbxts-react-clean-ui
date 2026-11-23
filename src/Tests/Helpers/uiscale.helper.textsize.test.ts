import { Test, Assert, Tag, DisplayName, Decorators } from "@rbxts/lunit";
import { toScreenTextSize, toScreenTextSizeRange } from "../../Helpers/uiscale.helper";

const { Each } = Decorators;

const EPSILON = 1e-9;

function assertApprox(actual: number, expected: number, label: string) {
	Assert.true(math.abs(actual - expected) <= EPSILON, `${label}: expected ${expected}, got ${actual}`);
}

@Tag("Lune")
class UiScaleHelperTextSize {
	@Each([
		[18, 1, 18],
		[18, 1.5, 27],
		[18, 3, 54],
		[24, 1.25, 30],
		[14, 0.5, 7],
	])
	@DisplayName("A design text size is multiplied by the scale")
	@Test
	public sizeMultiplies(size: number, scale: number, expected: number) {
		const actual = toScreenTextSize(size, scale);
		Assert.notUndefined(actual, `Expected toScreenTextSize(${size}, ${scale}) to pin`);
		assertApprox(actual!, expected, `toScreenTextSize(${size}, ${scale})`);
	}

	@Each([
		[100, 1],
		[50, 2],
		[40, 2.5],
		[20, 5],
	])
	@DisplayName("A product of exactly 100 is still returned as 100")
	@Test
	public exactCapPins(size: number, scale: number) {
		const actual = toScreenTextSize(size, scale);
		Assert.notUndefined(actual, `Expected toScreenTextSize(${size}, ${scale}) to pin at the cap`);
		assertApprox(actual!, 100, `toScreenTextSize(${size}, ${scale})`);
	}

	@Each([
		[48, 3],
		[96, 3],
		[34, 3],
		[60, 2],
		[100, 1.01],
	])
	@DisplayName("A product above 100 returns undefined instead of a capped size")
	@Test
	public aboveCapUndefined(size: number, scale: number) {
		Assert.undefined(toScreenTextSize(size, scale), `Expected toScreenTextSize(${size}, ${scale}) to skip the pin`);
	}

	@Each([
		[150, 1, 100],
		[150, 0.5, 50],
		[0, 1, 1],
		[-5, 2, 2],
	])
	@DisplayName("The design size is clamped to 1-100 before the scale is applied")
	@Test
	public clampsBeforeScale(size: number, scale: number, expected: number) {
		const actual = toScreenTextSize(size, scale);
		Assert.notUndefined(actual, `Expected toScreenTextSize(${size}, ${scale}) to pin`);
		assertApprox(actual!, expected, `toScreenTextSize(${size}, ${scale})`);
	}

	@Each([
		[150, 2],
		[200, 1.5],
	])
	@DisplayName("An oversized design size clamped to 100 still exceeds the cap once scaled up")
	@Test
	public clampedThenCapped(size: number, scale: number) {
		Assert.undefined(toScreenTextSize(size, scale), `Expected toScreenTextSize(${size}, ${scale}) to skip the pin`);
	}

	@Each([
		[1, 0.5],
		[10, 0.05],
		[3, 0.25],
	])
	@DisplayName("A scaled size below 1 is raised to the 1px floor")
	@Test
	public floorsAtOne(size: number, scale: number) {
		const actual = toScreenTextSize(size, scale);
		Assert.notUndefined(actual, `Expected toScreenTextSize(${size}, ${scale}) to pin`);
		assertApprox(actual!, 1, `toScreenTextSize(${size}, ${scale})`);
	}

	@Each([
		[1, 100, 1, 1, 100],
		[10, 30, 1.5, 15, 45],
		[12, 24, 1.25, 15, 30],
		[10, 40, 3, 30, 100],
		[1, 100, 0.5, 1, 50],
	])
	@DisplayName("Both ends of the range are scaled and the top is capped at 100")
	@Test
	public rangeScales(minTextSize: number, maxTextSize: number, scale: number, expectedMin: number, expectedMax: number) {
		const [actualMin, actualMax] = toScreenTextSizeRange(minTextSize, maxTextSize, scale);
		assertApprox(actualMin, expectedMin, `min of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
		assertApprox(actualMax, expectedMax, `max of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
	}

	@Each([
		[40, 60, 3, 100, 100],
		[2, 4, 0.25, 1, 1],
		[0, 0, 1, 1, 1],
	])
	@DisplayName("A range pushed past either edge collapses onto 1 or 100")
	@Test
	public rangeClampsEdges(minTextSize: number, maxTextSize: number, scale: number, expectedMin: number, expectedMax: number) {
		const [actualMin, actualMax] = toScreenTextSizeRange(minTextSize, maxTextSize, scale);
		assertApprox(actualMin, expectedMin, `min of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
		assertApprox(actualMax, expectedMax, `max of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
	}

	@Each([
		[30, 20, 1, 30],
		[50, 10, 2, 100],
	])
	@DisplayName("A max below the scaled min is raised to the min")
	@Test
	public rangeMaxFollowsMin(minTextSize: number, maxTextSize: number, scale: number, expected: number) {
		const [actualMin, actualMax] = toScreenTextSizeRange(minTextSize, maxTextSize, scale);
		assertApprox(actualMin, expected, `min of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
		assertApprox(actualMax, expected, `max of toScreenTextSizeRange(${minTextSize}, ${maxTextSize}, ${scale})`);
	}
}

export = UiScaleHelperTextSize;
