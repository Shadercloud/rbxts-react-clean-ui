# Container

`Container` is a general-purpose sizing/positioning wrapper around a Roblox `Frame`. It is the base building block most other layout primitives in this category build on (`FlexItem` is a thin wrapper around it). It follows the shared conventions in [Components](../index.md).

## Public API

- Composes `SizeElementProps`, `PositionElementProps`, `ZIndexElementProps`, and `React.InstanceProps<Frame>`, so it also accepts arbitrary native `Frame` properties (`BackgroundColor3`, `BorderSizePixel`, `Event`, `Change`, etc.) alongside its own sizing/position props.
- `group` opts the container into the shared sibling-width-matching behavior described under Group sizing below.
- `BackgroundTransparency` defaults to `1` (fully transparent) when not supplied.

## Sizing

- With no `Size`, `width`, or `height` supplied, `AutomaticSize` defaults to `XY` and the container hugs its content on both axes — it does **not** fill its parent by default the way many other components do.
- Supplying only one of `width`/`height` makes the other axis automatic instead, so the specified axis is fixed and the other hugs content.
- Supplying an explicit `Size`, or both `width` and `height`, disables `AutomaticSize` entirely (`None`) unless an `AutomaticSize` prop is passed explicitly, which always wins.
- `width`/`height` accept the shared CSS-like size syntax (plain numbers, `"25px"`, `"25%"`, or `"Auto"` for `width`).

## Positioning

- `top`/`left`/`right`/`bottom` position the container relative to the corresponding parent edge; the anchor for the relevant axis is inferred to the far edge automatically when `right`/`bottom` is used instead of `left`/`top`.
- `center: true` centers the container by setting both `Position` and `AnchorPoint` to `50%`/`(0.5, 0.5)` — unless `center` is combined with fully automatic sizing (`AutomaticSize` including both axes) and no explicit `Position`/`AnchorPoint`, in which case the container instead wraps itself in an invisible, full-parent-size frame with a centered `UIListLayout`. This sidesteps Roblox's centering-vs-automatic-size interaction for content-hugging containers while still reporting the same outer `ZIndex`/`LayoutOrder`.
- Explicit `Position`/`AnchorPoint` props always take precedence over `center`.

## Composition

- Renders `props.children` through `Group.Element` (see [Group](./group.md)), gated by the `group` prop. When `group` is not set, `Group.Element` is a no-op passthrough and renders children directly.
- [`FlexItem`](./flexitem.md) composes `Container` directly, spreading all `ContainerProps` and adding a `UIFlexItem`/`UIListLayout` pair as additional children.

## Group sizing

- When `group` is `true` and an ancestor [`Group`](./group.md) is present, the container's *default* width (used only when neither `width` nor `height` is supplied) is the maximum reported width among the group's members, in pixels.
- Because the default `AutomaticSize` is `XY` whenever `width`/`height` are both omitted, this group-derived width only has a visible effect when the consumer also supplies an explicit `AutomaticSize` that excludes `X` (e.g. `"None"` or `"Y"`) — otherwise the automatically computed `X` axis overrides the pixel width entirely and the group value has no visible effect.

## Theme

Not themeable.
