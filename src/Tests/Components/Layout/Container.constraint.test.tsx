import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Container } from "../../../Components/Layout/Container";
import {
	STUDIO_SKIP_MESSAGE,
	assertSizeApprox,
	sizeConstraintsOf,
	soleSizeConstraint,
	waitForGuiObject,
	waitForWidth,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;

function content(width = 120, height = 50) {
	return <frame key="Content" BackgroundTransparency={1} Size={UDim2.fromOffset(width, height)} />;
}

@Tag("Studio")
class ContainerSizeConstraint {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without min or max props the Container renders no UISizeConstraint at all")
	@Test
	public noConstraintWhenUnset() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container width={100} height={50} />, (mounted) => {
			const container = waitForGuiObject<ImageLabel>(mounted.host, "Container");

			Assert.equal(sizeConstraintsOf(container).size(), 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Setting min and max props renders one SizeConstraint carrying the resolved pixel sizes")
	@Test
	public singleNamedConstraint() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container width={100} height={50} minWidth="20px" maxWidth={300} minHeight="10" maxHeight={200} />,
			(mounted) => {
				const constraint = soleSizeConstraint(waitForGuiObject<ImageLabel>(mounted.host, "Container"));

				Assert.equal(constraint.MinSize, new Vector2(20, 10));
				Assert.equal(constraint.MaxSize, new Vector2(300, 200));
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A centred auto-sized Container puts the constraint on the inner Container and none on the centre wrapper")
	@Test
	public centeredConstraintOnInner() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container center={true} minWidth={200}>
				{content()}
			</Container>,
			(mounted) => {
				const wrapper = waitForGuiObject<Frame>(mounted.host, "ContainerCenterWrapper");
				const container = waitForGuiObject<ImageLabel>(wrapper, "Container");

				Assert.equal(sizeConstraintsOf(wrapper).size(), 0);
				soleSizeConstraint(container);
				waitForWidth(container, 200);
				assertSizeApprox(wrapper, HOST_WIDTH, HOST_HEIGHT, 1, "centre wrapper still fills the host");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("width 100% with a maxWidth fills a narrow host but stops at the maximum in a wide one")
	@Test
	public percentWidthCapped() {
		withMounted(200, HOST_HEIGHT, <Container width="100%" height={40} maxWidth={250} />, (mounted) => {
			const container = waitForGuiObject<ImageLabel>(mounted.host, "Container");
			waitForWidth(container, 200);

			mounted.resize(HOST_WIDTH, HOST_HEIGHT);
			waitForWidth(container, 250);
			assertSizeApprox(container, 250, 40, 1, "capped container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A minWidth larger than the explicit width raises the rendered width to the minimum")
	@Test
	public minWidthRaises() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container width={50} height={40} minWidth={150} />, (mounted) => {
			const container = waitForGuiObject<ImageLabel>(mounted.host, "Container");

			waitForWidth(container, 150);
			assertSizeApprox(container, 150, 40, 1, "raised container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A minWidth and minHeight raise an auto-sized Container above its content size")
	@Test
	public autoSizeRaised() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container minWidth={200} minHeight="100px">{content(120, 50)}</Container>,
			(mounted) => {
				const container = waitForGuiObject<ImageLabel>(mounted.host, "Container");

				waitForWidth(container, 200);
				assertSizeApprox(container, 200, 100, 1, "raised auto-size");
			},
		);
	}
}

export = ContainerSizeConstraint;
