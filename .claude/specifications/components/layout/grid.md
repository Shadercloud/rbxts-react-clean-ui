# Grid

`Grid` is a responsive, uniform-cell grid: it arranges its direct children (a mix of library components and native Roblox instances) into a fixed number of equal-width columns, with every cell sized to the same, content-driven row height. It follows the shared conventions in [Components](../index.md).

## Public API

- `cols` — either a plain number, or an object keyed by breakpoint (`xs`/`sm`/`md`/`lg`/`xl`) mapping to a column count for that breakpoint and up. Resolves against the Grid's own measured container width (not the viewport), mobile-first (a breakpoint with no value defined falls back to the next smaller breakpoint that has one). Defaults to `1` if unresolved.
- `breakpoints` (`BreakPointElementProps`) overrides the active theme's `theme.breakpoints` for resolving which breakpoint's `cols` value applies, the same convention [`Row`](./row.md) uses.
- `gap` (`ScaleSize | "None"`) is the shared spacing scale value used for both the horizontal gap between columns and the vertical gap between rows; resolved through `SpacingHelper.GetPadding` the same way `HStack`/`VStack`'s `spacing` prop is.
- `width` (`ResponsiveCssSize`) is `Grid`'s own outer width — the same CSS-style width every other component in this package accepts (a plain number, `"50%"`, `"300px"`, `"Auto"`, or a per-breakpoint object). Resolved via `SizeHelper.GetSize(props, UDim2.fromScale(1, 1))`, exactly like `Box`/`Container`. Defaults to filling the parent (`Scale(1, 1)`) when omitted, preserving every prior usage that wrapped `Grid` in an outer `Container` for sizing. Height remains never user-settable — it is always driven by `Grid`'s own measure/lock cycle described below, unaffected by this prop.
- `children` — arbitrary nodes placed into cells in order, one child per cell. No wrapper/cell component is required from the caller.
- No dedicated `theme.components.grid` entry exists — `Grid` is a layout-only primitive with no colors/border/typography of its own, the same as `Row`/`Column`/`HStack`/`VStack`.

## Layout

- Column width is deterministic from `cols` and `gap`: `CellSize.X.Scale = 1 / cols`, `CellSize.X.Offset = -gap * (cols - 1) / cols`, so `cols` cells plus `cols - 1` gaps of `gap` pixels exactly fill one row.
- Row height is uniform across every cell in the grid, sized to the tallest child's natural (wrapped) height. Because a `UIGridLayout` forces a child's `Size` to `CellSize` the instant it's applied — a child never gets to report its own natural size once inside the grid — this requires two passes:
  1. **Measure**: each child is wrapped in an internal cell frame sized to the target column width (`CellSize.X` above) with `AutomaticSize.Y` and no `UIGridLayout` yet (cells are instead laid out with a horizontal, wrapping `UIListLayout` using the same per-cell width and `gap` padding, purely so cells don't overlap while their natural height is being read via `AbsoluteSize`).
  2. **Lock**: once every cell has reported a height, `Grid` waits one further engine step with no additional report coming in before treating the measurement as settled — nested `AutomaticSize` content (e.g. a child wrapping a child) can take more than one step to reach its final height, and any report that arrives during that step restarts the wait. Once settled, the tallest reported value becomes the row height. A `UIGridLayout` is then applied with `CellSize = UDim2.new(1/cols, gapOffsetX, 0, maxHeight)` and `CellPadding = UDim2.new(0, gap, 0, gap)`, and each cell's `AutomaticSize` is turned off so it stays pinned at the uniform height.
- This measure/lock cycle re-runs (clearing the previously locked height) whenever the Grid's measured width, the resolved `cols`, `gap`, or the number of children changes. Width is included deliberately: cell widths are Scale-based, so even within one breakpoint a narrower container re-wraps text taller and a wider one shorter — without re-measuring on width, shrinking then widening the container would leave every cell stuck at the tallest height ever measured. It does not re-run when a child's content changes without changing the child count or the Grid's width.
- Each cell preserves its source order via an explicit `LayoutOrder` (its 0-based index among `children`).

## Composition

- `Grid` renders a transparent frame sized via `SizeHelper.GetSize(props, UDim2.fromScale(1, 1))` in width — `UDim2.fromScale(1, 1)` (filling the parent) unless `width` is set — and `AutomaticSize.Y` in height, and measures its own `AbsoluteSize.X` (like `Row`) to resolve the active breakpoint.
- Unlike `Row`/`Column`, `Grid` does not require a paired cell component — any `children` (custom components or native Roblox instances) are placed directly into cells.
