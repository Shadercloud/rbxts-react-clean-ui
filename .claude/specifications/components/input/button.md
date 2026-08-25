# Button

`Button` is a themed, clickable `ImageButton` with an optional leading icon and label. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `ButtonProps` composes `SpacedElementProps`, `ShadowElementProps`, `ZIndexElementProps`, `BackgroundElementProps`, `IntentElementProps`, `ScalableElementProps`, and `IconElementProps`, plus `text?: string`, `fontWeight?: Enum.FontWeight`, `Event?: React.InstanceEvent<ImageButton>`, `children?: React.ReactNode`, `group?: boolean`, and `disabled?: boolean`.
- `fontWeight` is accepted as a prop but is not applied anywhere in the implementation — the label always renders with the theme's configured weight.
- `Button.Text` and `Button.Icon` are exposed so custom `children` can render a label or icon that still resolves its color from the button's `intent` and theme. Both accept `intent` and `scale` independently of the parent `Button`, plus `disabled` to resolve the same disabled color state as the parent.
- When neither `icon` nor `text` nor `children` is supplied, the button renders with no content.
- When both `icon`/`text` and `children` are supplied, the automatic icon/label row renders first, followed by `children`.

## Behavior

- The button always uses `AutomaticSize.XY`, growing to fit its content.
- Hovering is tracked locally with `MouseEnter`/`MouseLeave` on the root `imagebutton` (this component does not use the `HoverButton` primitive used elsewhere in the library). Hover changes the background and border color to the intent's `hover` state; it does **not** change the label or icon color, which is always resolved for the `default`/`disabled` state (never `hover`).
- Passing `Event` merges with the component's own `MouseEnter`/`MouseLeave`/`Activated` handlers; both the caller's and the internal handlers run (except while `disabled`, see below).

## Disabled state

- `disabled` is `false`/`undefined` by default. When `true`:
  - The root `imagebutton`'s `Active` is set to `false`.
  - `Event.Activated` is intercepted: the caller's `props.Event?.Activated` is not invoked, so clicks are inert regardless of what the caller passed.
  - `MouseEnter`/`MouseLeave` no longer toggle the internal hover flag, so a disabled button never shows the `hover` color even while the pointer is over it. The caller's own `MouseEnter`/`MouseLeave` handlers (if any) still fire.
  - The internal hover flag is also reset to `false` as soon as `disabled` becomes `true` (independent of `MouseLeave`, which `Active={false}` suppresses from firing). This guarantees that when the button later becomes enabled again, it never shows a stale `hover` color left over from before it was disabled — it only shows `hover` again after a genuine subsequent `MouseEnter`.
  - Background, border, `Button.Icon`, and `Button.Text` colors all resolve via `ColorHelper.getIntentColors(theme, props.intent, "disabled", theme.components.button.intents)` instead of `"default"`/`"hover"`.
- `disabled` does not affect layout, sizing, or whether `icon`/`text`/`children` render — only interactivity and color.

## Grouped buttons

- When `group` is `true` and a `Group` ancestor provides `GroupContext`, the button wraps its icon/text/children in `Group.Element`, which reports its rendered size (content plus resolved padding) into the group.
- The button's `Size` is then set to `UDim2.fromOffset(group.size.X, 0)` with `AutomaticSize.XY`, so its width is pinned to the widest reporting element in the group while its height still grows automatically.
- Without `group`, or without a `Group` ancestor, sizing is purely automatic in both axes.

## Theme

Button defaults live under `theme.components.button`:

- `backgroundTransparency`, `cornerRadius`, `boxShadow`, and `borderThickness` style the button surface. The border stroke uses `Enum.BorderStrokePosition.Inner`.
- `typography` resolves the label's font via `TypographyHelper.getTypography(theme, props.scale, theme.components.button.typography)`.
- `intents` provides per-`Intent` `default`/`hover`/`disabled` background, border, and text colors. `disabled` has no theme-wide fallback (`theme.colors.intents` only defines `default`/`hover`), so each intent's `disabled` entry is defined directly under `theme.components.button.intents.<intent>`.
- `props.BackgroundTransparency` overrides the theme's `backgroundTransparency` when supplied — this still applies even when `disabled`.

## Story

Worth demonstrating: each `intent`, icon-only vs. text-only vs. both, custom `children` composed from `Button.Icon`/`Button.Text`, a `disabled` example per intent showing the muted color state and inert click, and a `Group` of buttons with `group` set on each to show width alignment across differing label lengths.
