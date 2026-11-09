# GamepadSelectionGuard

`GamepadSelectionGuard` keeps Roblox's selection outline (`GuiService.SelectedObject`) for gamepad players only. It renders its `children` unchanged and adds no instances. It follows the shared conventions in [Components](../index.md).

## Public API

- `GamepadSelectionGuardProps`:
  - `enabled?: boolean` (default `true`) — while `false` the guard does nothing.
  - `children?: React.ReactNode` — rendered as-is.
- "Gamepad active" means `UserInputService:GetLastInputType()` is one of `Gamepad1`..`Gamepad8`.

## Behaviour

- Place-wide: it acts on whatever `GuiService.SelectedObject` is, not only on objects under its children. Mount one near the root (for example inside `CleanUiProvider`); several are harmless.
- While enabled and the gamepad isn't active, it clears `GuiService.SelectedObject`: once on mount, whenever the last input switches from a gamepad to anything else, and whenever something sets a selection while a non-gamepad input is last (cleared on the next frame, after re-checking the input type).
- It never selects anything. Switching to a gamepad leaves selection to the game or to components such as `Modal`.
- It wins over a `Modal` with `selectionMode="always"` for non-gamepad players.
- Not restored on unmount.

## Shared hook

The same logic is exported for use without the wrapper: `useGamepadSelection(target?, options?)`, from `src/Helpers/gamepad.helper.ts`. `Modal` uses it; see [Modal](./modal.md#focus).

- `target?: GamepadSelectionTarget` (`React.RefObject<GuiObject> | (() => GuiObject | undefined)`) — what to select while the gamepad is active. Omit it to only clear.
- `options?: GamepadSelectionOptions`:
  - `enabled?: boolean` (default `true`) — the hook is active, and its connections exist, only while `true`.
  - `scope?: React.RefObject<Instance>` — "inside" means the selection is the scope instance or a descendant. Omitted means the whole place: any selection counts.
  - `mode?: GamepadSelectionMode` (`"gamepad" | "always"`, default `"gamepad"`) — `"always"` selects `target` on enable whatever the input and never clears on an input switch.
  - `restoreOnRelease?: boolean` (default `false`) — on disable/unmount: if the gamepad is active (or `mode="always"`), restore the selection captured on enable; otherwise clear it if it is inside the scope.
  - `clearOnSelectionChange?: boolean` (default `false`) — also clear a selection set inside the scope while the gamepad isn't active. Read when the hook becomes enabled.
  - `canTakeSelection?: () => boolean` — checked before selecting `target` on a switch to gamepad (not on enable).
- On enable: if the gamepad is active (or `mode="always"`) it selects `target`, otherwise it clears the selection if inside the scope. If `target` hasn't resolved to an instance yet, it retries every frame until it resolves, the hook is disabled, or the gamepad stops being active (outside `mode="always"`).
- On a switch to gamepad: if the selection isn't already inside the scope and `canTakeSelection` allows, it selects `target`. On a switch away: it clears the selection if inside the scope.
- `GamepadHelper` (same file) exposes `isGamepadInputType(inputType)`, `isGamepadActive()`, `trySetSelectedObject(target)` and `isSelectionWithin(selected, scope)`.

## Story

A story should show a selectable button inside the guard and a status line with the current last input type and selected object: clicking or tabbing never leaves an outline, while gamepad input (Studio's gamepad emulator) can still select.

## Implementation notes

- Keyboard UI navigation (the backslash toggle) sets a selection while the last input is `Keyboard`, so the guard clears it. That is the brief's "only gamepad" rule taken literally; a game that wants keyboard navigation should not mount the guard, or should pass `enabled={false}` while it is in use.
- The on-enable retry (`pendingSelect`, a `RunService.Heartbeat` connection) exists because the target can resolve after the enabling effect runs: a `Modal` that mounts already open next to a new `OverlayProvider` only renders its panel after the provider publishes its frame on a later render, so `panelRef.current` is still `undefined` when the effect runs, and the effect (keyed on `enabled` only) never re-runs. The connection is disconnected as soon as the target resolves and on cleanup. A target that never resolves keeps polling while enabled; that is one cheap resolve per frame.
- The selection-changed clear is `task.defer`red and re-checked rather than run inside the `SelectedObject` changed handler, to avoid writing the property from its own change signal. The pending thread is cancelled on cleanup.
