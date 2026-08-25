# Slider

`Slider` lets a user pick a numeric value, or a numeric range, by dragging one or two handles along a track. It follows the shared conventions in [Components](../index.md).

## Public API

- `SliderProps extends ContainerProps` (so it accepts the same sizing/position/native `Frame` props as `Container`: `width`, `height`, `top`/`left`/`right`/`bottom`, `center`, `Size`, `Position`, `AnchorPoint`, `ZIndex`, `Change`, `Event`, etc.), plus:
  - `'max-value': number` (required), `'min-value'?: number` (default `0`).
  - `value?: number | Vector2` — initial (or, if `controlled`, current) value. In range mode a `Vector2`'s `X`/`Y` are the lower/upper bounds.
  - `step?: number` — snap increment, offset from `'min-value'`.
  - `onDragged?`, `onChanged?: (value: number | Vector2) => void` — `onDragged` fires continuously while a handle moves (including once immediately when a drag begins); `onChanged` fires once when the drag ends.
  - `controlled?: boolean` — when `true`, the rendered/tracked value is derived directly from `props.value` (falling back to bounds if it doesn't match `range`'s expected type) instead of internal state.
  - `range?: boolean` — enables a second handle and `Vector2` values.
  - `highlight?: "start" | "end" | "middle"` — which section of the track is drawn with the highlight styling.
- `BackgroundTransparency` defaults to `1` (the root frame is otherwise invisible; only the track/handle sub-frames are drawn). The slider's height defaults to `theme.components.slider.height` unless `Size`/`height` overrides it.
- `ContainerProps` includes a `group?: boolean` field (used by `Container` to align widths within a `Group`), but `Slider` builds its own root frame rather than rendering through `Container`, and never reads `props.group` or `GroupContext`. `group` is inert on `Slider`.

## Interaction

- Dragging starts on `InputBegan` on a handle frame, for `MouseButton1` or `Touch` input only. It then tracks a shared `CustomInputService.InputChanged`/`InputEnded` subscription (mounted once for the component's lifetime) for continued movement and drag end, gated by `isDraggingRef`.
- The value implied by a pointer position is computed from `containerRef`'s `AbsoluteSize`/`AbsolutePosition`, clamped to `[min-value, max-value]`, then (if `step` is set) snapped to the nearest multiple of `step` offset from `min-value`, with decimal precision preserved based on `step`'s own decimal places.
- In `range` mode, the handle being dragged (`activeHandleRef`, `0` or `1`) is clamped against the other handle's current value: handle `0` (lower) cannot exceed handle `1`'s value, and handle `1` (upper) cannot go below handle `0`'s value — the handles cannot cross.
- Releasing the pointer (`InputEnded` for `MouseButton1`/`Touch`) ends the drag, clears hover-drag visual state, and fires `onChanged` with the final value.
- Hovering a handle (independent of dragging) tracks a `hoveredHandle` used only for the box-shadow visual below.

## Layout

- The track ("bar") is centered in the slider frame at `theme.components.slider.bar.height`, full width.
- Handles are positioned inside an inset sub-frame (inset by `theme.components.slider.bar.padding` on both sides) at `UDim2.fromScale(position, 0.5)`, where `position` is the value normalized to `[0, 1]` across `[min-value, max-value]`. A handle's own size is height-driven via `uiaspectratioconstraint` (`theme.components.slider.handle.aspectRatio`, default `1`, `DominantAxis.Height`).
- The `highlight` frame, when set, spans: from the track start to the (first) handle for `"start"`; from the (last) handle to the track end for `"end"`; or between both handles for `"middle"` (falls back to the first handle's position alone if there's no second value).

## Theme

`theme.components.slider` supplies:

- `height` — the slider's own default height.
- `bar.height`, `bar.padding`, `bar.borderColor`, `bar.borderThickness`, `bar.cornerRadius`, `bar.backgroundColor`, `bar.backgroundTransparency` for the track.
- `bar.highlight.borderColor`, `bar.highlight.backgroundColor`, `bar.highlight.backgroundTransparency` for the highlighted section.
- `handle.boxShadow` (shown only while a handle is hovered or actively being dragged), `handle.borderColor`, `handle.borderThickness`, `handle.cornerRadius`, `handle.backgroundColor`, `handle.backgroundTransparency`, `handle.aspectRatio`.
- There is no `intent` prop and no themed color states beyond hover-triggered shadow visibility — handle/track colors are fixed, not intent-driven.

## Story

Worth demonstrating: a single-value slider with `onDragged`/`onChanged` wired to visible state, a `step` example, a `range` slider with `highlight="middle"`, and the three `highlight` options on non-range sliders.
