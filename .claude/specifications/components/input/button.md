# Button

`Button` is a themed, clickable `ImageButton` with an optional leading icon and label. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `ButtonProps` composes `SpacedElementProps`, `ShadowElementProps`, `ZIndexElementProps`, `BackgroundElementProps`, `IntentElementProps`, `ScalableElementProps`, and `IconElementProps`, plus `text?: string`, `fontWeight?: Enum.FontWeight`, `Event?: React.InstanceEvent<ImageButton>`, `children?: React.ReactNode`, `group?: boolean`, `disabled?: boolean`, and `styleOverride?: Partial<theme.components.button>`.
- `styleOverride` lets a caller (or a wrapping component, e.g. `Increment` sourcing it from `theme.components.increment.button`) override any subset of `theme.components.button`'s fields (`backgroundTransparency`, `cornerRadius`, `boxShadow`, `borderThickness`, `typography`, `intents`) for a single `Button` instance, without needing a global theme change. `backgroundTransparency`, `cornerRadius`, and `boxShadow` fall back independently to the normal `theme.components.button` value when `styleOverride` doesn't specify them. `typography` and `intents` layer on top of `theme.components.button`'s value instead of replacing it wholesale: `styleOverride.typography` is shallow-merged over `theme.components.button.typography`, and `styleOverride.intents` is applied as an additional highest-precedence cascade tier on top of `theme.components.button.intents` (via `ColorHelper.getIntentColors`'s cascade — see [Components](../index.md)), so a `styleOverride.intents` entry that only sets e.g. `backgroundImage.tintColor` for one intent/state inherits the rest of that intent/state's fields (`image`, `slice`, other colors) from `theme.components.button.intents` rather than losing them. `Button.Text` and `Button.Icon` also accept `styleOverride` and resolve their `typography`/`intents` from it the same way, so custom `children` built from those sub-parts stay consistent with the parent `Button`'s override.
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
- `intents` provides per-`Intent` `default`/`hover`/`disabled` background, border, and text colors. `disabled` has no theme-wide fallback (`theme.colors.intents` only defines `default`/`hover`), so it's defined directly under `theme.components.button.intents.<intent>`. Per the shared cascade in [Components](../index.md), a `disabled` entry only needs to be defined once under `theme.components.button.intents.primary` — every other intent inherits it automatically unless it defines its own `disabled` entry to override it.
- Each intent/state entry may also define `backgroundImage` (see [Components](../index.md) for how it merges across the intent/state cascade). When present, it renders on the root `imagebutton` alongside `BackgroundColor3`, resolved through the same `default`/`hover`/`disabled` state as the background color — there is no separate prop to override it, matching how `BackgroundColor3` itself is theme/intent-driven only.
- `props.BackgroundTransparency` overrides the theme's `backgroundTransparency` when supplied — this still applies even when `disabled`; `props.styleOverride?.backgroundTransparency` sits between the two, applying only when `BackgroundTransparency` is not supplied.

## Story

Worth demonstrating: each `intent`, icon-only vs. text-only vs. both, custom `children` composed from `Button.Icon`/`Button.Text`, a `disabled` example per intent showing the muted color state and inert click, a `Group` of buttons with `group` set on each to show width alignment across differing label lengths, and a `styleOverride` example (e.g. borderless/flat) to contrast against the default themed appearance.
