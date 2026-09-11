import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Assert } from "@rbxts/lunit";

import { ThemeProvider } from "../../Providers/theme.provider";
import { DefaultTheme } from "../../Theme";

export interface LayoutRect {
	left: number;
	top: number;
	right: number;
	bottom: number;
	width: number;
	height: number;
	centerX: number;
	centerY: number;
}

export const STUDIO_SKIP_MESSAGE = "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.";

export interface MountedElement {
	host: Frame;
	root: ReactRoblox.Root;
	update: (element: React.ReactElement) => void;
	resize: (width: number, height: number) => void;
	unmount: () => void;
}

export function mountInScreenGui(width: number, height: number, element: React.ReactElement): MountedElement {
	const coreGui = game.FindFirstChild("CoreGui");
	Assert.notUndefined(coreGui, "Expected CoreGui to be available to host the component under test");

	const gui = new Instance("ScreenGui");
	gui.Name = "LayoutMountValidation";
	gui.Parent = coreGui;

	const host = new Instance("Frame");
	host.Name = "Host";
	host.BackgroundTransparency = 1;
	host.Size = UDim2.fromOffset(width, height);
	host.Parent = gui;

	const root = ReactRoblox.createRoot(host);

	const update = (nextElement: React.ReactElement) => {
		root.render(React.createElement(ThemeProvider, { theme: DefaultTheme }, nextElement));
		task.wait();
	};

	const resize = (nextWidth: number, nextHeight: number) => {
		host.Size = UDim2.fromOffset(nextWidth, nextHeight);
		task.wait();

		waitForLayout(
			() => (host.AbsoluteSize.X === nextWidth && host.AbsoluteSize.Y === nextHeight ? true : undefined),
			`Timed out waiting for the host to resize to ${nextWidth}x${nextHeight} (AbsoluteSize is ${host.AbsoluteSize.X}x${host.AbsoluteSize.Y})`,
		);
		task.wait();
	};

	const unmount = () => {
		root.unmount();
		host.Destroy();
		gui.Destroy();
	};

	update(element);

	return { host, root, update, resize, unmount };
}

export function withMounted(width: number, height: number, element: React.ReactElement, fn: (mounted: MountedElement) => void) {
	const mounted = mountInScreenGui(width, height, element);

	try {
		fn(mounted);
	} finally {
		mounted.unmount();
	}
}

export function waitForLayout<T extends defined>(resolve: () => T | undefined, failureMessage: string): T {
	for (let attempt = 0; attempt < 30; attempt++) {
		const value = resolve();

		if (value !== undefined) {
			return value;
		}

		task.wait();
	}

	return Assert.fail(failureMessage);
}

export function waitForDescendant<T extends Instance>(root: Instance, name: string, predicate: (instance: T) => boolean, failureMessage?: string): T {
	return waitForLayout(() => {
		const found = root.FindFirstChild(name, true) as T | undefined;
		return found !== undefined && predicate(found) ? found : undefined;
	}, failureMessage ?? `Timed out waiting for a descendant named "${name}" to satisfy its predicate`);
}

export function waitForGuiObject<T extends GuiObject>(root: Instance, name: string, predicate?: (gui: T) => boolean, failureMessage?: string): T {
	const test = predicate ?? ((gui: T) => gui.AbsoluteSize.X > 0 && gui.AbsoluteSize.Y > 0);

	return waitForDescendant<T>(
		root,
		name,
		test,
		failureMessage ?? (predicate === undefined
			? `Timed out waiting for a GuiObject named "${name}" to render with a non-zero AbsoluteSize`
			: `Timed out waiting for a GuiObject named "${name}" to satisfy its predicate`),
	);
}

export function findDescendant<T extends Instance>(root: Instance, name: string): T {
	const found = root.FindFirstChild(name, true) as T | undefined;
	Assert.notUndefined(found, `Expected to find a descendant named "${name}" under ${root.GetFullName()}`);
	return found!;
}

export function findDescendantOfClass<K extends keyof Instances>(root: Instance, className: K): Instances[K] {
	const found = root.FindFirstChildWhichIsA(className, true);
	Assert.notUndefined(found, `Expected to find a descendant of class "${className}" under ${root.GetFullName()}`);
	return found!;
}

export function rect(gui: GuiObject): LayoutRect {
	const position = gui.AbsolutePosition;
	const size = gui.AbsoluteSize;

	return {
		left: position.X,
		top: position.Y,
		right: position.X + size.X,
		bottom: position.Y + size.Y,
		width: size.X,
		height: size.Y,
		centerX: position.X + size.X / 2,
		centerY: position.Y + size.Y / 2,
	};
}

