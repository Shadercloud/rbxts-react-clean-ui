# Scroller

`Scroller` wraps a `ScrollingFrame` that scrolls vertically and reserves space for its scrollbar only while content actually overflows. It follows the shared conventions in [Components](../index.md).

## Public API

- Composes `SizeElementProps`, `PositionElementProps`, and `SpacedElementProps` (`spacing`), plus `children`.
- Defaults to filling its parent (`UDim2.fromScale(1, 1)`) and `AutomaticSize.None` when no `Size`/`width`/`height`/`AutomaticSize` is given — unlike `Container`, it does not hug content by default.

## Layout and scrolling

- Scrolls vertically only (`ScrollingDirection.Y`); the canvas height is automatic (`AutomaticCanvasSize.Y`) while `CanvasSize` itself is declared as `UDim2.fromScale(1, 0)`.
- `children` render inside an inner transparent frame (`AutomaticSize.Y`) nested in the scrolling frame; a `UIListLayout` is also placed directly on the scrolling frame itself, which the source notes is required for the parent's automatic-size measurement to work correctly.
- The inner content frame's width is `100%` minus the scrollbar thickness (`12px`) and the current `spacing` value, but only while content is actually overflowing (tracked via `AbsoluteCanvasSize`/`AbsoluteWindowSize` comparison); when content fits without scrolling, the content frame uses the full available width instead.
- `spacing` only controls the extra width reserved next to the scrollbar when it's visible — `Scroller` does not add its own inter-child spacing; nest a [`VStack`](./vstack.md)/[`HStack`](./hstack.md) inside for that.

## Theme

`Scroller` defaults live under `theme.components.scroller`:

- `barColor` sets `ScrollBarImageColor3`.

Scrollbar thickness is fixed at `12px` in the implementation and is not currently theme- or prop-configurable.
