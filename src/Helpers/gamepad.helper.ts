import React from "@rbxts/react";
import { GuiService, RunService, UserInputService } from "@rbxts/services";

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

const gamepadInputTypes = new Set<Enum.UserInputType>([
    Enum.UserInputType.Gamepad1,
    Enum.UserInputType.Gamepad2,
    Enum.UserInputType.Gamepad3,
    Enum.UserInputType.Gamepad4,
    Enum.UserInputType.Gamepad5,
    Enum.UserInputType.Gamepad6,
    Enum.UserInputType.Gamepad7,
    Enum.UserInputType.Gamepad8,
]);

export class GamepadHelper {
    public static isGamepadInputType(inputType: Enum.UserInputType): boolean {
        return gamepadInputTypes.has(inputType);
    }

    public static isGamepadActive(): boolean {
        return this.isGamepadInputType(UserInputService.GetLastInputType());
    }

    public static trySetSelectedObject(target: GuiObject | undefined): void {
        pcall(() => {
            GuiService.SelectedObject = target;
        });
    }

    public static isSelectionWithin(selected: GuiObject | undefined, scope: Instance | undefined): boolean {
        if (selected === undefined || scope === undefined) {
            return false;
        }

        return selected === scope || selected.IsDescendantOf(scope);
    }
}

function resolveTarget(target: GamepadSelectionTarget | undefined): GuiObject | undefined {
    if (target === undefined) {
        return undefined;
    }

    if (typeIs(target, "function")) {
        return target();
    }

    return target.current;
}

export function useGamepadSelection(target?: GamepadSelectionTarget, options: GamepadSelectionOptions = {}): void {
    const enabled = options.enabled ?? true;
    const targetRef = React.useRef(target);
    const optionsRef = React.useRef(options);

    React.useEffect(() => {
        targetRef.current = target;
        optionsRef.current = options;
    });

    React.useEffect(() => {
        if (!enabled) {
            return;
        }

        let lastScope: Instance | undefined;
        let pendingClear: thread | undefined;
        let pendingSelect: RBXScriptConnection | undefined;

        const resolveScope = () => {
            const scope = optionsRef.current.scope?.current;

            if (scope !== undefined) {
                lastScope = scope;
            }

            return lastScope;
        };

        const isInScope = (selected: GuiObject | undefined) => {
            if (selected === undefined) {
                return false;
            }

            if (optionsRef.current.scope === undefined) {
                return true;
            }

            return GamepadHelper.isSelectionWithin(selected, resolveScope());
        };

        const isAlways = () => optionsRef.current.mode === "always";

        const shouldHoldSelection = () => isAlways() || GamepadHelper.isGamepadActive();

        const selectTarget = () => {
            const resolved = resolveTarget(targetRef.current);

            if (resolved !== undefined) {
                GamepadHelper.trySetSelectedObject(resolved);
            }

            return resolved !== undefined;
        };

        const stopPendingSelect = () => {
            pendingSelect?.Disconnect();
            pendingSelect = undefined;
        };

        const clearIfInScope = () => {
            if (isInScope(GuiService.SelectedObject)) {
                GamepadHelper.trySetSelectedObject(undefined);
            }
        };

        resolveScope();

        const previousSelection = GuiService.SelectedObject;

        if (shouldHoldSelection()) {
            if (!selectTarget()) {
                pendingSelect = RunService.Heartbeat.Connect(() => {
                    if (!shouldHoldSelection() || selectTarget()) {
                        stopPendingSelect();
                    }
                });
            }
        } else {
            clearIfInScope();
        }

        const inputConnection = UserInputService.LastInputTypeChanged.Connect((inputType) => {
            if (isAlways()) {
                return;
            }

            if (!GamepadHelper.isGamepadInputType(inputType)) {
                clearIfInScope();
                return;
            }

            if (isInScope(GuiService.SelectedObject)) {
                return;
            }

            if (optionsRef.current.canTakeSelection?.() ?? true) {
                selectTarget();
            }
        });

        const selectionConnection = options.clearOnSelectionChange
            ? GuiService.GetPropertyChangedSignal("SelectedObject").Connect(() => {
                if (pendingClear !== undefined || shouldHoldSelection() || !isInScope(GuiService.SelectedObject)) {
                    return;
                }

                pendingClear = task.defer(() => {
                    pendingClear = undefined;

                    if (!shouldHoldSelection()) {
                        clearIfInScope();
                    }
                });
            })
            : undefined;

        return () => {
            inputConnection.Disconnect();
            selectionConnection?.Disconnect();
            stopPendingSelect();

            if (pendingClear !== undefined) {
                task.cancel(pendingClear);
                pendingClear = undefined;
            }

            if (!optionsRef.current.restoreOnRelease) {
                return;
            }

            if (shouldHoldSelection()) {
                GamepadHelper.trySetSelectedObject(previousSelection);
            } else {
                clearIfInScope();
            }
        };
    }, [enabled]);
}
