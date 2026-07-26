import {
    Players,
    RunService,
} from "@rbxts/services";

type GuiRoot = StarterGui | PlayerGui;

interface IndexedGuiObject {
    object: GuiObject;
    siblingIndex: number;
}

interface RenderSurface {
    root: LayerCollector;
    rootIndex: number;
}

export class GuiHelper {
    public static findHighestAncestorOfClass<T extends Instance>(
        instance: Instance,
        className: string,
    ): T | undefined {
        let current: Instance | undefined = instance;
        let highest: T | undefined;

        while (current) {
            if (current.IsA(className as keyof Instances)) {
                highest = current as T;
            }
            current = current.Parent;
        }

        return highest;
    }

    public static printParentTree(instance: Instance) {
        let current: Instance | undefined = instance;

        while (current !== undefined) {
            print(`${current.ClassName}: ${current.Name}`);
            current = current.Parent;
        }
    }

    public static isPointInsideGuiObject(
        guiObject: GuiObject,
        point: Vector2,
    ): boolean {
        const position = guiObject.AbsolutePosition;
        const size = guiObject.AbsoluteSize;

        return (
            point.X >= position.X &&
            point.X <= position.X + size.X &&
            point.Y >= position.Y &&
            point.Y <= position.Y + size.Y
        );
    }

    public static getGuiObjectsAtPosition(
        instance: Instance,
        point: Vector2,
    ): GuiObject[] {
        const root = this.findHighestAncestorOfClass<Frame>(instance, "Frame");

        if (root === undefined) {
            return [];
        }

        const results = new Array<GuiObject>();

        for (const descendant of root.GetDescendants()) {
            if (
                descendant.IsA("GuiObject") &&
                descendant.Visible &&
                this.isPointInsideGuiObject(descendant, point)
            ) {
                results.push(descendant);
            }
        }

        results.sort((a, b) => a.ZIndex > b.ZIndex);

        return results;
    }

    public static getGuiRenderOrder(instance: Instance): GuiObject[] {
        const result = new Array<GuiObject>();

        for (const surface of this.getRenderSurfaces(this.getGuiRoot(instance))) {
            this.appendGuiObjects(surface.root, result);
        }

        return result;
    }

    private static getGuiRoot(instance: Instance): GuiRoot {
        if (RunService.IsRunning()) {
            return Players.LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;
        }

        const r = this.findHighestAncestorOfClass(instance, "PluginGuiService");
        if (r === undefined)
            throw `No root`
        return r as GuiRoot;
    }

    private static getRenderSurfaces(root: GuiRoot): RenderSurface[] {
        const surfaces = new Array<RenderSurface>();

        const visit = (instance: Instance) => {
            for (const [index, child] of ipairs(instance.GetChildren())) {
                if (child.IsA("LayerCollector")) {
                    surfaces.push({
                        root: child,
                        rootIndex: index,
                    });

                    // Don't recurse into another render surface.
                    continue;
                }

                visit(child);
            }
        };

        visit(root);

        surfaces.sort((a, b) => {
            if (a.root.IsA("ScreenGui") && b.root.IsA("ScreenGui")) {
                if (a.root.DisplayOrder !== b.root.DisplayOrder) {
                    return a.root.DisplayOrder < b.root.DisplayOrder;
                }
            }

            return a.rootIndex < b.rootIndex;
        });

        return surfaces;
    }

    private static appendGuiObjects(
        parent: Instance,
        result: GuiObject[],
    ): void {
        const children = new Array<IndexedGuiObject>();

        for (const [index, child] of ipairs(parent.GetChildren())) {
            if (!child.IsA("GuiObject")) {
                continue;
            }

            children.push({
                object: child,
                siblingIndex: index,
            });
        }

        children.sort((a, b) => {
            if (a.object.ZIndex !== b.object.ZIndex) {
                return a.object.ZIndex < b.object.ZIndex;
            }

            // Preserve sibling order.
            return a.siblingIndex < b.siblingIndex;
        });

        for (const child of children) {
            // Parent renders before its children.
            result.push(child.object);
            this.appendGuiObjects(child.object, result);
        }
    }

}