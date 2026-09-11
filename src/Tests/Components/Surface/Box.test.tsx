import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Box } from "../../../Components/Surface/Box";
import { Text } from "../../../Components/Typography/Text";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertContained,
	assertSizeApprox,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

function waitForBox(host: Instance): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, "Box");
}

@Tag("Studio")
class BoxMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without width or height the Box defaults to a (1,1) scale Size and fills its host")
	@Test
	public fillsHostByDefault() {
		withMounted(400, 300, <Box />, (mounted) => {
			const box = waitForBox(mounted.host);

			assertSizeApprox(box, 400, 300, 1, "default-size box");
			assertContained(box, mounted.host, "default-size box");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[200, 120],
		[64, 32],
	])
	@DisplayName("Explicit width and height props pin the Box's AbsoluteSize to those pixel values")
	@Test
	public respectsExplicitSize(width: number, height: number) {
		withMounted(400, 300, <Box width={width} height={height} />, (mounted) => {
			const box = waitForBox(mounted.host);

			assertSizeApprox(box, width, height, 1, "explicit size");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A full-scale frame child and a Text child both stay inside the padded Box")
	@Test
	public childrenContained() {
		withMounted(
			400,
			300,
			<Box width={200} height={120}>
				<frame key="FullChild" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
					<Text text="Inside the box" />
				</frame>
			</Box>,
			(mounted) => {
				const box = waitForBox(mounted.host);
				const child = waitForGuiObject<Frame>(box, "FullChild");

				assertContained(child, box, "full-scale child");
				assertAllDescendantsContained(box, "box children");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("center={true} with a fixed width and height places the Box in the middle of the host")
	@Test
	public centeredInHost() {
		withMounted(400, 300, <Box center={true} width={200} height={100} />, (mounted) => {
			const box = waitForBox(mounted.host);

			assertSizeApprox(box, 200, 100, 1, "centered box");
			assertCenteredIn(box, mounted.host, "both", 1, "centered box");
		});
	}
}

export = BoxMountValidation;
