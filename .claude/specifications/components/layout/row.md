# Row

`Row` is the row half of a 12-column responsive grid: it arranges [`Column`](./column.md) children horizontally and supplies them with sizing/breakpoint context. It follows the shared conventions in [Components](../index.md).

## Public API

- Composes `SpacedElementProps` (`spacing`) and `BreakPointElementProps` (`breakpoints`), plus `children`.
- `breakpoints` overrides the active theme's `theme.breakpoints` for resolving which breakpoint the row is currently at.

## Layout

- Renders a transparent frame sized `UDim2.fromScale(1, 1)` in width and `AutomaticSize.Y` in height — it fills the parent's width and grows to fit its content vertically.
- Children are arranged with a horizontal `UIListLayout` (`SortOrder.LayoutOrder`) that wraps (`Wraps={true}`) once accumulated column widths exceed the row's width.
- `spacing` resolves through the shared theme spacing scale (`SpacingHelper.GetPadding`) and is used both as the list layout's `Padding` and, via `RowContext`, in each `Column`'s width calculation.

## Composition with Column

- `Row` measures its own `AbsoluteSize.X` and exposes it, along with the resolved spacing `UDim` and current `breakpoint`, to descendants through `RowContext`.
- `breakpoint` is derived from the row's own measured width (not the screen/viewport) via `BreakpointHelper.getBreakpoint`, using `breakpoints` (or the theme default).
- `RowContext.children` is the count of direct children of `Row` whose element type is `Column`; `Column` uses this count to divide `12` evenly across columns that don't specify a `span`. Other content passed as a child of `Row` still renders and participates in the list layout, but does not affect this count.
