import React from "@rbxts/react";
import { Test, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Container } from "../../../Components/Layout/Container";
import {
	STUDIO_SKIP_MESSAGE,
	assertAlignedLeft,
	assertAlignedTop,
	assertAllDescendantsContained,
	assertCenteredIn,
	assertSizeApprox,
	waitForGuiObject,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;
const CONTENT_WIDTH = 120;
const CONTENT_HEIGHT = 50;

function content() {
	return <frame key="Content" BackgroundTransparency={1} Size={UDim2.fromOffset(CONTENT_WIDTH, CONTENT_HEIGHT)} />;
}

function waitForContainer(host: Instance, name = "Container"): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, name);
}

@Tag("Studio")
class ContainerMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without width or height the Container auto-sizes to its content and sits at the host's top-left")
	@Test
	public autoSizesToContent() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container>{content()}</Container>, (mounted) => {
			const container = waitForContainer(mounted.host);

			assertSizeApprox(container, CONTENT_WIDTH, CONTENT_HEIGHT, 1, "auto-sized container");
			assertAlignedLeft(container, mounted.host, 1, "auto-sized container");
			assertAlignedTop(container, mounted.host, 1, "auto-sized container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[300, 150],
		[80, 40],
	])
	@DisplayName("Explicit width and height props pin the Container's AbsoluteSize to those pixel values")
	@Test
	public respectsExplicitSize(width: number, height: number) {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container width={width} height={height}>
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host);

				assertSizeApprox(container, width, height, 1, "explicit size");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("center={true} with a fixed width and height places the Container in the middle of the host")
	@Test
	public centeredExplicitSize() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container center={true} width={200} height={100}>
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host);

				assertSizeApprox(container, 200, 100, 1, "centered container");
				assertCenteredIn(container, mounted.host, "both", 1, "centered container");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("center={true} on an auto-sized Container centers it via the layout wrapper while keeping its content size")
	@Test
	public centeredAutoSize() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container center={true}>{content()}</Container>, (mounted) => {
			const container = waitForContainer(mounted.host);

			assertSizeApprox(container, CONTENT_WIDTH, CONTENT_HEIGHT, 1, "centered auto-sized container");
			assertCenteredIn(container, mounted.host, "both", 1, "centered auto-sized container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A named, fixed-size Container renders under that name and keeps every visible descendant inside itself")
	@Test
	public namedContainerContainsChildren() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container name="Panel" width={200} height={100}>
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host, "Panel");
				waitForGuiObject<Frame>(container, "Content");

				assertAllDescendantsContained(container, "named container");
			},
		);
	}
}

export = ContainerMountValidation;
