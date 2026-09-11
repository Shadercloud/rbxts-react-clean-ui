import { Test, Assert, Tag, DisplayName, Decorators } from "@rbxts/lunit";
import { CssHelper } from "../../Helpers/css.helper";
import { CssBackgroundGradient } from "../../Interfaces/css.types";

const { Each } = Decorators;

const RED = Color3.fromRGB(255, 0, 0);
const GREEN = Color3.fromRGB(0, 255, 0);
const BLUE = Color3.fromRGB(0, 0, 255);
const WHITE = Color3.fromRGB(255, 255, 255);
const BLACK = Color3.fromRGB(0, 0, 0);

function resolveColor(value: Partial<CssBackgroundGradient>): ColorSequence {
	const resolved = CssHelper.resolveBackgroundGradient(value);
	Assert.notUndefined(resolved, "Expected a gradient with colours to resolve to UIGradient props");
	Assert.notUndefined(resolved!.Color, "Expected the resolved props to carry a Color");
	return resolved!.Color as ColorSequence;
}

function resolveTransparency(value: Partial<CssBackgroundGradient>): NumberSequence | undefined {
	const resolved = CssHelper.resolveBackgroundGradient(value);
	Assert.notUndefined(resolved, "Expected a gradient with colours to resolve to UIGradient props");
	return resolved!.Transparency as NumberSequence | undefined;
}

function assertColorKeypoints(sequence: ColorSequence, expected: Array<[number, Color3]>, label: string) {
	const keypoints = sequence.Keypoints;
	Assert.equal(keypoints.size(), expected.size(), `${label}: expected ${expected.size()} colour keypoints, got ${keypoints.size()}`);

	for (let index = 0; index < expected.size(); index++) {
		const [time, color] = expected[index];
		Assert.approximately(keypoints[index].Time, time, 1e-6, `${label}: keypoint ${index} time mismatch`);
		Assert.equal(keypoints[index].Value, color, `${label}: keypoint ${index} colour mismatch`);
	}
}

@Tag("Studio")
class CssBackgroundGradientResolution {
	@DisplayName("An undefined value resolves to no UIGradient props")
	@Test
	public undefinedValue() {
		Assert.undefined(CssHelper.resolveBackgroundGradient(undefined));
	}

	@Each([
		["rotation only", { rotation: 45 }],
		["empty colour array", { colors: [] }],
		["stops and transparency without colours", { stops: [0, 1], transparency: 0.5 }],
		["empty object", {}],
	])
	@DisplayName("A value with no usable colours resolves to undefined without throwing")
	@Test
	public colorlessValue(label: string, value: Partial<CssBackgroundGradient>) {
		Assert.undefined(CssHelper.resolveBackgroundGradient(value), `${label}: expected no UIGradient props`);
	}

	@DisplayName("A single colour becomes a solid two-keypoint sequence and its stops are ignored")
	@Test
	public singleColorSolid() {
		assertColorKeypoints(resolveColor({ colors: [GREEN], stops: [0.4] }), [[0, GREEN], [1, GREEN]], "single colour");
	}

	@DisplayName("A ColorSequence is passed through untouched even when stops are also set")
	@Test
	public sequencePassthrough() {
		const sequence = new ColorSequence([
			new ColorSequenceKeypoint(0, RED),
			new ColorSequenceKeypoint(0.2, GREEN),
			new ColorSequenceKeypoint(1, BLUE),
		]);

		const color = resolveColor({ colors: sequence, stops: [0, 0.9, 1] });

		Assert.equal(color, sequence);
		assertColorKeypoints(color, [[0, RED], [0.2, GREEN], [1, BLUE]], "passthrough sequence");
	}

	@DisplayName("Three colours without stops are spaced evenly at 0, 0.5 and 1")
	@Test
	public evenSpacing() {
		assertColorKeypoints(resolveColor({ colors: [RED, GREEN, BLUE] }), [[0, RED], [0.5, GREEN], [1, BLUE]], "no stops");
	}

	@DisplayName("Colours past the end of a short stops array fall back to even spacing")
	@Test
	public shortStopsFallback() {
		assertColorKeypoints(
			resolveColor({ colors: [RED, GREEN, BLUE, WHITE], stops: [0, 0.1] }),
			[[0, RED], [0.1, GREEN], [2 / 3, BLUE], [1, WHITE]],
			"short stops",
		);
	}

