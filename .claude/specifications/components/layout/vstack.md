# VStack

`VStack` is `HStack`'s vertical counterpart: a layout-only primitive that renders a vertical `UIListLayout` alongside its children, with no instance of its own. It follows the shared conventions in [Components](../index.md).

## Public API

- `valign` and `VerticalAlignment` both set `UIListLayout.VerticalAlignment`; `VerticalAlignment` takes precedence when both are supplied.
- `HorizontalFlex` defaults to `Enum.UIFlexAlignment.Fill` (children stretch to the full available width unless a child overrides it); `VerticalFlex` has no default.
- `Padding` (a raw `UDim`) overrides the spacing derived from `spacing`.
- Children are sorted by `LayoutOrder` (`SortOrder.LayoutOrder`).
- `Event`/`Change` are forwarded to the underlying `UIListLayout` instance.

## Layout

- Without an explicit `Padding`, spacing between children is `SpacingHelper.GetPadding(theme, spacing)` pixels — the full value, unlike [`HStack`](./hstack.md)'s halved value for the same `spacing`.
