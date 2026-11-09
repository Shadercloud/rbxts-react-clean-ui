# FlexItem

`FlexItem` is a [`Container`](./container.md) that additionally participates in a parent's `UIListLayout` as a flexible item and, by default, lays out its own children horizontally. It follows the shared conventions in [Components](../index.md).

## Public API

- Extends `ContainerProps` (all of `Container`'s sizing/position/z-index/group props) plus `children`.
- `mode` sets `UIFlexItem.FlexMode` and defaults to `"Grow"` (also accepts `"None"`, `"Shrink"`, `"Fill"`, `"Custom"`).
- `GrowRatio`/`ShrinkRatio`/`ItemLineAlignment` map directly to the same `UIFlexItem` properties (`ItemLineAlignment` = this item's cross-axis alignment within its parent's flex line; unset = the parent layout's).
- `align` sets the `HorizontalAlignment` of `FlexItem`'s own internal `UIListLayout`, controlling how *its* children are aligned within it. `HorizontalFlex` sets that layout's `HorizontalFlex`.
- `direction?: "horizontal" | "vertical"` sets the internal layout's `FillDirection`. Unset = `"horizontal"`, as before. `"vertical"` stacks the children top-to-bottom with the same `align`/`HorizontalFlex` and no padding (it is not a `VStack`: no default `HorizontalFlex = Fill`, no theme gap).
- `layout?: boolean` — `false` renders no internal `UIListLayout` at all, so the children can bring their own (e.g. a `VStack` or `HStack` with its gap/flex settings). `align`, `HorizontalFlex` and `direction` then have no effect. Unset/`true` = the internal layout is rendered, as before.

## Composition

- Renders a `UIFlexItem` (`FlexItemConstraint`) and, unless `layout={false}`, a `UIListLayout` (`FlexItemLayout`) as additional children passed into the underlying `Container`, alongside `props.children`.
- The `UIFlexItem` only affects layout when `FlexItem` is placed as a direct child of a frame governed by a `UIListLayout` — i.e. inside another layout primitive such as [`Row`](./row.md), [`HStack`](./hstack.md), or [`VStack`](./vstack.md) (or a raw frame with its own `uilistlayout`). Used outside such a parent, `mode`/`GrowRatio`/`ShrinkRatio` have no visible effect.
- `group: true` (inherited from `ContainerProps`) behaves as documented under [Container's group sizing](./container.md#group-sizing) — with one caveat: `Container` wraps `props.children` in `Group.Element` when `group` is enabled, and for `FlexItem` those children include the `UIFlexItem` and internal `UIListLayout` themselves. Enabling `group` therefore moves those layout objects onto the inner measurement frame created by `Group.Element` instead of leaving them on the outer frame that actually participates in the parent's layout, so `mode`/`GrowRatio`/`ShrinkRatio` most likely stop applying to the right instance in this combination.
- A filling column holding a vertical stack is `<FlexItem layout={false}><VStack>...</VStack></FlexItem>` (or `direction="vertical"` when no gap is needed).

## Implementation notes

- A frame with two `UIListLayout`s lays out unpredictably (only one wins), so a `FlexItem` holding a `VStack`/`HStack` needs `layout={false}`. Keep the `FlexItemLayout` gated on `layout !== false` rather than trying to merge it with a child stack's layout.
