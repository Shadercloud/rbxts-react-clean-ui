export declare class GuiHelper {
    static findHighestAncestorOfClass<T extends Instance>(instance: Instance, className: string): T | undefined;
    static printParentTree(instance: Instance): void;
    static isPointInsideGuiObject(guiObject: GuiObject, point: Vector2): boolean;
    static getGuiObjectsAtPosition(instance: Instance, point: Vector2): GuiObject[];
    static getGuiRenderOrder(instance: Instance): GuiObject[];
    private static getGuiRoot;
    private static getRenderSurfaces;
    private static appendGuiObjects;
}
