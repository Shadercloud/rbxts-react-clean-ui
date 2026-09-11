import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Group } from "../../../Components/Layout/Group";
import { Container } from "../../../Components/Layout/Container";
import { VStack } from "../../../Components/Layout/VStack";
import { RegistryProvider } from "../../../Providers/registry.provider";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertNonZeroSize,
	assertSizeApprox,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;
const NARROW_WIDTH = 80;
const WIDE_WIDTH = 150;
const ROW_HEIGHT = 30;

function groupedContainers(grouped: boolean) {
	return (
		<RegistryProvider>
			<frame key="Stack" BackgroundTransparency={1} Size={UDim2.fromScale(1, 1)}>
				<VStack spacing="None" HorizontalFlex={Enum.UIFlexAlignment.None}>
					<Group>
						<Container name="Narrow" group={grouped} LayoutOrder={1}>
							<frame key="NarrowContent" BackgroundTransparency={1} Size={UDim2.fromOffset(NARROW_WIDTH, ROW_HEIGHT)} />
						</Container>
						<Container name="Wide" group={grouped} LayoutOrder={2}>
							<frame key="WideContent" BackgroundTransparency={1} Size={UDim2.fromOffset(WIDE_WIDTH, ROW_HEIGHT)} />
						</Container>
					</Group>
				</VStack>
			</frame>
		</RegistryProvider>
	);
}

@Tag("Studio")
class GroupMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Group renders its children directly into the parent without adding an instance of its own")
	@Test
	public rendersChildrenWithoutWrapper() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Group>
				<frame key="Child" BackgroundTransparency={1} Size={UDim2.fromOffset(NARROW_WIDTH, ROW_HEIGHT)} />
			</Group>,
			(mounted) => {
				const child = waitForGuiObject<Frame>(mounted.host, "Child");

				Assert.equal(child.Parent, mounted.host, "Expected Group's child to be parented straight to the host");
				assertNonZeroSize(child, "group child");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Containers with group={true} inside one Group all adopt the widest member's width")
	@Test
	public groupedContainersShareWidth() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, groupedContainers(true), (mounted) => {
			const narrow = waitForGuiObject<ImageLabel>(
				mounted.host,
				"Narrow",
				(gui) => gui.AbsoluteSize.X === WIDE_WIDTH,
				`Timed out waiting for the narrow grouped Container to widen to ${WIDE_WIDTH}px`,
			);
			const wide = waitForGuiObject<ImageLabel>(mounted.host, "Wide");

			assertSizeApprox(narrow, WIDE_WIDTH, ROW_HEIGHT, 1, "narrow grouped container");
			assertSizeApprox(wide, WIDE_WIDTH, ROW_HEIGHT, 1, "wide grouped container");
			assertAllDescendantsContained(narrow, "narrow grouped container");
			assertAllDescendantsContained(wide, "wide grouped container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Containers without group={true} inside a Group keep their own content width")
	@Test
	public ungroupedContainersKeepOwnWidth() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, groupedContainers(false), (mounted) => {
			const narrow = waitForGuiObject<ImageLabel>(mounted.host, "Narrow");
			const wide = waitForGuiObject<ImageLabel>(mounted.host, "Wide");

			assertSizeApprox(narrow, NARROW_WIDTH, ROW_HEIGHT, 1, "ungrouped narrow container");
			assertSizeApprox(wide, WIDE_WIDTH, ROW_HEIGHT, 1, "ungrouped wide container");
		});
	}
}

export = GroupMountValidation;
