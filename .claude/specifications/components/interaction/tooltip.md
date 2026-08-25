# Tooltip

`Tooltip` shows contextual content next to a single wrapped element when it is hovered. It follows the shared conventions in [Components](../index.md).

## Public API

- `TooltipProps` extends `BoxProps` and `IntentElementProps` and additionally requires:
  - `content: React.ReactNode | string` — the popup's content.
  - `children: React.ReactElement<React.InstanceProps<GuiObject>>` — exactly one element that becomes the hover target.
  - `placement?: "Top" | "Bottom" | "Left" | "Right" | "Center"` (default `"Top"`).
- Because `TooltipProps` extends `BoxProps`, callers may also pass `spacing`, `'border-thickness'`, `'border-color'`, shadow, size, position, background, and z-index props, which style the popup surface itself (not the wrapped child).
- `Tooltip` clones `children` via `React.cloneElement`, attaching a `ref` and wrapping the child's existing `Event.MouseEnter`/`MouseLeave` handlers — the child's own handlers still run, followed by the tooltip's show/hide logic.

## Show/hide behavior

- On `MouseEnter`, the tooltip captures the target's current `AbsolutePosition`/`AbsoluteSize` and becomes visible. Because this is recaptured on every show, the popup tracks the target's latest size/position rather than a stale snapshot.
- On `MouseLeave`, the tooltip becomes invisible immediately, but the popup content stays mounted for `theme.components.tooltip.fadeDuration` seconds (to let the fade-out animation play) before unmounting, unless the tooltip is re-shown in the meantime — a hide request counter ensures a rapid leave/re-enter doesn't cause the popup to unmount and then reappear.
- If `fadeDuration <= 0`, the popup unmounts immediately on hide with no delay.
- The popup only exists in the tree while a target has been captured at least once; it is portaled into the app-wide overlay frame (via `OverlayConsumer` + `ReactRoblox.createPortal`), so it renders above ordinary sibling content and outside any clipping/`ZIndex` ancestor of the trigger. If no `OverlayProvider` is present, the tooltip never renders (`OverlayConsumer` receives `overlay === undefined`).

## Placement

- `placement` defaults to `"Top"` when omitted.
- The popup's anchor and offset from the target are placement-specific: `Top` anchors above center, `Bottom` below center, `Left`/`Right` to the respective side at vertical center, `Center` directly over the target's center.
- Every placement except `Center` renders a small diamond-shaped pointer between the popup and the target, rotated and colored to match; `Center` has no pointer.
- Popup position is computed in the overlay's local coordinate space by subtracting the overlay frame's own `AbsolutePosition` from the captured target position.
- When `theme.components.tooltip.boxShadow` is configured, extra padding is reserved around the popup so the shadow isn't clipped, and this padding also shifts the pointer's offset to keep it flush against the popup edge.

## Content

- String `content` renders inside a `Text` colored with the resolved intent's text color; any other `content` renders as-is (arbitrary React content).
- Intent colors come from `ColorHelper.getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents)`.
- Internal padding comes from `spacing` (falling back to `theme.components.tooltip.spacing`) via the shared spacing helpers.
- Border thickness/color fall back to `theme.components.box.borderThickness` and the resolved intent's border color (there is no tooltip-specific border-thickness theme field).
- The popup's rounded corners currently use `theme.components.button.cornerRadius`, not `theme.components.tooltip.cornerRadius` — despite `cornerRadius` being declared on the tooltip theme shape, it is not read anywhere in this component. Treat this as a known dead theme field rather than intended behavior.

## Theme

Tooltip defaults live under `theme.components.tooltip`:

- `fadeDuration` — show/hide transparency tween duration; `0` disables the tween (still subject to the delayed-unmount behavior described above).
- `pointerSize` — the pixel size of the pointer diamond; `0` (or `"Center"` placement) omits the pointer.
- `spacing` — default internal padding.
- `boxShadow` — optional drop shadow around the popup.
- `intents` — per-intent background/border/text colors for the popup.
- `cornerRadius` — declared but currently unused (see above).

## Animation

- The popup's `GroupTransparency` tweens between `1` (hidden) and `0` (visible) using `quadOut` easing over `fadeDuration`.

## Story

A story should demonstrate all five placements (including `Center`) and a tooltip anchored near a screen edge, since the pointer orientation and popup anchoring differ meaningfully by placement and by available space.
