# HStack

`HStack` is a layout-only primitive: it renders a horizontal `UIListLayout` alongside its children rather than an instance of its own, so it must be rendered inside an existing `Frame`/`ScrollingFrame` (for example a [`Container`](./container.md)) to have any visible effect. It follows the shared conventions in [Components](../index.md).

## Public API

- `valign` sets the list layout's `VerticalAlignment`.
- `HorizontalFlex` sets `UIFlexAlignment` for distributing children along the main axis (e.g. `SpaceEvenly`).
- `Wraps` defaults to `true` (children wrap onto new rows on overflow) and can be disabled.
- `Padding` (a raw `UDim`) overrides the spacing derived from `spacing`.
- `Event`/`Change` are forwarded to the underlying `UIListLayout` instance.

## Layout

- Without an explicit `Padding`, spacing between children is `ceil(SpacingHelper.GetPadding(theme, spacing) / 2)` pixels — half (rounded up) of what [`VStack`](./vstack.md) uses for the same `spacing` value. This asymmetry is inherent to the current implementation; use `Padding` directly if a specific pixel gap is required regardless of axis.
