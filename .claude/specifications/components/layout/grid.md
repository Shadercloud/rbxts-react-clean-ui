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

- Column width is deterministic from `cols` and `gap`: `CellSize.X.Scale = 1 / cols`, `CellSize.X.Offset = floor(-gap * (cols - 1) / cols)`, so `cols` cells plus `cols - 1` gaps of `gap` pixels fill one row without ever exceeding it.
- Row height is uniform across every cell in the grid, sized to the tallest child's natural (wrapped) height. Because a `UIGridLayout` forces a child's `Size` to `CellSize` the instant it's applied — a child never gets to report its own natural size once inside the grid — this requires two passes:
  1. **Measure**: each child is wrapped in an internal cell frame sized to the target column width (`CellSize.X` above) with `AutomaticSize.Y` and no `UIGridLayout` yet (cells are instead laid out with a horizontal, wrapping `UIListLayout` using the same per-cell width and `gap` padding, purely so cells don't overlap while their natural height is being read via `AbsoluteSize`).
  2. **Lock**: once every cell has reported a height, `Grid` waits two further engine frames with no additional report coming in before treating the measurement as settled. Nested `AutomaticSize` content (e.g. a child wrapping a child) can take more than one frame to reach its final height, and any report that arrives during that wait restarts it. Once settled, the tallest reported value becomes the row height. A `UIGridLayout` is then applied with `CellSize = UDim2.new(1/cols, gapOffsetX, 0, maxHeight)` and `CellPadding = UDim2.new(0, gap, 0, gap)`, and each cell's `AutomaticSize` is turned off so it stays pinned at the uniform height.
- This measure/lock cycle re-runs (clearing the previously locked height) whenever the Grid's measured width, the resolved `cols`, `gap`, or the number of children changes. Width is included deliberately: cell widths are Scale-based, so even within one breakpoint a narrower container re-wraps text taller and a wider one shorter — without re-measuring on width, shrinking then widening the container would leave every cell stuck at the tallest height ever measured. It does not re-run when a child's content changes without changing the child count or the Grid's width.
- Each cell preserves its source order via an explicit `LayoutOrder` (its 0-based index among `children`).

## Composition

- `Grid` renders a transparent frame sized via `SizeHelper.GetSize(props, UDim2.fromScale(1, 1))` in width — `UDim2.fromScale(1, 1)` (filling the parent) unless `width` is set — and `AutomaticSize.Y` in height, and measures its own `AbsoluteSize.X` (like `Row`) to resolve the active breakpoint.
- Unlike `Row`/`Column`, `Grid` does not require a paired cell component — any `children` (custom components or native Roblox instances) are placed directly into cells.

## Implementation notes

- `cellWidthOffset` is floored because an exact fractional offset (e.g. gap 8, cols 5 gives -6.4) rounds up on some cells. The row then overflows by a pixel or two and `UIGridLayout` wraps the last cell early, ignoring `FillDirectionMaxCells`.
- `measureKey` (`width:cols:gap:childCount`) tags both the collected `heights` and the `lock`. `locked` is derived by comparing the lock's key with the current `measureKey`, so an input change unlocks in the same render. Stale reports are dropped by comparing keys, with no separate "reset" effect. Don't reintroduce a reset effect: a parent reset and a cell report writing the same state from different effects in the same commit raced, and the reset sometimes wiped out a report that had already landed.
- Including `width` in `measureKey` can't feed back into itself, because unlocking changes the root's height, not its width.
- There's no reliable signal that nested `AutomaticSize` content has finished settling (a poll that reads a stale value looks the same as a settled one). So `GridCell` re-reports every frame for a fixed `SETTLE_POLL_FRAMES` window after each measure pass, plus a live `AbsoluteSize` `Change` binding for later resizes. It doesn't try to detect when things stop changing.
- `reportHeight` must always return a new `{ key, values }` object, even when the height hasn't changed. Each poll then resets the settle effect's `heights` dependency, which makes the effect wait out the whole poll window instead of locking onto a value that just hasn't updated yet.
- The settle effect waits with `task.wait()` twice inside `task.spawn`, not `task.defer`. Text wrapping needs a real engine layout pass, and spawning keeps the effect body from yielding. The effect's cleanup cancels a pending attempt.
- Cell `LayoutOrder` comes from a local 0-based counter, not the `React.Children.map` index. The Luau React port passes a 1-based index there.
