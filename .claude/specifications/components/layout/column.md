# Column

`Column` is a single grid cell intended to be used inside a [`Row`](./row.md); it reads `RowContext` for its sizing inputs. It follows the shared conventions in [Components](../index.md).

## Public API

- `span` accepts a `GridSpan` number (`1`–`12`), a numeric-looking string (e.g. `"6"`), or a `ResponsiveGridSpan` object keyed by breakpoint (`{ xs, sm, md, lg, xl }`).
- Without `span`, the column's width is `floor(12 / <number of Column children in the enclosing Row>)`, with the divisor floored at `1`.
- A `ResponsiveGridSpan` resolves against the row's current breakpoint via `BreakpointHelper.getValue`, falling back to the next smaller breakpoint's value if the current one is unset, and to `12` if nothing resolves at all.
- A plain numeric or numeric-string `span` is used as-is and is **not** clamped to the `1`–`12` range.

## Layout

- Width is computed as a fraction of the row (`span / 12`) minus its share of the row's inter-column spacing, so that columns summing to a full row still fit exactly alongside the padding between them: `Size = (fraction, (fraction - 1) * rowPaddingPixels, 0, 0)`.
- Height is automatic (`AutomaticSize.Y`) based on content; the frame's background is transparent.
- Because sizing inputs come from `RowContext`, a `Column` rendered outside a `Row` falls back to the context's defaults (`0` padding, `"xl"` breakpoint, `0` sibling count) rather than erroring — with no `span`, this makes an out-of-`Row` `Column` resolve to a full-width (`span: 12`) column.
