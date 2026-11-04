# Tooltip

`Tooltip` shows contextual content next to a single wrapped element when it is hovered. It follows the shared conventions in [Components](../index.md).

## Public API

- `TooltipProps` extends `BoxProps` and `IntentElementProps` and additionally requires:
  - `content: React.ReactNode | string` — the popup's content.
  - `children: React.ReactElement<React.InstanceProps<GuiObject>>` — exactly one element that becomes the hover target.
  - `placement?: "Top" | "Bottom" | "Left" | "Right" | "Center" | "Auto"` (default `"Top"`). An explicit side is the preferred side, not a guarantee (see Placement).
  - `disabled?: boolean` (default `false`) — suppresses showing. If the popup is open it hides (with the normal fade). The rendered child is identical either way: same instances, same `ref` and handlers, no remount, so toggling it mid-drag under a `Draggable.Handle` is safe.
  - `open?: boolean` — controlled visibility. When set, hover no longer shows or hides the popup; `open` alone decides (still overridden by `disabled`). When `undefined`, the tooltip is hover-driven as before.
- Because `TooltipProps` extends `BoxProps`, callers may also pass `spacing`, `'border-thickness'`, `'border-color'`, shadow, size, position, background, and z-index props, which style the popup surface itself (not the wrapped child).
- `Tooltip` clones `children`, attaching a `ref` and adding `MouseEnter`/`MouseLeave` handlers. The child's own handlers still run first. The child may be a native element (`<frame>`, `<imagebutton>`, ...) or a component that forwards `ref` and `Event` to an instance.

## Show/hide behavior

- On `MouseEnter`, the tooltip captures the target's current `AbsolutePosition`/`AbsoluteSize` and becomes visible. Because this is recaptured on every show, the popup tracks the target's latest size/position rather than a stale snapshot.
- On `MouseLeave`, the tooltip becomes invisible immediately, but the popup content stays mounted for `theme.components.tooltip.fadeDuration` seconds (to let the fade-out animation play) before unmounting, unless the tooltip is re-shown in the meantime — a hide request counter ensures a rapid leave/re-enter doesn't cause the popup to unmount and then reappear.
- If `fadeDuration <= 0`, the popup unmounts immediately on hide with no delay.
- While visible, the popup follows the target's `AbsolutePosition`/`AbsoluteSize` changes.
- The tooltip is suppressed (treated as `disabled`) when it is inside a `Draggable`'s drag preview, and while the `Draggable` it sits in is being dragged (see [draggable.md](../layout/draggable.md)). Suppression also forgets the hover state, so after it ends the popup only reappears on the next `MouseEnter` (or when `open` says so).
- The popup only exists in the tree while a target has been captured at least once; it is portaled into the app-wide overlay frame (via `OverlayConsumer` + `ReactRoblox.createPortal`), so it renders above ordinary sibling content and outside any clipping/`ZIndex` ancestor of the trigger. If no `OverlayProvider` is present, the tooltip never renders (`OverlayConsumer` receives `overlay === undefined`).

## Placement

- `placement` defaults to `"Top"` when omitted.
- The popup's anchor and offset from the target are side-specific: `Top` anchors above center, `Bottom` below center, `Left`/`Right` to the respective side at vertical center, `Center` directly over the target's center.
- Every side except `Center` renders a small diamond-shaped pointer between the popup and the target, rotated and colored to match; `Center` has no pointer.
- Positions are computed in the overlay's local coordinate space (the captured target position minus the overlay frame's `AbsolutePosition`).
- When `theme.components.tooltip.boxShadow` is configured, extra padding is reserved around the popup so the shadow isn't clipped. The pointer side gets at least the pointer's height of padding, and the pointer is offset to stay flush against the popup edge and centred on the content.

### Safe area

- The popup is kept inside a safe area: the overlay's rect inset by `theme.components.tooltip.edgeMargin` on every side, with its top pushed below the Roblox topbar band when the band overlaps the overlay.
- The band's bottom is `GuiService.TopbarInset.Max.Y` in screen space. It is converted to the overlay's space by subtracting the overlay ScreenGui's screen-space origin (`GuiService:GetGuiInset()` top-left Y for `ScreenInsets.CoreUISafeInsets`, i.e. `IgnoreGuiInset = false`; `0` for `None`/`DeviceSafeInsets`, i.e. `IgnoreGuiInset = true`) and the overlay's own `AbsolutePosition.Y`. A ScreenGui that already sits below the bar therefore gets no extra exclusion. `TopbarSafeInsets` guis and overlays outside a ScreenGui get no band. The whole band height is excluded, across the full width.
- The safe area follows changes to the overlay's size and position and to `TopbarInset`.