export function formatRect(r: LayoutRect): string {
	return `[left=${r.left}, top=${r.top}, right=${r.right}, bottom=${r.bottom}, width=${r.width}, height=${r.height}]`;
}

export function describeGui(gui: GuiObject): string {
	return `${gui.GetFullName()} (${gui.ClassName})`;
}

const EDGE_EPSILON = 0.5;

export function assertContained(child: GuiObject, parent: GuiObject, label: string) {
	const childRect = rect(child);
	const parentRect = rect(parent);

	const contained =
		childRect.left >= parentRect.left - EDGE_EPSILON &&
		childRect.top >= parentRect.top - EDGE_EPSILON &&
		childRect.right <= parentRect.right + EDGE_EPSILON &&
		childRect.bottom <= parentRect.bottom + EDGE_EPSILON;

	Assert.true(
		contained,
		`${label}: expected ${describeGui(child)} ${formatRect(childRect)} to be fully inside ${describeGui(parent)} ${formatRect(parentRect)}`,
	);
}

export function assertAllDescendantsContained(container: GuiObject, label: string, ignore?: (gui: GuiObject) => boolean) {
	const walk = (parent: Instance, clipAncestor: GuiObject) => {
		for (const child of parent.GetChildren()) {
			if (!child.IsA("GuiObject")) {
				walk(child, clipAncestor);
				continue;
			}

			if (!child.Visible) continue;

			if (ignore !== undefined && ignore(child)) {
				walk(child, clipAncestor);
				continue;
			}

			assertContained(child, clipAncestor, label);

			walk(child, child.ClipsDescendants ? child : clipAncestor);
		}
	};

	walk(container, container);
}

function intersects(a: LayoutRect, b: LayoutRect): boolean {
	return (
		a.left + EDGE_EPSILON < b.right &&
		b.left + EDGE_EPSILON < a.right &&
		a.top + EDGE_EPSILON < b.bottom &&
		b.top + EDGE_EPSILON < a.bottom
	);
}

export function assertNoSiblingOverlap(parent: GuiObject, label: string) {
	const siblings: GuiObject[] = [];
	for (const child of parent.GetChildren()) {
		if (child.IsA("GuiObject") && child.Visible) siblings.push(child);
	}

	for (let i = 0; i < siblings.size(); i++) {
		for (let j = i + 1; j < siblings.size(); j++) {
			const a = siblings[i];
			const b = siblings[j];
			const aRect = rect(a);
			const bRect = rect(b);

			Assert.false(
				intersects(aRect, bRect),
				`${label}: expected siblings ${describeGui(a)} ${formatRect(aRect)} and ${describeGui(b)} ${formatRect(bRect)} not to overlap`,
			);
		}
	}
}

export function assertTextFits(textObject: TextLabel | TextButton | TextBox, name: string) {
	if (textObject.TextFits) return;

	const bounds = textObject.TextBounds;
	const size = textObject.AbsoluteSize;
	const message =
		`${name}: text does not fit its ${describeGui(textObject)} - TextFits=false, ` +
		`TextBounds=(${bounds.X}, ${bounds.Y}) vs AbsoluteSize=(${size.X}, ${size.Y}), TextWrapped=${textObject.TextWrapped}`;

	if (!textObject.TextWrapped) {
		Assert.fail(message);
	}

	Assert.true(bounds.X <= size.X + 1 && bounds.Y <= size.Y + 1, message);
}

export function assertCenteredIn(child: GuiObject, parent: GuiObject, axis: "x" | "y" | "both", tolerance = 1, label = "") {
	const childRect = rect(child);
	const parentRect = rect(parent);
	const prefix = label !== "" ? `${label}: ` : "";

	if (axis === "x" || axis === "both") {
		Assert.true(
			math.abs(childRect.centerX - parentRect.centerX) <= tolerance,
			`${prefix}expected ${describeGui(child)} ${formatRect(childRect)} to be horizontally centered in ${describeGui(parent)} ${formatRect(parentRect)} (centerX ${childRect.centerX} vs ${parentRect.centerX}, tolerance ${tolerance})`,
		);
	}

	if (axis === "y" || axis === "both") {
		Assert.true(
			math.abs(childRect.centerY - parentRect.centerY) <= tolerance,
			`${prefix}expected ${describeGui(child)} ${formatRect(childRect)} to be vertically centered in ${describeGui(parent)} ${formatRect(parentRect)} (centerY ${childRect.centerY} vs ${parentRect.centerY}, tolerance ${tolerance})`,
		);
	}
}

