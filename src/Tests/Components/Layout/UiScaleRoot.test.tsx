import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { UiScaleRoot } from "../../../Components/Layout/UiScaleRoot";
import {
	STUDIO_SKIP_MESSAGE,
	assertSizeApprox,
	findDescendant,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const HOST_WIDTH = 400;
const HOST_HEIGHT = 300;

function scaledApp(scale: number, props: { ZIndex?: number; name?: string } = {}) {
	return (
		<UiScaleRoot scale={scale} ZIndex={props.ZIndex} name={props.name}>
			<frame key="Content" BackgroundTransparency={1} Size={UDim2.fromOffset(100, 40)} />
		</UiScaleRoot>
	);
}

function waitForRoot(host: Instance, name = "UiScaleRoot"): Frame {
	return waitForGuiObject<Frame>(host, name);
}

function guiChildren(instance: Instance): GuiObject[] {
	const found: GuiObject[] = [];
	for (const child of instance.GetChildren()) {
		if (child.IsA("GuiObject")) found.push(child);
	}
	return found;
}

function fillsArea(frame: GuiObject, width: number, height: number): boolean {
	return math.abs(frame.AbsoluteSize.X - width) <= 0.5 && math.abs(frame.AbsoluteSize.Y - height) <= 0.5;
}

@Tag("Studio")
class UiScaleRootMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1], [1.25], [1.5]])
	@DisplayName("After its UIScale applies, the root frame covers exactly the host's screen area")
	@Test
	public fillsHost(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), (mounted) => {
			const root = waitForRoot(mounted.host);

			waitForLayout(
				() => (fillsArea(root, HOST_WIDTH, HOST_HEIGHT) ? true : undefined),
				`Timed out waiting for the scale ${scale} root to fill the ${HOST_WIDTH}x${HOST_HEIGHT} host (is ${root.AbsoluteSize.X}x${root.AbsoluteSize.Y})`,
			);

			Assert.true(
				math.abs(root.AbsolutePosition.X - mounted.host.AbsolutePosition.X) <= 0.5 &&
					math.abs(root.AbsolutePosition.Y - mounted.host.AbsolutePosition.Y) <= 0.5,
				`Expected the scale ${scale} root to share the host's top-left corner`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1], [1.25], [1.5]])
	@DisplayName("Mounted straight into a ScreenGui, the scaled root covers the whole ScreenGui")
	@Test
	public fillsScreenGui(scale: number) {
		const coreGui = game.FindFirstChild("CoreGui");
		Assert.notUndefined(coreGui, "Expected CoreGui to be available to host the ScreenGui");

		const gui = new Instance("ScreenGui");
		gui.Name = "UiScaleRootScreenGui";
		gui.Parent = coreGui;

		const root = ReactRoblox.createRoot(gui);

		try {
			root.render(scaledApp(scale));
			task.wait();

			const frame = waitForRoot(gui);
			waitForLayout(
				() => (fillsArea(frame, gui.AbsoluteSize.X, gui.AbsoluteSize.Y) ? true : undefined),
				`Timed out waiting for the scale ${scale} root (${frame.AbsoluteSize.X}x${frame.AbsoluteSize.Y}) to fill the ScreenGui (${gui.AbsoluteSize.X}x${gui.AbsoluteSize.Y})`,
			);
		} finally {
			root.unmount();
			gui.Destroy();
		}
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1], [1.25], [1.5]])
	@DisplayName("The root frame is sized to 1/scale of its parent and carries a UIScale named UiScale set to the scale")
	@Test
	public uiScaleSet(scale: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), (mounted) => {
			const root = waitForRoot(mounted.host);
			const uiScale = root.FindFirstChild("UiScale");

			Assert.notUndefined(uiScale, "Expected a UiScale child on the root frame");
			Assert.true(uiScale!.IsA("UIScale"), `Expected UiScale to be a UIScale, got ${uiScale!.ClassName}`);
			Assert.equal((uiScale as UIScale).Scale, scale, "Expected UIScale.Scale to equal the scale prop");
			Assert.equal(
				root.Size,
				UDim2.fromScale(1 / scale, 1 / scale),
				"Expected the root frame Size to be fromScale(1/scale, 1/scale)",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[1, 100, 40],
		[1.25, 125, 50],
		[1.5, 150, 60],
	])
	@DisplayName("A child sized in design pixels renders at that size times the scale on screen")
	@Test
	public childScaled(scale: number, expectedWidth: number, expectedHeight: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(scale), (mounted) => {
			const root = waitForRoot(mounted.host);
			const content = waitForGuiObject<Frame>(
				root,
				"Content",
				(gui) => math.abs(gui.AbsoluteSize.X - expectedWidth) <= 0.5,
				`Timed out waiting for Content to render ${expectedWidth}px wide at scale ${scale}`,
			);

			assertSizeApprox(content, expectedWidth, expectedHeight, 0.5, `scale ${scale} content`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The root frame is fully transparent, borderless, inactive and keeps the default Position and AnchorPoint")
	@Test
	public transparent() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.5), (mounted) => {
			const root = waitForRoot(mounted.host);

			Assert.equal(root.BackgroundTransparency, 1, "Expected BackgroundTransparency 1");
			Assert.equal(root.BorderSizePixel, 0, "Expected BorderSizePixel 0");
			Assert.equal(root.Position, new UDim2(), "Expected the default Position");
			Assert.equal(root.AnchorPoint, Vector2.zero, "Expected the default AnchorPoint");
			Assert.false(root.Active, "Expected the root frame not to be Active");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[5, 5],
		[undefined, 1],
	])
	@DisplayName("A ZIndex prop is forwarded to the root frame, which otherwise keeps the engine default of 1")
	@Test
	public zIndexForwarded(zIndex: number | undefined, expected: number) {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.25, { ZIndex: zIndex }), (mounted) => {
			const root = waitForRoot(mounted.host);

			Assert.equal(root.ZIndex, expected, `Expected the root frame ZIndex to be ${expected}`);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("At scale 1 the tree is one full-size frame holding only a UiScale of 1 and the children")
	@Test
	public treeShapeAtOne() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1), (mounted) => {
			const root = waitForRoot(mounted.host);
			const hostChildren = mounted.host.GetChildren();

			Assert.equal(hostChildren.size(), 1, "Expected the root frame to be the host's only child");
			Assert.equal(hostChildren[0], root, "Expected the host's only child to be the UiScaleRoot frame");
			Assert.equal(root.Size, UDim2.fromScale(1, 1), "Expected a scale 1 root to be fromScale(1, 1)");

			const children = root.GetChildren();
			Assert.equal(children.size(), 2, `Expected exactly UiScale and Content under the root, got ${children.size()} children`);

			const uiScale = findDescendant<UIScale>(root, "UiScale");
			Assert.equal(uiScale.Parent, root, "Expected UiScale directly under the root frame");
			Assert.equal(uiScale.Scale, 1, "Expected UiScale.Scale 1");

			const gui = guiChildren(root);
			Assert.equal(gui.size(), 1, "Expected Content to be the only GuiObject under the root");
			Assert.equal(gui[0].Name, "Content", "Expected the child to be rendered directly under the root frame");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A name prop renames the root frame")
	@Test
	public customName() {
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledApp(1.25, { name: "AppScale" }), (mounted) => {
			waitForRoot(mounted.host, "AppScale");

			Assert.undefined(mounted.host.FindFirstChild("UiScaleRoot"), "Expected no frame under the default name");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A ref passed to UiScaleRoot receives its root Frame")
	@Test
	public forwardsRef() {
		const ref = React.createRef<Frame>();

		const element = (
			<UiScaleRoot ref={ref} scale={1.5}>
				<frame key="Content" BackgroundTransparency={1} Size={UDim2.fromOffset(100, 40)} />
			</UiScaleRoot>
		);

		withMounted(HOST_WIDTH, HOST_HEIGHT, element, (mounted) => {
			const root = waitForRoot(mounted.host);

			waitForLayout(() => ref.current, "Timed out waiting for the forwarded ref to be assigned");
			Assert.equal(ref.current, root, "Expected the forwarded ref to point at the UiScaleRoot frame");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Nested roots compose physically: 1.2 inside 1.25 still fills the host and renders content at 1.5x")
	@Test
	public nestedComposes() {
		const element = (
			<UiScaleRoot scale={1.25}>
				<UiScaleRoot name="InnerRoot" scale={1.2}>
					<frame key="Content" BackgroundTransparency={1} Size={UDim2.fromOffset(100, 40)} />
				</UiScaleRoot>
			</UiScaleRoot>
		);

		withMounted(HOST_WIDTH, HOST_HEIGHT, element, (mounted) => {
			const inner = waitForRoot(mounted.host, "InnerRoot");
			const content = waitForGuiObject<Frame>(
				inner,
				"Content",
				(gui) => math.abs(gui.AbsoluteSize.X - 150) <= 0.5,
				"Timed out waiting for the nested Content to render at 150px",
			);

			waitForDescendant<UIScale>(inner, "UiScale", (uiScale) => math.abs(uiScale.Scale - 1.2) <= 1e-6);
			assertSizeApprox(inner, HOST_WIDTH, HOST_HEIGHT, 0.5, "inner root");
			assertSizeApprox(content, 150, 60, 0.5, "nested content");
		});
	}
}

export = UiScaleRootMountValidation;