### Choosing the side

- The popup is measured first (its content's rendered size), then placed. It stays fully transparent until it has been measured once, so it never flashes at the wrong spot. It re-places whenever its content size, the target or the safe area changes.
- A side fits when the popup fits between the target and the safe area's edge on that side.
- `Top`/`Bottom`/`Left`/`Right`: the preferred side if it fits; otherwise the opposite side if that fits; otherwise whichever of the two has more room (a tie keeps the preferred side).
- `Auto`: scores all four sides. A side that fits beats one that doesn't; among fitting sides, the one that needs the least cross-axis shift wins (keeping the popup centred on the trigger and the pointer near the popup's centre), then the one with the most spare room on the main axis, then the order Top, Bottom, Right, Left. If no side fits, the side with the most room wins.
- `Center` never flips.

### Shift

- After the side is chosen, the popup is clamped on both axes to stay inside the safe area. In practice this shifts along the cross axis; the main axis only moves when neither side fits (the popup may then overlap the target). A popup larger than the safe area aligns to its top/left edge.
- The pointer keeps pointing at the target's centre: it moves along the popup edge by the opposite of the shift, clamped so it stays on the content's straight edge, clear of the rounded corners (corner radius plus the pointer's half-diagonal from each end). If the content is too small for that, the pointer stays centred.

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
- `edgeMargin` — the minimum gap in pixels between the popup and the overlay's edges (and the topbar band). Default `8`.
- `spacing` — default internal padding.
- `boxShadow` — optional drop shadow around the popup.
- `intents` — per-intent background/border/text colors for the popup.
- `cornerRadius` — declared but currently unused (see above).

## Animation

- The popup's `GroupTransparency` tweens between `1` (hidden) and `0` (visible) using `quadOut` easing over `fadeDuration`. The fade-in starts once the popup has been measured.

## Story

A story should demonstrate every placement (including `Center` and `Auto`) and a tooltip anchored at a screen edge or corner, so the flip and shift can be seen. The loom scene shows `Top`, `Bottom` and `Auto`.

## Implementation notes

- Events are injected with `ElementHelper.cloneWithEvents`. A raw `Event` table passed through `React.cloneElement` to a native child is assigned as `instance.Event` and throws, unmounting the root (see draggable.md's notes).
- `disabled`/`open`/drag suppression are applied in an effect keyed on `[suppressed, open]`, not by changing what is rendered, so the child's element tree never changes. Uncontrolled hover still calls `show()` synchronously in `MouseEnter`, which the Tooltip tests rely on.
- `shownRef` tracks whether `show()` is in effect so the effect doesn't call `hide()` on mount or re-`show()` an open popup.
- `hoveredRef` is cleared on suppression because a dragged original is hidden without a `MouseLeave`. Keeping it would re-open the popup at the old position after the drop.
- The geometry is the pure `computeTooltipLayout` in `Tooltip.placement.ts` (plain numbers and tables, no Roblox datatypes), so it is unit-tested under Lune (`Tooltip.placement.test.ts`). `TooltipPopup` only reads instances, builds the input and turns the result into `UDim2`/`Vector2`.
- The popup size used for fitting is the measured `Content` frame plus the padding that side would get (`getTooltipPadding`), not the canvas group's own `AbsoluteSize`. The pointer padding moves with the side, so the canvas group's size measured on one side is wrong for the other.
- The canvas group keeps the side's `AnchorPoint` (e.g. `(0.5, 1)` for `Top`) and the shift is added to the anchor position, so a small error in the estimated size never detaches the popup from the target edge.
- `contentSize` stays `undefined` until `Content` reports a non-zero `AbsoluteSize`; until then `GroupTransparency` is forced to `1` and the tween goal stays `1`. An empty content popup is therefore never shown.
- `getTopbarBottom` switches on `ScreenGui.ScreenInsets` rather than `IgnoreGuiInset`. A Studio probe showed the two are tied (`IgnoreGuiInset = true` reads back as `DeviceSafeInsets`, `false` as `CoreUISafeInsets`). In Edit mode (where the Studio tests run) `GetGuiInset()` and `TopbarInset` are both zero, so the band only applies in a running game; the band maths is covered by the pure tests.
- The pointer's cross-axis base offset is `(shadow start - shadow end) / 2` on both axes. `Left`/`Right` used to use `0` vertically, which left the pointer a couple of pixels off the content's centre with an uneven shadow.
