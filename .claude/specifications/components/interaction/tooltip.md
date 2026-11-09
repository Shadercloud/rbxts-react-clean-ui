# Tooltip

`Tooltip` shows contextual content next to a single wrapped element when it is hovered (and, opt-in, when pressed or long-pressed, with a hoverable popup). It follows the shared conventions in [Components](../index.md).

## Public API

- `TooltipProps` extends `BoxProps` and `IntentElementProps` and additionally requires:
  - `content: React.ReactNode | string` — the popup's content.
  - `children: React.ReactElement<React.InstanceProps<GuiObject>>` — exactly one element that becomes the hover target.
  - `placement?: "Top" | "Bottom" | "Left" | "Right" | "Center" | "Auto"` (default `"Top"`). An explicit side is the preferred side, not a guarantee (see Placement).
  - `disabled?: boolean` (default `false`) — suppresses showing. If the popup is open it hides (with the normal fade). The rendered child is identical either way: same instances, same `ref` and handlers, no remount, so toggling it mid-drag under a `Draggable.Handle` is safe.
  - `open?: boolean` — controlled visibility. When set, hover no longer shows or hides the popup; `open` alone decides (still overridden by `disabled`), and `interactive`/`pinOnPress`/`longPress` are ignored. When `undefined`, the tooltip is hover-driven as before.
  - `interactive?: boolean` (default `false`) — the pointer may move from the trigger onto the popup. See Interactive, pinned and long-press tooltips.
  - `pinOnPress?: boolean` (default `false`) — a press (left click or tap) on the trigger pins the popup open.
  - `longPress?: boolean` (default `false`) — on touch, holding a finger on the trigger shows the popup for as long as the finger stays down.
- Because `TooltipProps` extends `BoxProps`, callers may also pass `spacing`, `'border-thickness'`, `'border-color'`, shadow, size, position, background, and z-index props, which style the popup surface itself (not the wrapped child). Exception: the size props (`Size`, `width`, `height`, and `minWidth`/`maxWidth`/`minHeight`/`maxHeight`) are currently ignored; the popup always sizes to its content (tracked in `.claude/ISSUES.md`).
- `Tooltip` clones `children`, attaching a `ref` and adding `MouseEnter`/`MouseLeave`/`InputBegan` handlers (`InputBegan` does nothing unless `pinOnPress` or `longPress` is set). The child's own handlers still run first. The child may be a native element (`<frame>`, `<imagebutton>`, ...) or a component that forwards `ref` and `Event` to an instance.

## Show/hide behavior

- On `MouseEnter`, the tooltip captures the target's current `AbsolutePosition`/`AbsoluteSize` and becomes visible. Because this is recaptured on every show, the popup tracks the target's latest size/position rather than a stale snapshot.
- On `MouseLeave`, the tooltip becomes invisible immediately, but the popup content stays mounted for `theme.components.tooltip.fadeDuration` seconds (to let the fade-out animation play) before unmounting, unless the tooltip is re-shown in the meantime — a hide request counter ensures a rapid leave/re-enter doesn't cause the popup to unmount and then reappear.
- If `fadeDuration <= 0`, the popup unmounts immediately on hide with no delay.
- While visible, the popup follows the target's `AbsolutePosition`/`AbsoluteSize` changes.
- The tooltip is suppressed (treated as `disabled`) when it is inside a `Draggable`'s drag preview, and while the `Draggable` it sits in is being dragged (see [draggable.md](../layout/draggable.md)). Suppression also forgets the hover state, so after it ends the popup only reappears on the next `MouseEnter` (or when `open` says so).
- The popup only exists in the tree while a target has been captured at least once; it is portaled into the app-wide overlay frame (via `OverlayConsumer` + `ReactRoblox.createPortal`), so it renders above ordinary sibling content and outside any clipping/`ZIndex` ancestor of the trigger. If no `OverlayProvider` is present, the tooltip never renders (`OverlayConsumer` receives `overlay === undefined`).

## Interactive, pinned and long-press tooltips

All of this is opt-in. With `interactive`, `pinOnPress` and `longPress` unset, a tooltip shows and hides exactly as described above.

