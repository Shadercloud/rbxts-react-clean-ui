import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Container } from "../../../Components/Layout/Container";
import { CssPadding, CssRadius } from "../../../Interfaces/";
import { DefaultTheme } from "../../../Theme";
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

const BORDER_COLOR = Color3.fromRGB(200, 40, 40);

function waitForContainer(host: Instance, name = "Container"): ImageLabel {
	return waitForGuiObject<ImageLabel>(host, name);
}

function strokeOf(container: Instance): UIStroke {
	const stroke = container.FindFirstChildWhichIsA("UIStroke");
	Assert.notUndefined(stroke, `Expected ${container.Name} to have a direct UIStroke child`);
	return stroke!;
}

function paddingOf(container: Instance): UIPadding {
	const padding = container.FindFirstChildWhichIsA("UIPadding");
	Assert.notUndefined(padding, `Expected ${container.Name} to have a direct UIPadding child`);
	return padding!;
}

function cornerOf(container: Instance): UICorner {
	const corner = container.FindFirstChildWhichIsA("UICorner");
	Assert.notUndefined(corner, `Expected ${container.Name} to have a direct UICorner child`);
	return corner!;
}

function assertNoDecorators(instance: Instance, label: string) {
	Assert.undefined(instance.FindFirstChildWhichIsA("UIStroke"), `${label}: expected no UIStroke`);
	Assert.undefined(instance.FindFirstChildWhichIsA("UIPadding"), `${label}: expected no UIPadding`);
	Assert.undefined(instance.FindFirstChildWhichIsA("UICorner"), `${label}: expected no UICorner`);
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

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no border, padding or cornerRadius props the Container renders no UIStroke, UIPadding or UICorner")
	@Test
	public noDecoratorsByDefault() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container>{content()}</Container>, (mounted) => {
			const container = waitForContainer(mounted.host);

			assertNoDecorators(container, "unset props");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A zero borderThickness renders no UIStroke even when a borderColor is given")
	@Test
	public zeroThicknessNoStroke() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container borderThickness={0} borderColor={BORDER_COLOR}>
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host);

				Assert.undefined(container.FindFirstChildWhichIsA("UIStroke"), "Expected no UIStroke for borderThickness 0");
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A positive borderThickness renders a Stroke with that thickness, colour and transparency, drawn inside by default")
	@Test
	public strokeFromBorderProps() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container borderThickness={2} borderColor={BORDER_COLOR} borderTransparency={0.5}>
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host);
				const stroke = strokeOf(container);

				Assert.equal(stroke.Name, "Stroke");
				Assert.equal(stroke.Thickness, 2);
				Assert.equal(stroke.Color, BORDER_COLOR);
				Assert.equal(stroke.Transparency, 0.5);
				Assert.equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("borderPosition outer draws the stroke outside the Container's bounds")
	@Test
	public outerBorderPosition() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container borderThickness={1} borderPosition="outer">
				{content()}
			</Container>,
			(mounted) => {
				const container = waitForContainer(mounted.host);

				Assert.equal(strokeOf(container).BorderStrokePosition, Enum.BorderStrokePosition.Outer);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		["8", 8, 8, 8, 8],
		["4 12", 4, 12, 4, 12],
		["4 8 12 16", 4, 8, 12, 16],
	])
	@DisplayName("A CSS padding quad becomes a UIPadding named Padding with the matching pixel offset on each side")
	@Test
	public paddingQuadSides(padding: CssPadding, top: number, right: number, bottom: number, left: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container padding={padding}>{content()}</Container>, (mounted) => {
			const uiPadding = paddingOf(waitForContainer(mounted.host));

			Assert.equal(uiPadding.Name, "Padding");
			Assert.equal(uiPadding.PaddingTop, new UDim(0, top), `padding="${padding}": PaddingTop`);
			Assert.equal(uiPadding.PaddingRight, new UDim(0, right), `padding="${padding}": PaddingRight`);
			Assert.equal(uiPadding.PaddingBottom, new UDim(0, bottom), `padding="${padding}": PaddingBottom`);
			Assert.equal(uiPadding.PaddingLeft, new UDim(0, left), `padding="${padding}": PaddingLeft`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Padding grows an auto-sized Container by the padded amount around its content")
	@Test
	public paddingGrowsAutoSize() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container padding="4 8 12 16">{content()}</Container>, (mounted) => {
			const container = waitForContainer(mounted.host);

			assertSizeApprox(container, CONTENT_WIDTH + 8 + 16, CONTENT_HEIGHT + 4 + 12, 1, "padded container");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[6, 0, 6],
		["50%", 0.5, 0],
		["sm", 0, DefaultTheme.radius.sm],
		["lg", 0, DefaultTheme.radius.lg],
	])
	@DisplayName("cornerRadius accepts pixels, percentages and theme radius tokens and renders a UICorner named Corners")
	@Test
	public cornerRadiusResolves(radius: CssRadius, scale: number, offset: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container cornerRadius={radius}>{content()}</Container>, (mounted) => {
			const corner = cornerOf(waitForContainer(mounted.host));

			Assert.equal(corner.Name, "Corners");
			Assert.equal(corner.CornerRadius, new UDim(scale, offset), `cornerRadius=${radius}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A zero cornerRadius renders no UICorner")
	@Test
	public zeroRadiusNoCorner() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, <Container cornerRadius={0}>{content()}</Container>, (mounted) => {
			const container = waitForContainer(mounted.host);

			Assert.undefined(container.FindFirstChildWhichIsA("UICorner"), "Expected no UICorner for cornerRadius 0");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With center on an auto-sized Container the stroke, padding and corners land on the inner Container, not the wrapper")
	@Test
	public centeredDecoratorsOnInner() {
		withMounted(
			HOST_WIDTH,
			HOST_HEIGHT,
			<Container center={true} borderThickness={2} padding="6" cornerRadius="md">
				{content()}
			</Container>,
			(mounted) => {
				const wrapper = waitForGuiObject<Frame>(mounted.host, "ContainerCenterWrapper");
				const container = waitForContainer(wrapper);

				assertNoDecorators(wrapper, "centering wrapper");
				Assert.equal(strokeOf(container).Thickness, 2);
				Assert.equal(paddingOf(container).PaddingTop, new UDim(0, 6));
				Assert.equal(cornerOf(container).CornerRadius, new UDim(0, DefaultTheme.radius.md));
			},
		);
	}
}

export = ContainerMountValidation;
