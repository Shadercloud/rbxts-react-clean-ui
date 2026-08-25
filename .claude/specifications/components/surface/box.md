# Box

`Box` is a themed container surface: background, inner border, corner radius, shadow, and padding, wrapped around arbitrary children. It follows the shared conventions in [Components](../index.md).

## Public API

- `BoxProps` composes `SpacedElementProps`, `ShadowElementProps`, `BackgroundElementProps`, `ZIndexElementProps`, `SizeElementProps`, `PositionElementProps`, and `React.InstanceProps<Frame>`, plus two Box-specific fields: `'border-thickness'?: number` and `'border-color'?: Color3`.
- `Box` forwards a ref to the underlying `Frame`.

## Behavior

- Size defaults to `UDim2.fromScale(1, 1)` when none of `Size`, `width`, or `height` is supplied (via `SizeHelper.GetSize`); `AutomaticSize` is always set to `XY` regardless of the resolved base size.
- `BackgroundColor3`/`BackgroundTransparency` fall back to `theme.components.box.backgroundColor`/`backgroundTransparency` when not supplied as props.
- An inner `uistroke` always renders, using `'border-thickness'`/`'border-color'` props, falling back to `theme.components.box.borderThickness`/`borderColor`.
- A `BoxShadow` decorator applies `theme.components.box.boxShadow`; when that theme value is `undefined`, no shadow renders (the shadow prop-level overrides on `ShadowElementProps` still take precedence when supplied).
- A `Padding` decorator applies any of the standard padding props.
- A `Corners` decorator applies `theme.components.box.cornerRadius`.

## Theme

Box defaults live under `theme.components.box`: `backgroundColor`, `backgroundTransparency`, `borderColor`, `borderThickness`, `cornerRadius`, and optional `boxShadow`. The theme shape also declares an `intents` field (per-intent color schemes), but `Box` itself never reads it — no intent resolution happens inside `Box`; components built on top of `Box` (e.g. `Card`, `Toast`) apply their own intent colors as explicit `BackgroundColor3`/`border-color` overrides instead. Treat `theme.components.box.intents` as currently unused by `Box`.
