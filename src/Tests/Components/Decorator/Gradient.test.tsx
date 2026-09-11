import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Gradient } from "../../../Components/Decorator/Gradient";
import { CssBackgroundGradient } from "../../../Interfaces/";
import { STUDIO_SKIP_MESSAGE, findDescendant, waitForGuiObject, withMounted } from "../../Helpers/layout";

const RED = Color3.fromRGB(255, 0, 0);
const GREEN = Color3.fromRGB(0, 255, 0);
const BLUE = Color3.fromRGB(0, 0, 255);
const WHITE = Color3.fromRGB(255, 255, 255);

function targetWith(decorator: React.ReactNode) {
	return (
		<frame key="Target" Size={UDim2.fromOffset(200, 100)} BackgroundTransparency={0}>
			{decorator}
		</frame>
	);
}

function assertColorKeypoints(sequence: ColorSequence, expected: Array<[number, Color3]>, label: string) {
	const keypoints = sequence.Keypoints;
	Assert.equal(keypoints.size(), expected.size(), `${label}: expected ${expected.size()} colour keypoints, got ${keypoints.size()}`);

	for (let index = 0; index < expected.size(); index++) {
		const [time, color] = expected[index];
		Assert.approximately(keypoints[index].Time, time, 1e-6);
		Assert.equal(keypoints[index].Value, color, `${label}: keypoint ${index} colour mismatch`);
	}
}

@Tag("Studio")
class GradientMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Two colours and a rotation emit a UIGradient named Gradient with evenly spaced keypoints and that Rotation")
	@Test
	public colorsAndRotation() {
		withMounted(300, 200, targetWith(<Gradient value={{ colors: [RED, BLUE], rotation: 45 }} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");
			const gradient = findDescendant<UIGradient>(target, "Gradient");

			Assert.equal(gradient.ClassName, "UIGradient");
			Assert.equal(gradient.Parent, target, "Expected the UIGradient to be a direct child of the decorated frame");
			Assert.equal(gradient.Rotation, 45);
			assertColorKeypoints(gradient.Color, [[0, RED], [1, BLUE]], "two colours");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Explicit stops position the middle keypoint, a numeric transparency becomes a flat NumberSequence, and name renames the instance")
	@Test
	public stopsTransparencyAndName() {
		withMounted(
			300,
			200,
			targetWith(<Gradient name="Fade" value={{ colors: [RED, GREEN, BLUE], stops: [0, 0.25, 1], transparency: 0.5 }} />),
			(mounted) => {
				const target = waitForGuiObject<Frame>(mounted.host, "Target");
				const gradient = findDescendant<UIGradient>(target, "Fade");

				assertColorKeypoints(gradient.Color, [[0, RED], [0.25, GREEN], [1, BLUE]], "three colours with stops");

				const transparency = gradient.Transparency.Keypoints;
				for (let index = 0; index < transparency.size(); index++) {
					Assert.approximately(transparency[index].Value, 0.5, 1e-6);
				}

				Assert.undefined(target.FindFirstChild("Gradient"), "Expected the default Gradient name not to be used when name is set");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Omitting the value prop emits no UIGradient at all")
	@Test
	public noValueEmitsNothing() {
		withMounted(300, 200, targetWith(<Gradient />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UIGradient"), "Expected no UIGradient when value is omitted");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["rotation only", { rotation: 45 }],
		["empty colour array", { colors: [] }],
	])
	@DisplayName("A value with no usable colours still renders the surrounding tree and emits no UIGradient")
	@Test
	public colorlessValueEmitsNothing(label: string, value: Partial<CssBackgroundGradient>) {
		withMounted(300, 200, targetWith(<Gradient value={value} />), (mounted) => {
			const target = waitForGuiObject<Frame>(mounted.host, "Target");

			Assert.undefined(target.FindFirstChildWhichIsA("UIGradient"), `${label}: expected no UIGradient`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Out-of-order interior stops mount a UIGradient whose keypoints are sorted by position")
	@Test
	public outOfOrderStopsMount() {
		withMounted(
			300,
			200,
			targetWith(<Gradient value={{ colors: [RED, GREEN, BLUE, WHITE], stops: [0, 0.7, 0.3, 1] }} />),
			(mounted) => {
				const target = waitForGuiObject<Frame>(mounted.host, "Target");
				const gradient = findDescendant<UIGradient>(target, "Gradient");

				assertColorKeypoints(gradient.Color, [[0, RED], [0.3, BLUE], [0.7, GREEN], [1, WHITE]], "out-of-order stops");
			},
		);
	}
}

export = GradientMountValidation;
