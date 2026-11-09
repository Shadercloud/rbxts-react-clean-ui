# FadeGroup

`FadeGroup` is a sizing/positioning wrapper, like [`Container`](./container.md), whose root is a Roblox `CanvasGroup`. You can fade or tint the whole subtree through one value instead of changing every descendant's own transparency. For example, it can dim an inventory slot, fade a panel in or out, or grey out a disabled section. It follows the shared conventions in [Components](../index.md).

## Public API

- `FadeGroupProps` combines `SizeElementProps`, `PositionElementProps`, `ZIndexElementProps` and `React.InstanceProps<CanvasGroup>`, plus `name?: string`. `name` sets the instance name and defaults to `"FadeGroup"`.
- `GroupTransparency` (`number | Binding<number>`, default `0`): fades the root and all of its descendants together. `0` means fully visible and `1` means fully invisible. Pass a binding (for example from `useTween`) to animate the fade.
- `GroupColor3` (`Color3 | Binding<Color3>`, default is the native white, meaning no tint): multiplies the colour of the whole rendered subtree.
- It forwards common native `GuiObject` props: `LayoutOrder`, `Visible`, `ClipsDescendants`, `Rotation`, `Active`, `Interactable`, `Selectable` and the selection props, `SizeConstraint`, `BackgroundColor3`, `BorderColor3`/`BorderMode`, `Tag`, `Event` and `Change`.
- `ref` forwards to the root `CanvasGroup`.
- Children render as direct children of the `CanvasGroup`, with no wrapper frame in between. A `UIListLayout`, `UIPadding`, `UICorner` and similar objects passed as children apply to the `CanvasGroup` itself.

## Sizing and positioning

- The sizing and positioning rules are the same as [Container's](./container.md#sizing). With no `Size`, `width` or `height`, `AutomaticSize` is `XY` and the group fits its content. `width`, `height`, `top`, `left`, `right`, `bottom` and `center` resolve the same way they do in `Container`. An explicit `Size`, `Position`, `AnchorPoint` or `AutomaticSize` always wins.
- `minWidth`/`maxWidth`/`minHeight`/`maxHeight` follow [Min and max size](../index.md#min-and-max-size); the `UISizeConstraint` is a direct child of the `CanvasGroup`.
- `center` sets `Position` to 50% and `AnchorPoint` to `(0.5, 0.5)` directly. Unlike `Container`, it never adds the centring wrapper frame for automatically sized content.
- `BackgroundTransparency` defaults to `1` and `BorderSizePixel` defaults to `0`. With no background props set, the group itself is invisible and only its children show.

## Theme

Not themeable. Neither transparency nor colour has a sensible theme-wide default. The expected value is a fully visible, untinted group, which is the native default.

## Story / Loom

- Story: an inventory-slot-style `Box` with an icon and text inside a `FadeGroup`. A slider or toggle should drive `GroupTransparency`, and it should also show a `GroupColor3` tint, such as a grey "disabled" look.
- Loom: one `FadeGroup` holding a small card, shown partly faded.

## Implementation notes

- **Why a separate component, not a Box/Container prop.** `Container` always renders an `ImageLabel` root, and many component refs are typed against it. Switching the root to `CanvasGroup` only when a prop is set would change the ref type and swap the underlying instance when that prop is toggled at runtime. A `CanvasGroup` also renders its children into a texture, so a conditional switch would silently change how every existing `Box`/`Container` renders. A dedicated component keeps both of them unchanged.
- **The name `FadeGroup`, not `CanvasGroup`.** `CanvasGroup` is already the global Roblox instance type used in `React.forwardRef<CanvasGroup, ...>`. Exporting a component with the same name would shadow that type for consumers.
- **Native props are listed one by one instead of spread.** The props object also carries the library's own keys (`width`, `height`, `center`, `top`, `name`, and so on). Spreading those onto the `canvasgroup` host element would try to set properties that don't exist on the instance. This is the same approach `Container` uses.
- **CanvasGroup limits apply.** The subtree is drawn to an offscreen texture, so it is limited by texture memory and resolution. Very large groups can look blurry on low-memory devices. Descendants' `UIStroke` and shadows that extend past the group's bounds are clipped to it. Use `FadeGroup` where a whole-subtree fade is needed, not as a general-purpose container.
