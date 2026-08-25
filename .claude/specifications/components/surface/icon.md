# Icon

`Icon` displays a theme-resolved icon image, with optional fixed rotation or continuous spinning. It follows the shared conventions in [Components](../index.md).

## Public API

- `IconProps extends IconElementProps, ScalableElementProps, React.InstanceProps<ImageLabel>`, plus `color?: Color3`, `Size?: UDim2`, `spinning?: boolean`, `speed?: number`, and `Rotation?: number | Binding<number>`.
- Nearly all native `ImageLabel` properties are forwarded individually (not via a raw spread), including `Change` and `Event`; `Image` and `ImageColor3` are always computed internally and cannot be overridden directly.

## Resolution

- `icon` is resolved as `theme.icons[props.icon] ?? DefaultIconSet[props.icon]` — a theme only needs to override the specific icons it wants to replace. When `icon` is `undefined`, `Image` is `undefined`.
- Size is `props.Size` when supplied; otherwise `theme.iconSize[props.scale ?? theme.default.scale]` (a square `UDim2.fromOffset`).
- `ImageColor3` is `props.color`, falling back to `theme.colors.intents.primary.default.textColor` (not a hard-coded white — it happens to be white only if the active theme's primary text color is white).

## Spinning

- When `spinning` is true, `Icon` renders a `SpinningIcon` wrapper instead: an invisible auto-sized `frame` containing the same `Icon` element with `Rotation` bound to an infinitely-repeating linear tween from `0` to `360` degrees over `speed` seconds (default `1`).
- All props, including native `ImageLabel` props, are forwarded through to the inner `Icon` when spinning.
- The tween's `setGoal(360)`/`start()` call runs in an effect with no dependency array, so it re-runs on every render of `SpinningIcon`, not only on mount — this is a real implementation detail to preserve (or flag) rather than an assumed one-time setup.
- An explicit `Rotation` prop is not meaningful together with `spinning` — the spinning wrapper's own tweened rotation binding takes over the `Rotation` value regardless of any `Rotation` passed in.

## Theme

- `theme.icons` — a partial override map of icon name to asset id.
- `theme.iconSize` — a `ScaleSizeValue<number>` used to size icons by `scale`.
- `theme.colors.intents.primary.default.textColor` — the default tint when `color` is not supplied.