- The popup is open while any of these holds: the trigger is hovered (and not covered, see below), the popup is hovered (`interactive`), it is pinned (`pinOnPress`), a long press is in progress (`longPress`), or a nested tooltip inside its content is open (`interactive` or `pinOnPress` only). `disabled`/drag suppression closes it immediately and clears hover, pin and long-press state.
- **Interactive**: the popup itself tracks `MouseEnter`/`MouseLeave` (only while visible) and is `Active`. When nothing keeps it open any more, it waits `theme.components.tooltip.closeDelay` seconds before hiding, and cancels the close if anything re-opens it meanwhile, so the pointer can cross from the trigger onto the popup (the popup's hit area includes its pointer/shadow padding, which reaches the trigger edge). Non-interactive tooltips still hide at once.
- **Pin on press**: a left click or tap on the trigger toggles the pin. A press on the popup (anywhere in it, including its content) unpins it; it never pins. Unpinning while the trigger or popup is still hovered leaves it open until the pointer leaves. While `pinOnPress` or `longPress` is set, a `MouseEnter` that comes from touch (`UserInputService:GetLastInputType()` is `Touch`) is ignored, because mobile fires `MouseEnter` on tap and no matching `MouseLeave`.
- **Long press**: a touch on the trigger starts a `theme.components.tooltip.longPressDelay` timer. If the finger is still down when it fires, the popup opens and stays open until that touch ends or is cancelled. A touch that ends before the timer is a tap: with `pinOnPress` it toggles the pin (on release rather than on touch-down), otherwise it does nothing. Mouse presses always follow `pinOnPress`.
- **Nesting**: a `Tooltip` rendered inside another tooltip's `content` is one layer deeper. While it is shown it keeps its parent open (if the parent is `interactive` or `pinOnPress`). Once it hides, the parent re-evaluates and closes after its own `closeDelay` if nothing else holds it.
- **Topmost only**: a trigger whose layer depth is at or below the depth of an `interactive` popup the pointer is currently over (other than its own popup) is covered. A covered trigger's hover does not count, an already-open hover-only tooltip closes once its trigger becomes covered, and covered triggers ignore presses. When the covering popup is left or hides, a still-hovered trigger opens again. Only `interactive` popups count as covering, so non-interactive tooltips (e.g. the chart `Center` tooltips) behave as before.

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
- `closeDelay?` — seconds an `interactive` tooltip waits before hiding once nothing keeps it open. Default theme `0.15`; `0.15` if unset. Not read by non-interactive tooltips.
- `longPressDelay?` — seconds a touch must be held on a `longPress` trigger before the popup opens. Default theme `0.5`; `0.5` if unset.
- `spacing` — default internal padding.
- `boxShadow` — optional drop shadow around the popup.
- `intents` — per-intent background/border/text colors for the popup.
- `cornerRadius` — declared but currently unused (see above).

## Animation

- The popup's `GroupTransparency` tweens between `1` (hidden) and `0` (visible) using `quadOut` easing over `fadeDuration`. The fade-in starts once the popup has been measured.

## Story

A story should demonstrate every placement (including `Center` and `Auto`) and a tooltip anchored at a screen edge or corner, so the flip and shift can be seen. It should also show an `interactive` tooltip with a clickable control in its content, a `pinOnPress` tooltip, a `longPress` tooltip (for touch emulation), and an interactive tooltip whose content contains a second interactive tooltip whose popup overlaps another trigger, so nesting and the topmost rule can be seen. The loom scene shows `Top`, `Bottom` and `Auto`.

## Implementation notes

- Events are injected with `ElementHelper.cloneWithEvents`. A raw `Event` table passed through `React.cloneElement` to a native child is assigned as `instance.Event` and throws, unmounting the root (see draggable.md's notes).
- `disabled`/`open`/drag suppression are applied in an effect keyed on `[suppressed, open]`, not by changing what is rendered, so the child's element tree never changes. Uncontrolled hover still calls `show()` synchronously in `MouseEnter`, which the Tooltip tests rely on.
- `shownRef` tracks whether `show()` is in effect so the effect doesn't call `hide()` on mount or re-`show()` an open popup.
- Every open/close decision goes through `update()`, which derives "wanted" from refs (`hoveredRef`, `popupHoveredRef`, `pinnedRef`, `longPressedRef`, `holdsRef`) rather than toggling directly. Delayed callbacks (`task.delay`, the hover registry listener, a child's `retain`/release, the touch `UserInputState` signal) call through `actionsRef`, which is reassigned every render, so they never run a stale render's `props.open`/flags.
- The interactive close is a request counter (`closeRequest`) plus `closingRef`, separate from `hideRequest` (the fade-out unmount). `closingRef` stops repeated non-wanted `update()` calls (every registry change triggers one) from restarting the delay. Only `interactive` tooltips delay; controlled and suppressed closes are immediate so `open={false}`/`disabled` stay instant.
- `Tooltip.layer.ts` holds `TooltipLayerContext` (`{ depth, retain }`, provided by `TooltipPopup` around `content` and carried through the portal by React context) and a module-level registry of hovered interactive popups (`setTooltipHovered`/`isTooltipCovered`/`subscribeTooltipHover`). The registry is module-level rather than provider-based so it works without any new provider in the app. It is internal: not exported from the Interaction barrel.
- Roblox fires `MouseEnter` on every GuiObject under the pointer, covered or not, and `Active` doesn't stop it, so the topmost rule can't come from the engine. It is computed from the registry. MouseEnter order between a popup and the trigger under it is not guaranteed, which is why every tooltip re-evaluates on each registry change instead of only checking on `MouseEnter`.
- Only `interactive` popups are registered. Registering every popup would block neighbouring triggers under non-interactive `Center` popups (BarChart/Pie segments), changing existing behaviour.
- Holds are only honoured by `interactive`/`pinOnPress` parents. Otherwise an existing non-interactive tooltip whose content contains a controlled `open` tooltip would never close.
- The `interactive`/`pinOnPress`/`longPress` locals in `Tooltip` are already `false` when `open` is set, so a controlled popup gets no `onHover`/`onPress`, is not `Active`, never enters the hover registry (so it can't cover other triggers), and its trigger ignores presses and touch long-presses. Gating only `isWanted()` on `props.open` was not enough: the popup still registered as covering when hovered.
- `hide()` clears `popupHoveredRef` and the registry entry because the popup stays mounted (invisible) during the fade, and its `MouseLeave` may never fire once it unmounts. The popup ignores `MouseEnter`/presses while not `visible`, so a fading popup can't re-open itself or cover triggers.
- Long press tracks the release with the touch's own `InputObject` `UserInputState` signal (End or Cancel), not the trigger's `InputEnded`, which doesn't fire if the finger slides off the trigger.
- The popup's `Event` table is always attached (handlers call optional `onHover`/`onPress`), so the canvas group's props don't change shape between modes. `Active` is only set when `onHover`/`onPress` is given.
- `hoveredRef` is cleared on suppression because a dragged original is hidden without a `MouseLeave`. Keeping it would re-open the popup at the old position after the drop.
- The geometry is the pure `computeTooltipLayout` in `Tooltip.placement.ts` (plain numbers and tables, no Roblox datatypes), so it is unit-tested under Lune (`Tooltip.placement.test.ts`). `TooltipPopup` only reads instances, builds the input and turns the result into `UDim2`/`Vector2`.
- The popup size used for fitting is the measured `Content` frame plus the padding that side would get (`getTooltipPadding`), not the canvas group's own `AbsoluteSize`. The pointer padding moves with the side, so the canvas group's size measured on one side is wrong for the other.
- The canvas group keeps the side's `AnchorPoint` (e.g. `(0.5, 1)` for `Top`) and the shift is added to the anchor position, so a small error in the estimated size never detaches the popup from the target edge.
- `contentSize` stays `undefined` until `Content` reports a non-zero `AbsoluteSize`; until then `GroupTransparency` is forced to `1` and the tween goal stays `1`. An empty content popup is therefore never shown.
- `getTopbarBottom` switches on `ScreenGui.ScreenInsets` rather than `IgnoreGuiInset`. A Studio probe showed the two are tied (`IgnoreGuiInset = true` reads back as `DeviceSafeInsets`, `false` as `CoreUISafeInsets`). In Edit mode (where the Studio tests run) `GetGuiInset()` and `TopbarInset` are both zero, so the band only applies in a running game; the band maths is covered by the pure tests.
- The pointer's cross-axis base offset is `(shadow start - shadow end) / 2` on both axes. `Left`/`Right` used to use `0` vertically, which left the pointer a couple of pixels off the content's centre with an uneven shadow.