export function assertSizeApprox(gui: GuiObject, expectedWidth: number | undefined, expectedHeight: number | undefined, tolerance = 1, label = "") {
	const guiRect = rect(gui);
	const prefix = label !== "" ? `${label}: ` : "";

	if (expectedWidth !== undefined) {
		Assert.true(
			math.abs(guiRect.width - expectedWidth) <= tolerance,
			`${prefix}expected ${describeGui(gui)} width ${guiRect.width} to be within ${tolerance} of ${expectedWidth}`,
		);
	}

	if (expectedHeight !== undefined) {
		Assert.true(
			math.abs(guiRect.height - expectedHeight) <= tolerance,
			`${prefix}expected ${describeGui(gui)} height ${guiRect.height} to be within ${tolerance} of ${expectedHeight}`,
		);
	}
}

export function assertNonZeroSize(gui: GuiObject, label: string) {
	const guiRect = rect(gui);

	Assert.true(
		guiRect.width > 0 && guiRect.height > 0,
		`${label}: expected ${describeGui(gui)} to have a non-zero AbsoluteSize, got ${guiRect.width}x${guiRect.height}`,
	);
}

export function assertMinSize(gui: GuiObject, minWidth: number | undefined, minHeight: number | undefined, label: string) {
	const guiRect = rect(gui);

	if (minWidth !== undefined) {
		Assert.true(
			guiRect.width >= minWidth,
			`${label}: expected ${describeGui(gui)} width ${guiRect.width} to be at least ${minWidth}`,
		);
	}

	if (minHeight !== undefined) {
		Assert.true(
			guiRect.height >= minHeight,
			`${label}: expected ${describeGui(gui)} height ${guiRect.height} to be at least ${minHeight}`,
		);
	}
}

export function assertStackedVertically(children: GuiObject[], label: string) {
	for (let index = 1; index < children.size(); index++) {
		const above = children[index - 1];
		const below = children[index];
		const aboveRect = rect(above);
		const belowRect = rect(below);

		Assert.true(
			aboveRect.bottom <= belowRect.top,
			`${label}: expected ${describeGui(above)} ${formatRect(aboveRect)} to end at or above the top of ${describeGui(below)} ${formatRect(belowRect)}`,
		);
	}
}

export function assertStackedHorizontally(children: GuiObject[], label: string) {
	for (let index = 1; index < children.size(); index++) {
		const leading = children[index - 1];
		const trailing = children[index];
		const leadingRect = rect(leading);
		const trailingRect = rect(trailing);

		Assert.true(
			leadingRect.right <= trailingRect.left,
			`${label}: expected ${describeGui(leading)} ${formatRect(leadingRect)} to end at or before the left edge of ${describeGui(trailing)} ${formatRect(trailingRect)}`,
		);
	}
}

export function assertAlignedLeft(child: GuiObject, parent: GuiObject, tolerance = 1, label = "") {
	const childRect = rect(child);
	const parentRect = rect(parent);
	const prefix = label !== "" ? `${label}: ` : "";

	Assert.true(
		math.abs(childRect.left - parentRect.left) <= tolerance,
		`${prefix}expected ${describeGui(child)} ${formatRect(childRect)} to be left-aligned with ${describeGui(parent)} ${formatRect(parentRect)} (tolerance ${tolerance})`,
	);
}

export function assertAlignedRight(child: GuiObject, parent: GuiObject, tolerance = 1, label = "") {
	const childRect = rect(child);
	const parentRect = rect(parent);
	const prefix = label !== "" ? `${label}: ` : "";

	Assert.true(
		math.abs(childRect.right - parentRect.right) <= tolerance,
		`${prefix}expected ${describeGui(child)} ${formatRect(childRect)} to be right-aligned with ${describeGui(parent)} ${formatRect(parentRect)} (tolerance ${tolerance})`,
	);
}

export function assertAlignedTop(child: GuiObject, parent: GuiObject, tolerance = 1, label = "") {
	const childRect = rect(child);
	const parentRect = rect(parent);
	const prefix = label !== "" ? `${label}: ` : "";

	Assert.true(
		math.abs(childRect.top - parentRect.top) <= tolerance,
		`${prefix}expected ${describeGui(child)} ${formatRect(childRect)} to be top-aligned with ${describeGui(parent)} ${formatRect(parentRect)} (tolerance ${tolerance})`,
	);
}
