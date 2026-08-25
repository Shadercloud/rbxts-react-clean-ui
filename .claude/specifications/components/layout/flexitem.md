# FlexItem

`FlexItem` is a [`Container`](./container.md) that additionally participates in a parent's `UIListLayout` as a flexible item and lays out its own children horizontally. It follows the shared conventions in [Components](../index.md).

## Public API

- Extends `ContainerProps` (all of `Container`'s sizing/position/z-index/group props) plus `children`.
- `mode` sets `UIFlexItem.FlexMode` and defaults to `"Grow"` (also accepts `"None"`, `"Shrink"`, `"Fill"`, `"Custom"`).
- `GrowRatio`/`ShrinkRatio` map directly to `UIFlexItem.GrowRatio`/`ShrinkRatio`.
- `align` sets the `HorizontalAlignment` of `FlexItem`'s own internal horizontal `UIListLayout`, controlling how *its* children are aligned within it.

## Composition

- Renders a `UIFlexItem` and a horizontal `UIListLayout` as additional children passed into the underlying `Container`, alongside `props.children`.
- The `UIFlexItem` only affects layout when `FlexItem` is placed as a direct child of a frame governed by a `UIListLayout` — i.e. inside another layout primitive such as [`Row`](./row.md), [`HStack`](./hstack.md), or [`VStack`](./vstack.md) (or a raw frame with its own `uilistlayout`). Used outside such a parent, `mode`/`GrowRatio`/`ShrinkRatio` have no visible effect.
- `group: true` (inherited from `ContainerProps`) behaves as documented under [Container's group sizing](./container.md#group-sizing) — with one caveat: `Container` wraps `props.children` in `Group.Element` when `group` is enabled, and for `FlexItem` those children include the `UIFlexItem` and internal `UIListLayout` themselves. Enabling `group` therefore moves those layout objects onto the inner measurement frame created by `Group.Element` instead of leaving them on the outer frame that actually participates in the parent's layout, so `mode`/`GrowRatio`/`ShrinkRatio` most likely stop applying to the right instance in this combination.
