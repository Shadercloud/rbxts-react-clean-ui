# Scroller

`Scroller` wraps a `ScrollingFrame` that scrolls vertically and reserves space for its scrollbar only while content actually overflows (or always, with `stableGutter`). It follows the shared conventions in [Components](../index.md).

## Public API

- `Scroller` is a `React.forwardRef` component; its ref is the `ScrollingFrame` (in both the plain and decorated trees below). `ScrollerProps` is exported.
- Composes `SizeElementProps`, `PositionElementProps`, and `SpacedElementProps` (`spacing`), plus `children` and `AutomaticSizeParent?: boolean` (see below).
- `stableGutter?: boolean` (default `false`): always reserve the scrollbar's gutter, so content doesn't shift sideways when the bar appears (like CSS `scrollbar-gutter: stable`).
- `onScroll?: (canvasPosition: Vector2, scroller: ScrollingFrame) => void`: called every time `CanvasPosition` changes, whether from the user or from code.
- `onNearEnd?: () => void` and `nearEndThreshold?: number` (pixels, default `0`, negative treated as `0`): for infinite and cursor-paged lists, see [Near-end callback](#near-end-callback).
- Defaults to filling its parent (`UDim2.fromScale(1, 1)`) and `AutomaticSize.None` when no `Size`/`width`/`height`/`AutomaticSize` is given — unlike `Container`, it does not hug content by default.
- `minWidth`/`maxWidth`/`minHeight`/`maxHeight` follow [Min and max size](../index.md#min-and-max-size) and constrain the Scroller's window, not its canvas. Setting any of them switches to the [decorated tree](#decorated-tree), with the `SizeConstraint` on the wrapper and none on the `ScrollingFrame`.

## Layout and scrolling

- Scrolls vertically only (`ScrollingDirection.Y`); the canvas height is automatic (`AutomaticCanvasSize.Y`) while `CanvasSize` itself is declared as `UDim2.fromScale(1, 0)`.
- `children` render inside an inner transparent frame (`AutomaticSize.Y`) nested in the scrolling frame. When `AutomaticSizeParent` is `true`, a horizontal `UIListLayout` is also placed directly on the scrolling frame itself; without it, an automatically sized parent does not measure the `Scroller` correctly (a Roblox layout quirk).
- The inner content frame's width is `100%` minus the scrollbar thickness (`12px`) and the current `spacing` value, but only while content is actually overflowing (tracked via `AbsoluteCanvasSize`/`AbsoluteWindowSize` comparison); when content fits without scrolling, the content frame uses the full available width instead.
- With `stableGutter`, the content frame is always narrowed as if overflowing and `VerticalScrollBarInset` is `Always` instead of `ScrollBar`, so the window width doesn't change either. Content then has the same width whether or not it overflows.
- `spacing` only controls the extra width reserved next to the scrollbar when it's visible — `Scroller` does not add its own inter-child spacing; nest a [`VStack`](./vstack.md)/[`HStack`](./hstack.md) inside for that.

## Near-end callback

- `onNearEnd` fires when the distance from the bottom of the window to the end of the canvas (`AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y - CanvasPosition.Y`) is at most `nearEndThreshold`. The check runs on mount and whenever the canvas position, canvas size or window size changes.
- It fires once per approach. After firing it stays quiet until it's re-armed, either because the canvas grew (for example a new page was appended) or because the user scrolled further than the threshold away from the end. If the canvas grows but the end is still within the threshold (the new page didn't fill the window), it fires again.
- Content that doesn't overflow counts as "at the end", so a short or empty list fires on mount. Consumers should guard against firing while a load is already in flight.

## Theme

`Scroller` defaults live under `theme.components.scroller`:

- `barColor: Color3` sets `ScrollBarImageColor3`, and the custom thumb's fill when one is drawn.
- `trackColor?: Color3` and `trackTransparency?: number` (default `0`): when `trackColor` is set, a track frame (`ScrollerTrack`, `12px` wide, full height, right edge) is drawn behind the bar while content overflows. `trackTransparency` alone draws nothing.
- `thumbBorderColor?: Color3` and `thumbBorderThickness?: number`: when the thickness is greater than `0`, the native thumb is hidden (`ScrollBarImageTransparency` `1`) and a custom thumb (`ScrollerThumb`, `barColor` fill) is drawn over it. It has an inner `UIStroke` (`ThumbBorder`) of that thickness and colour. An unset colour uses the `UIStroke` default (black).
- No shipped theme sets the optional keys, so they all render the plain native bar exactly as before.

Scrollbar thickness is fixed at `12px` in the implementation and is not currently theme- or prop-configurable.

### Decorated tree

With neither `trackColor` nor a positive `thumbBorderThickness`, and no min/max size prop, the root is the `ScrollingFrame` itself (named `name ?? "Scroller"`), as before. With any of them set, the root becomes a transparent `Frame` named `name ?? "Scroller"`. It takes the anchor, position, size, automatic size and `SizeConstraint`, and contains `ScrollerTrack` (ZIndex 1), the `ScrollingFrame` (named `ScrollingFrame`, `fromScale(1, 1)`, ZIndex 2) and `ScrollerThumb` (ZIndex 3, non-`Active`). The `AutomaticSizeParent` list layout stays on the `ScrollingFrame`.

## Implementation notes

- Track and thumb outline: a native `ScrollingFrame` has no track and its thumb (`TopImage`/`MidImage`/`BottomImage` tinted by `ScrollBarImageColor3`) can't take a `UIStroke`. Both are therefore drawn as overlay frames. They can't be children of the `ScrollingFrame`: they'd scroll with the canvas, feed `AutomaticCanvasSize`, and be laid out by the `AutomaticSizeParent` `UIListLayout`. That's why the decorated tree adds a wrapper.
- `SizeConstraint` must never be a child of the `ScrollingFrame`: with `AutomaticCanvasSize`, Roblox applies a `UISizeConstraint` under a `ScrollingFrame` to the automatic canvas too, so `maxHeight` capped the canvas at the window height. Content was clipped with no scrollbar and no scrolling (the Scroller story with `maxHeight={200}` on `height="200"`). Any min/max prop therefore forces the wrapper tree; `ScrollerTrack`/`ScrollerThumb` are still only drawn when the theme asks for them.
- The wrapper is only used when the theme or a min/max prop asks for it, so the default instance tree (and anything that finds `Scroller` as a `ScrollingFrame` by name) is unchanged. Toggling the decoration at runtime remounts the `ScrollingFrame`, which loses its scroll position. The signal effect depends on `decorated`/`hasCustomThumb` so it reconnects to the new instance.
- `ScrollerThumb` is purely visual. Dragging still goes to the invisible native thumb underneath, so the custom thumb's geometry must match the native one: length `window^2 / canvas` (at least the `12px` thickness, at most the window), offset `CanvasPosition.Y / (canvas - window) * (window - length)`. The minimum length is a guess at Roblox's own clamp. If the native minimum differs, the overlay drifts from the drag target on very long canvases.
- `ScrollerThumb` `Size`/`Position`/`Visible` are written imperatively from the `CanvasPosition`/`AbsoluteCanvasSize`/`AbsoluteWindowSize` signals, not passed as props. That avoids a re-render per scroll frame, and React never overwrites them because it doesn't own them.
- `onScroll`, `onNearEnd` and `nearEndThreshold` are read through `propsRef` so new callback identities don't reconnect signals. The near-end arm flag and last canvas height are locals of the signal effect, so they reset if the `ScrollingFrame` remounts.
- In the decorated tree, the `ScrollingFrame` is `fromScale(1, 1)` of the wrapper, so automatic sizing of the wrapper from its content (`AutomaticSize`/`AutomaticSizeParent`) doesn't work there. Decorated Scrollers need an explicit or parent-relative size.
- `setFrame` hands the instance to the forwarded ref through `ElementHelper.assignRef`. Don't inline a `forwardedRef !== undefined` check: in browser React (the Loom docs preview) an absent forwarded ref is `null` and that check crashes.
