# Modal

`Modal` overlays a dismissible panel above the rest of the UI, dimming the background behind it. Any number of modals can be open/stacked at once. It follows the shared conventions in [Components](../index.md).

## Public API

- `ModalProps` extends `BoxProps` and `IntentElementProps`, plus:
  - `open?: boolean`, `defaultOpen?: boolean`, `onOpenChange?: (open: boolean) => void` — the standard controlled/uncontrolled pair (mirrors `Accordion`'s `value`/`defaultValue`/`onValueChange`). Supplying `open` makes the modal controlled; interaction still calls `onOpenChange`, but the rendered state only changes once the consumer supplies a new `open` value.
  - `closeOnBackdropClick?: boolean` (default `true`) — clicking the dimmed backdrop behind the panel requests close.
  - `closeOnEscape?: boolean` (default `true`) — pressing Escape (keyboard) or gamepad `ButtonB` while this modal is the topmost open modal requests close.
  - `draggable?: boolean` (default `false`) — allows the panel to be dragged by its direct `Card.Header` children.
  - `initialFocus?: React.RefObject<GuiObject>` — if supplied and populated when the modal takes the selection, `GuiService.SelectedObject` moves to that instance instead of the panel itself. See Focus.
  - `selectionMode?: "gamepad" | "always"` (default `"gamepad"`) — when the modal takes `GuiService.SelectedObject`. `"gamepad"` only selects while the player's last input was a gamepad; `"always"` is the pre-2.0.0 behaviour (select on every open whatever the input device, never cleared on an input switch). See Focus.
  - `children` — expected to be `Card.Header`/`Card.Body`/`Card.Footer` elements; they are forwarded straight through to an internal `Card` with no extra wiring.
- `useModalClose()` (from the modal-close context; throws if called outside a `Modal`) returns a `() => void` that closes the nearest ancestor `Modal` — use it from a custom header/footer close button instead of threading a close handler down manually.
- Because `ModalProps` extends `BoxProps`, callers may also pass `spacing`, `'border-thickness'`, `'border-color'`, shadow, size, position, background, and z-index props — these style the panel `Card`, not the backdrop.

## Stacking

- Any number of `Modal`s can be open simultaneously (nested or sibling). Each registers itself with an app-wide modal stack (`ModalProvider`, wired into `CleanUiProvider` between `OverlayProvider` and `ToastProvider`) while it is visible — including through its own closing fade — and unregisters once it finishes closing or unmounts.
- Escape/`ButtonB` only ever closes the topmost registered modal, and only if that modal's own `closeOnEscape` is `true` at the time.
- Each modal's backdrop and panel derive their `ZIndex` from `theme.components.modal.baseZIndex + <registration index> * theme.components.modal.zIndexStep` (panel = backdrop + 1), so a later-opened modal draws over earlier ones.

## Show/hide behavior

- Two layers of state: the public `open` value (controlled or uncontrolled) and an internal "still mounted" flag that lags behind on close so the fade-out animation can finish before the backdrop/panel actually unmount and un-register from the stack.
- If `theme.components.modal.fadeDuration <= 0`, closing unmounts immediately with no animation.
- Re-opening while still fading out cancels the pending unmount and fades back in from the current transparency, rather than restarting or stacking animations.
- While not visible (fully unmounted, not just faded), `Modal` renders nothing and nothing is portaled.

## Content and layout

- The backdrop is a full-screen, borderless, flat-colored `imagebutton` (deliberately not `Box`/`Button` — it needs a plain rectangle with no themed corner radius or button chrome) colored from `theme.components.modal.backdrop.backgroundColor`/`backgroundTransparency`. Clicking it requests close when `closeOnBackdropClick` is true.
- The panel `Card` is centered by the full-screen wrapping `canvasgroup`'s `UIListLayout` — all border, corner radius, intent, and padding styling comes from `theme.components.card`/`theme.components.box`, exactly as it would for a standalone `Card`. `Modal`'s `intent` forwards straight to the `Card`.
- The `Card` is wrapped in a transparent, content-sized `imagebutton` that consumes activation over the panel's rendered footprint. This prevents blank/non-button panel areas from activating the ancestor backdrop button; interactive buttons inside the panel continue to receive their own activation normally.
- When `draggable` is true, the panel input shield is wrapped in `Draggable` with `retainPosition` enabled and no placeholder. Each direct `Card.Header` child acts as a `Draggable.Handle`; releasing a drag leaves the panel at its dropped position. A pointer press over a nested `GuiButton` or `TextBox` in the header does not start dragging, so close buttons and other header controls activate normally. The shield starts centered through its own `Position`/`AnchorPoint` rather than the parent `UIListLayout`, which would otherwise overwrite the retained position. A modal without a direct `Card.Header` has no drag handle.
- Panel width defaults to `theme.components.modal.width` unless the instance's own `width` or `Size` prop overrides it; height is automatic unless `height` or `Size` supplies it. The panel input shield owns this resolved size relative to the full-screen canvas, while the `Card` fills each fixed axis and sizes to content on each automatic axis. This avoids a relative-size cycle between a scale-sized `Card` and its content-sized shield, and keeps the shield aligned to the exact rendered panel footprint.
- `minWidth`/`maxWidth`/`minHeight`/`maxHeight` follow [Min and max size](../index.md#min-and-max-size). They are drawn on both the input shield and the `Card` (which receives them through the props spread), so a clamped panel stays centred and draggable at its clamped footprint. Minimums apply to every axis, including an automatic one (they raise an auto-sized panel). Maximums only cap a sized axis, such as the default theme width or an explicit `width`/`%`: a `UISizeConstraint` `MaxSize` does not stop `AutomaticSize` growth driven by children, so an automatic axis (such as the default height) still grows to fit its content. For example `width="90%" maxWidth={720}`.
- Both the backdrop and the panel are portaled into the shared overlay frame (via `OverlayContext`/`ReactRoblox.createPortal`) — the same mechanism `Select`'s dropdown and `Tooltip`'s popup use — so they render above ordinary sibling content regardless of the trigger's own ancestry/clipping. If no `OverlayProvider` is present (i.e. outside `CleanUiProvider`), `Modal` never renders.

## Focus

Selection follows the shared gamepad-selection behaviour (`useGamepadSelection`, see [GamepadSelectionGuard](./gamepadselectionguard.md)). "Gamepad active" means `UserInputService:GetLastInputType()` is one of `Gamepad1`..`Gamepad8`. "Inside the modal" means the selected object is the modal's backdrop or a descendant of it (backdrop, input shield, panel and all content).

- **Behaviour change in 2.0.0:** with the default `selectionMode="gamepad"`, mouse, keyboard and touch players no longer get a selection (and so no Roblox selection outline) when a modal opens. Gamepad players behave as before. Pass `selectionMode="always"` to restore the old behaviour.
- When a modal becomes visible, it records whatever `GuiService.SelectedObject` was immediately beforehand, scoped to that modal instance (so nested modals each restore their own prior selection independently). If the gamepad is active (or `selectionMode="always"`), it then moves selection to `initialFocus?.current` if supplied, else the panel `Card` itself. Otherwise it leaves the selection alone. This also applies to a modal that mounts already open (for example next to a freshly mounted `OverlayProvider`, where the panel only exists a frame later): the selection is taken as soon as the panel exists.
- While visible, with `selectionMode="gamepad"`, it follows input-type changes:
  - switching to a gamepad selects into the modal (`initialFocus`, else the panel), unless the selection is already inside it, and only if this modal is the topmost open modal, so a lower stacked modal never steals selection from the one above;
  - switching to any non-gamepad input clears the selection if it is inside the modal. A selection outside the modal is left alone.
- When the modal stops being visible (after its fade): if the gamepad is active (or `selectionMode="always"`), `GuiService.SelectedObject` is restored to whatever it captured on open, as before. Otherwise the selection is cleared if it is still inside the modal and nothing is restored, so a mouse player is not handed a selection outline on close.
- A place-wide `GamepadSelectionGuard` clears any selection while the gamepad isn't active, including one a `selectionMode="always"` modal takes. The guard wins.

## Theme

Modal defaults live under `theme.components.modal`:

- `fadeDuration` — backdrop/panel transparency tween duration; `0` disables animation and closing becomes instantaneous.
- `baseZIndex`/`zIndexStep` — see Stacking above.
- `width` — the panel's default width.
- `backdrop.backgroundColor`/`backdrop.backgroundTransparency` — the dimming scrim's color/opacity while a modal is fully open.
- The panel's border, corner radius, intent colors, and padding all come from `theme.components.card`/`theme.components.box`, not from a modal-specific field — `theme.components.modal` is deliberately minimal.

## Animation

- Backdrop `BackgroundTransparency` and panel `GroupTransparency` (via a wrapping `canvasgroup`) each tween independently between their open/closed values using the shared `useTween` utility, gated by `theme.components.modal.fadeDuration`.

## Story

A story should demonstrate: a basic modal with `Card.Header`/`Card.Body`/`Card.Footer` content, two modals opened at once to show stacking/z-order, a controlled modal driven by external state, and a modal with `initialFocus` on a footer button plus a `selectionMode="always"` variant (the selection outline only shows with gamepad input, or always for the variant).

## Implementation notes

- `GuiService.SelectedObject` throws when the target isn't under a `PlayerGui` (for example in a ui-labs Studio preview). Focus is optional polish, so `GamepadHelper.trySetSelectedObject` wraps the assignment in `pcall` and ignores failures.
- Selection is driven by `useGamepadSelection(target, { enabled: shouldRender, scope: backdropRef, mode, restoreOnRelease: true, canTakeSelection })`. `enabled` is `shouldRender`, not `open`, so the selection stays in the panel through the closing fade and restores after it, as before.
- The scope is `backdropRef` (the `ModalBackdrop` imagebutton), not `panelRef`. The backdrop and the input shield are `GuiButton`s and so selectable; gamepad navigation can land on them, and they must count as "inside the modal" for the clear-on-switch rule.
- `canTakeSelection` calls `stack.isTopmost?.(id)`. `LastInputTypeChanged` fires every open modal's handler in an unspecified order, so without it a lower stacked modal could win the selection. It is optional-chained because `isTopmost` is optional on `ModalStackContextValue`, and is not consulted on open: the stack's `setStack` hasn't committed when the open effect runs, and a newly opened modal is topmost anyway.
- A modal mounted open in the same render as its `OverlayProvider` has no panel when the hook's enable effect runs (the `OverlayConsumer` renders nothing until the provider publishes its frame). `useGamepadSelection` retries the selection every frame until the target resolves; see [GamepadSelectionGuard](./gamepadselectionguard.md#implementation-notes).
- On unmount React detaches `backdropRef` before the passive cleanup runs, so `useGamepadSelection` keeps the last resolved scope instance. Don't change it to read `scope.current` only at cleanup, or the close-time "clear if inside" check would see no scope.
- The stack-registration effect depends only on `shouldRender`. It reads `closeOnEscape` and `requestClose` through refs that are updated on every render, so adding them to the dependencies would re-register the modal whenever they change. Re-registering appends it to the end of the stack, moving it to the top z-order and making it the Escape target.
