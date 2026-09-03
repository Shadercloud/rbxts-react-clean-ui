# Table

`Table` presents related values in aligned, content-sized columns using a compound-component API. It follows the shared conventions in [Components](../index.md).

## Public API

- `Table` accepts React children, the shared scalable and size element props, and an optional `name`.
- It exposes `Table.Header`, `Table.Body`, `Table.Row`, `Table.Head`, and `Table.Cell` child components.
- `Table.Head` and `Table.Cell` accept either a `text` prop or React children. `text` takes precedence when both are supplied.
- `Table.Head` and `Table.Cell` accept the full shared `PaddingProps` set and an optional horizontal `align` value.
- The table's `scale` selects cell typography and padding; a cell's own `spacing` prop takes precedence for its padding.

## Composition and layout

- `Table.Header` identifies heading rows and applies the themed header background. Its top corners match the table's themed corner radius, while its bottom corners remain square.
- `Table.Body` identifies data rows.
- `Table.Row` lays its direct `Table.Head` and `Table.Cell` children out horizontally without wrapping. Their position within the row determines their zero-based column; non-cell children do not consume a column position.
- Every column uses the largest intrinsic width reported by any heading or body cell at that position. The resulting width is shared by that column in every row, so cell boundaries and content remain aligned even when text lengths differ between rows.
- String content is rendered as a single line with the library `Text` component. Keeping intrinsic text unwrapped makes column measurement independent of the cell's provisional width and prevents measurement/layout feedback. Other React children are rendered unchanged.
- With no `width` or `Size`, the table hugs its columns horizontally, like an HTML table without an assigned width, and automatically sizes its height to its rows.
- Supplying `width` or `Size` opts into explicit sizing through the shared size-element rules. At an explicit width, each column receives the same proportion of the available width as its intrinsic width bears to the table's total intrinsic width; corresponding columns therefore stay aligned while wider-content columns retain more space.
- Intrinsic cell measurement includes resolved cell padding. Each cell reports both on mount (including a deferred post-mount read after Roblox's automatic layout has settled) and whenever its absolute size changes, so the first render does not depend on a later control or prop update to establish column widths. Widths are recalculated when mounted cell content, typography, scale, padding, or composition changes, and removed cells stop contributing to their column's maximum.
- Body rows have a top divider, including the first body row, which separates the body from the header when one is present.

## Theme

Table defaults live under `theme.components.table`:

- `backgroundColor`, `backgroundTransparency`, `borderColor`, `borderThickness`, and `cornerRadius` style the outer table.
- `rowDividerColor` and `rowDividerThickness` style separators between body rows.
- `header.backgroundColor`, `header.backgroundTransparency`, and `header.typography` style heading rows and text.
- `cell.spacing`, `cell.padding`, and `cell.typography` configure cell padding and body text. Per-cell padding props override the theme through the shared padding-resolution rules.
