# Modal

`Modal` overlays a dismissible panel above the rest of the UI, dimming the background behind it. Any number of modals can be open/stacked at once. It follows the shared conventions in [Components](../index.md).

## Public API

- `ModalProps` extends `BoxProps` and `IntentElementProps`, plus:
  - `open?: boolean`, `defaultOpen?: boolean`, `onOpenChange?: (open: boolean) => void` — the standard controlled/uncontrolled pair (mirrors `Accordion`'s `value`/`defaultValue`/`onValueChange`). Supplying `open` makes the modal controlled; interaction still calls `onOpenChange`, but the rendered state only changes once the consumer supplies a new `open` value.
  - `closeOnBackdropClick?: boolean` (default `true`) — clicking the dimmed backdrop behind the panel requests close.
  - `closeOnEscape?: boolean` (default `true`) — pressing Escape (keyboard) or gamepad `ButtonB` while this modal is the topmost open modal requests close.
  - `draggable?: boolean` (default `false`) — allows the panel to be dragged by its direct `Card.Header` children.
  - `initialFocus?: React.RefObject<GuiObject>` — if supplied and populated by the time the modal opens, `GuiService.SelectedObject` moves to that instance instead of the panel itself.
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
- Both the backdrop and the panel are portaled into the shared overlay frame (via `OverlayContext`/`ReactRoblox.createPortal`) — the same mechanism `Select`'s dropdown and `Tooltip`'s popup use — so they render above ordinary sibling content regardless of the trigger's own ancestry/clipping. If no `OverlayProvider` is present (i.e. outside `CleanUiProvider`), `Modal` never renders.

## Focus

- When a modal becomes visible, it records whatever `GuiService.SelectedObject` was immediately beforehand, scoped to that modal instance (so nested modals each restore their own prior selection independently), then moves selection to `initialFocus?.current` if supplied, else the panel `Card` itself.
- When the modal stops being visible, `GuiService.SelectedObject` is restored to whatever it captured on open.

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

A story should demonstrate: a basic modal with `Card.Header`/`Card.Body`/`Card.Footer` content, two modals opened at once to show stacking/z-order, and a controlled modal driven by external state.