	@DisplayName("Endpoint stops that are not 0 and 1 are overridden so the sequence still spans 0 to 1")
	@Test
	public endpointsForced() {
		assertColorKeypoints(
			resolveColor({ colors: [RED, GREEN, BLUE], stops: [0.3, 0.5, 0.7] }),
			[[0, RED], [0.5, GREEN], [1, BLUE]],
			"inset endpoints",
		);
	}

	@DisplayName("Out-of-order interior stops resolve without throwing and each colour sits at its own stop")
	@Test
	public outOfOrderStops() {
		assertColorKeypoints(
			resolveColor({ colors: [RED, GREEN, BLUE, WHITE], stops: [0, 0.7, 0.3, 1] }),
			[[0, RED], [0.3, BLUE], [0.7, GREEN], [1, WHITE]],
			"out-of-order stops",
		);
	}

	@Each([
		["two interior colours", [RED, GREEN, BLUE, WHITE], [0, 0.5, 0.5, 1], [[0, RED], [0.5, GREEN], [0.5, BLUE], [1, WHITE]]],
		["tie after reordering", [RED, WHITE, GREEN, BLUE, BLACK], [0, 0.8, 0.4, 0.4, 1], [[0, RED], [0.4, GREEN], [0.4, BLUE], [0.8, WHITE], [1, BLACK]]],
		["interior tied with the first", [RED, GREEN, BLUE], [0, 0, 1], [[0, RED], [0, GREEN], [1, BLUE]]],
		["interior tied with the last", [RED, GREEN, BLUE], [0, 1, 1], [[0, RED], [1, GREEN], [1, BLUE]]],
	])
	@DisplayName("Colours sharing a stop keep their array order, giving a hard edge")
	@Test
	public sharedStopKeepsOrder(label: string, colors: Color3[], stops: number[], expected: Array<[number, Color3]>) {
		assertColorKeypoints(resolveColor({ colors, stops }), expected, label);
	}

	@Each([
		["above one", [0, 1.5, 1], [[0, RED], [1, GREEN], [1, BLUE]]],
		["below zero", [0, -0.5, 1], [[0, RED], [0, GREEN], [1, BLUE]]],
	])
	@DisplayName("An interior stop outside 0 to 1 is clamped into range")
	@Test
	public clampsStops(label: string, stops: number[], expected: Array<[number, Color3]>) {
		assertColorKeypoints(resolveColor({ colors: [RED, GREEN, BLUE], stops }), expected, label);
	}

	@Each([
		[1.5, 1],
		[-0.5, 0],
		[0.25, 0.25],
	])
	@DisplayName("A numeric transparency is clamped to 0 to 1 and applied uniformly")
	@Test
	public uniformTransparency(input: number, expected: number) {
		const transparency = resolveTransparency({ colors: [RED, BLUE], transparency: input });
		Assert.notUndefined(transparency, "Expected a numeric transparency to produce a NumberSequence");

		const keypoints = transparency!.Keypoints;
		Assert.greaterThan(keypoints.size(), 0);

		for (let index = 0; index < keypoints.size(); index++) {
			Assert.approximately(keypoints[index].Value, expected, 1e-6, `keypoint ${index} transparency mismatch`);
		}
	}

	@DisplayName("A NumberSequence transparency passes through untouched and an omitted one stays unset")
	@Test
	public transparencyPassthrough() {
		const sequence = new NumberSequence(0.2, 0.8);

		Assert.equal(resolveTransparency({ colors: [RED, BLUE], transparency: sequence }), sequence);
		Assert.undefined(resolveTransparency({ colors: [RED, BLUE] }));
	}

	@DisplayName("Rotation and offset map straight onto the UIGradient props")
	@Test
	public rotationAndOffset() {
		const offset = new Vector2(0.25, -0.5);
		const resolved = CssHelper.resolveBackgroundGradient({ colors: [RED, BLUE], rotation: 45, offset });

		Assert.notUndefined(resolved);
		Assert.equal(resolved!.Rotation, 45);
		Assert.equal(resolved!.Offset, offset);
	}
}

export = CssBackgroundGradientResolution;
