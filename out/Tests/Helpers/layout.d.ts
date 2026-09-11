import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
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
export declare const STUDIO_SKIP_MESSAGE = "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.";
export interface MountedElement {
    host: Frame;
    root: ReactRoblox.Root;
    update: (element: React.ReactElement) => void;
    resize: (width: number, height: number) => void;
    unmount: () => void;
}
export declare function mountInScreenGui(width: number, height: number, element: React.ReactElement): MountedElement;
export declare function withMounted(width: number, height: number, element: React.ReactElement, fn: (mounted: MountedElement) => void): void;
export declare function waitForLayout<T extends defined>(resolve: () => T | undefined, failureMessage: string): T;
export declare function waitForDescendant<T extends Instance>(root: Instance, name: string, predicate: (instance: T) => boolean, failureMessage?: string): T;
export declare function waitForGuiObject<T extends GuiObject>(root: Instance, name: string, predicate?: (gui: T) => boolean, failureMessage?: string): T;
export declare function findDescendant<T extends Instance>(root: Instance, name: string): T;
export declare function findDescendantOfClass<K extends keyof Instances>(root: Instance, className: K): Instances[K];
export declare function rect(gui: GuiObject): LayoutRect;
export declare function formatRect(r: LayoutRect): string;
export declare function describeGui(gui: GuiObject): string;
export declare function assertContained(child: GuiObject, parent: GuiObject, label: string): void;
export declare function assertAllDescendantsContained(container: GuiObject, label: string, ignore?: (gui: GuiObject) => boolean): void;
export declare function assertNoSiblingOverlap(parent: GuiObject, label: string): void;
export declare function assertTextFits(textObject: TextLabel | TextButton | TextBox, name: string): void;
export declare function assertCenteredIn(child: GuiObject, parent: GuiObject, axis: "x" | "y" | "both", tolerance?: number, label?: string): void;
export declare function assertSizeApprox(gui: GuiObject, expectedWidth: number | undefined, expectedHeight: number | undefined, tolerance?: number, label?: string): void;
export declare function assertNonZeroSize(gui: GuiObject, label: string): void;
export declare function assertMinSize(gui: GuiObject, minWidth: number | undefined, minHeight: number | undefined, label: string): void;
export declare function assertStackedVertically(children: GuiObject[], label: string): void;
export declare function assertStackedHorizontally(children: GuiObject[], label: string): void;
export declare function assertAlignedLeft(child: GuiObject, parent: GuiObject, tolerance?: number, label?: string): void;
export declare function assertAlignedRight(child: GuiObject, parent: GuiObject, tolerance?: number, label?: string): void;
export declare function assertAlignedTop(child: GuiObject, parent: GuiObject, tolerance?: number, label?: string): void;
