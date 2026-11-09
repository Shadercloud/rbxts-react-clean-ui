import React from "@rbxts/react";
export type GamepadSelectionMode = "gamepad" | "always";
export type GamepadSelectionTarget = React.RefObject<GuiObject> | (() => GuiObject | undefined);
export interface GamepadSelectionOptions {
    enabled?: boolean;
    scope?: React.RefObject<Instance>;
    mode?: GamepadSelectionMode;
    restoreOnRelease?: boolean;
    clearOnSelectionChange?: boolean;
    canTakeSelection?: () => boolean;
}
export declare class GamepadHelper {
    static isGamepadInputType(inputType: Enum.UserInputType): boolean;
    static isGamepadActive(): boolean;
    static trySetSelectedObject(target: GuiObject | undefined): void;
    static isSelectionWithin(selected: GuiObject | undefined, scope: Instance | undefined): boolean;
}
export declare function useGamepadSelection(target?: GamepadSelectionTarget, options?: GamepadSelectionOptions): void;
