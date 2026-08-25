# Button

`Button` is a themed, clickable `ImageButton` with an optional leading icon and label. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `ButtonProps` composes `SpacedElementProps`, `ShadowElementProps`, `ZIndexElementProps`, `BackgroundElementProps`, `IntentElementProps`, `ScalableElementProps`, and `IconElementProps`, plus `text?: string`, `fontWeight?: Enum.FontWeight`, `Event?: React.InstanceEvent<ImageButton>`, `children?: React.ReactNode`, and `group?: boolean`.
- `fontWeight` is accepted as a prop but is not applied anywhere in the implementation — the label always renders with the theme's configured weight.
- `Button.Text` and `Button.Icon` are exposed so custom `children` can render a label or icon that still resolves its color from the button's `intent` and theme. Both accept `intent` and `scale` independently of the parent `Button`.
- When neither `icon` nor `text` nor `children` is supplied, the button renders with no content.
- When both `icon`/`text` and `children` are supplied, the automatic icon/label row renders first, followed by `children`.

## Behavior

- The button always uses `AutomaticSize.XY`, growing to fit its content.
- Hovering is tracked locally with `MouseEnter`/`MouseLeave` on the root `imagebutton` (this component does not use the `HoverButton` primitive used elsewhere in the library). Hover changes the background and border color to the intent's `hover` state; it does **not** change the label or icon color, which is always resolved for the `default` state.
- `Button.Icon` and `Button.Text` always resolve their color from the `default` intent state, regardless of the parent button's hover state.
- Passing `Event` merges with the component's own `MouseEnter`/`MouseLeave` handlers; both the caller's and the internal handlers run.

## Grouped buttons

- When `group` is `true` and a `Group` ancestor provides `GroupContext`, the button wraps its icon/text/children in `Group.Element`, which reports its rendered size (content plus resolved padding) into the group.
- The button's `Size` is then set to `UDim2.fromOffset(group.size.X, 0)` with `AutomaticSize.XY`, so its width is pinned to the widest reporting element in the group while its height still grows automatically.
- Without `group`, or without a `Group` ancestor, sizing is purely automatic in both axes.

## Theme

Button defaults live under `theme.components.button`:

- `backgroundTransparency`, `cornerRadius`, `boxShadow`, and `borderThickness` style the button surface. The border stroke uses `Enum.BorderStrokePosition.Inner`.
- `typography` resolves the label's font via `TypographyHelper.getTypography(theme, props.scale, theme.components.button.typography)`.
- `intents` provides per-`Intent` `default`/`hover` background, border, and text colors.
- `props.BackgroundTransparency` overrides the theme's `backgroundTransparency` when supplied.

## Story

Worth demonstrating: each `intent`, icon-only vs. text-only vs. both, custom `children` composed from `Button.Icon`/`Button.Text`, and a `Group` of buttons with `group` set on each to show width alignment across differing label lengths.
