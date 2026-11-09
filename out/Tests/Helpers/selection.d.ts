export declare const SELECTION_SKIP_MESSAGE = "Requires Roblox Studio, a GuiService.SelectedObject that accepts a GuiObject under the CoreGui test host, and a non-gamepad last input type.";
export declare function selectionUnavailable(): boolean;
export declare function resetSelection(): void;
export declare function withSelectionReset(fn: () => void): void;
export declare function selectObject(target: GuiObject): void;
export declare function waitForSelection(expected: GuiObject | undefined, label: string, frames?: number): void;
export declare function assertSelectionStays(expected: GuiObject | undefined, label: string, frames?: number): void;
