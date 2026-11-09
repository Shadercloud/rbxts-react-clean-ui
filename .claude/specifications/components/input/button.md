# Button

`Button` is a themed, clickable `ImageButton` with an optional leading icon and label. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `ButtonProps` composes `SpacedElementProps`, `ShadowElementProps`, `ZIndexElementProps`, `BackgroundElementProps`, `IntentElementProps`, `ScalableElementProps`, `IconElementProps`, and `Pick<SizeElementProps, "width">`, plus `text?: string`, `fontWeight?: Enum.FontWeight`, `Event?: React.InstanceEvent<ImageButton>`, `children?: React.ReactNode`, `group?: boolean`, `disabled?: boolean`, `spinning?: boolean`, `LayoutOrder?: number`, `name?: string`, `padding?: CssPadding`, `modal?: boolean`, `fill?: boolean`, `pressOn?: "down" | "up"`, `onRelease?: (button: ImageButton, input: InputObject) => void`, and `styleOverride?: Partial<theme.components.button>`. `width`/`fill` are covered under [Sizing](#sizing), `pressOn`/`onRelease` under [Press-down activation](#press-down-activation).
- `modal` (default `false`) sets the root `imagebutton`'s native `GuiButton.Modal`: while the button is visible, the mouse is freed from first-person/shift-lock. It is unrelated to the library's `Modal` component/provider, and is independent of `disabled` (a disabled modal button still frees the mouse).
- `styleOverride` lets a caller (or a wrapping component, e.g. `Increment` sourcing it from `theme.components.increment.button`) override any subset of `theme.components.button`'s fields (`backgroundTransparency`, `cornerRadius`, `boxShadow`, `borderThickness`, `typography`, `intents`) for a single `Button` instance, without needing a global theme change. `backgroundTransparency`, `cornerRadius`, and `boxShadow` fall back independently to the normal `theme.components.button` value when `styleOverride` doesn't specify them. `typography` and `intents` layer on top of `theme.components.button`'s value instead of replacing it wholesale: `styleOverride.typography` is shallow-merged over `theme.components.button.typography`, and `styleOverride.intents` is applied as an additional highest-precedence cascade tier on top of `theme.components.button.intents` (via `ColorHelper.getIntentColors`'s cascade — see [Components](../index.md)), so a `styleOverride.intents` entry that only sets e.g. `backgroundImage.tintColor` for one intent/state inherits the rest of that intent/state's fields (`image`, `slice`, other colors) from `theme.components.button.intents` rather than losing them. `Button.Text` and `Button.Icon` also accept `styleOverride` and resolve their `typography`/`intents` from it the same way, so custom `children` built from those sub-parts stay consistent with the parent `Button`'s override.
- `fontWeight` is accepted as a prop but is not applied anywhere in the implementation — the label always renders with the theme's configured weight.
- `Button.Text` and `Button.Icon` are exposed so custom `children` can render a label or icon that still resolves its color from the button's `intent` and theme. Both accept `intent` and `scale` independently of the parent `Button`, plus `disabled` to resolve the same disabled color state as the parent.
- `spinning` (default `false`) makes the automatic leading icon rotate continuously, using `Icon`'s own `spinning` behaviour at its default speed (see [Icon](../surface/icon.md)). It has no effect when `icon` is not supplied, and does not touch the label, `children`, or any `Button.Icon` placed in `children` (those take their own `spinning`). It is independent of `disabled`: a disabled button still spins if asked.
- Padding resolves per the shared [padding resolution](../index.md#padding-resolution) with no component tiers (`theme.components.button` has no `spacing`/`padding`): `padding` (a CSS quad, e.g. `"4 12"`) overrides the per-side value derived from `spacing`, which otherwise resolves against `theme.spacing` at `spacing ?? theme.default.spacing` (`"None"` = 0). The result is applied to the root's `UIPadding` and also passed to `Group.Element`, so a grouped button reports its padded size. Without `padding`, rendering is unchanged.
- When neither `icon` nor `text` nor `children` is supplied, the button renders with no content.
- When both `icon`/`text` and `children` are supplied, the automatic icon/label row renders first, followed by `children`.

## Sizing

- Without `width` or `fill` the button uses `AutomaticSize.XY`, growing to fit its content (see [Grouped buttons](#grouped-buttons) for `group`).
- `width` (any `Container`-style width: px number, `"25px"`, `"50%"`, a breakpoint table resolved at `sm`, or `"Auto"`) sets the root's X size and switches `AutomaticSize` to `Y`, so the height still hugs the content. `"Auto"` keeps `AutomaticSize.XY`. `width` wins over `group`'s pinned width.
- `fill: true` adds a `UIFlexItem` named `FlexItem` with `FlexMode = Fill` to the root, so the button grows (and may shrink) along its parent `UIListLayout`'s fill direction to take the free space. Without `width`, the base width drops to `0` (`AutomaticSize.Y`), so several `fill` buttons in one row share it equally regardless of label length (the same model as `Tabs.List fill`); with `width`, that width is the base the flex grows from. With `group` and no `width`, the group's pinned width is the base.
- `fill` only does anything when the button is a direct child of a frame with a `UIListLayout` (`HStack`, `Row`, `VStack`, ...). Elsewhere a `fill` button without `width` collapses to its padding width.
- When `width` or `fill` is set, the icon/label row is centred horizontally (`HorizontalAlignment = Center`) inside the wider button. Otherwise alignment is unchanged.
- The automatic row never wraps, so a `fill`/`width` button narrower than its content overflows rather than wrapping.

## Press-down activation

- `pressOn` (default `"up"`) chooses when a mouse/touch press activates the button. `"up"` = the native `Activated` at release, as before.
- `pressOn="down"`: a `MouseButton1` or `Touch` `InputBegan` on the button calls the caller's `Event.Activated(button, input, 1)` immediately, and the later native `Activated` for that same mouse/touch press is swallowed, so each press fires exactly once. The caller's own `Event.InputBegan`, if any, still runs first. Other activation sources (gamepad `ButtonA` / keyboard on a selected button, which arrive through the native `Activated` with a non-pointer `UserInputType`) pass through unchanged, at the engine's normal time.
- `disabled` blocks press-down activation the same way it blocks `Activated`.
- `onRelease` is only used with `pressOn="down"`. It fires once per press-down activation, when that mouse/touch input ends or is cancelled, wherever the pointer is at that point (dragging off the button still releases). A press that began while enabled still gets its `onRelease` if the button is disabled mid-hold. Each touch is tracked separately, so two fingers on one button give two activations and two releases. Gamepad/keyboard activations never get an `onRelease`. Presses still held when the button unmounts are dropped without calling `onRelease`.
- Hover, `MouseEnter`/`MouseLeave` and the disabled hover reset are unchanged in both modes.

## Behavior

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
- Unless `width`/`fill` is set, the button's `Size` is then set to `UDim2.fromOffset(group.size.X, 0)` with `AutomaticSize.XY`, so its width is pinned to the widest reporting element in the group while its height still grows automatically.
- Without `group`, or without a `Group` ancestor, sizing is purely automatic in both axes.

## Theme

Button defaults live under `theme.components.button`:

- `backgroundTransparency`, `cornerRadius`, `boxShadow`, and `borderThickness` style the button surface. The border stroke uses `Enum.BorderStrokePosition.Inner`.
- `typography` resolves the label's font via `TypographyHelper.getTypography(theme, props.scale, theme.components.button.typography)`.
- `intents` provides per-`Intent` `default`/`hover`/`disabled` background, border, and text colors. `disabled` has no theme-wide fallback (`theme.colors.intents` only defines `default`/`hover`), so it's defined directly under `theme.components.button.intents.<intent>`. Per the shared cascade in [Components](../index.md), a `disabled` entry only needs to be defined once under `theme.components.button.intents.primary` — every other intent inherits it automatically unless it defines its own `disabled` entry to override it.
- Each intent/state entry may also define `backgroundImage` (see [Components](../index.md) for how it merges across the intent/state cascade). When present, it renders on the root `imagebutton` alongside `BackgroundColor3`, resolved through the same `default`/`hover`/`disabled` state as the background color — there is no separate prop to override it, matching how `BackgroundColor3` itself is theme/intent-driven only.
- Each intent/state entry may likewise define `backgroundGradient` (merged across the intent/state cascade the same way — see [Components](../index.md)). When present, it renders alongside `backgroundImage`/`BackgroundColor3` on the root `imagebutton` via the `Gradient` decorator (see [Box](../surface/box.md#backgroundgradient)), resolved through the same `default`/`hover`/`disabled` state cascade. There is no separate prop to override it either.
- `props.BackgroundTransparency` overrides the theme's `backgroundTransparency` when supplied — this still applies even when `disabled`; `props.styleOverride?.backgroundTransparency` sits between the two, applying only when `BackgroundTransparency` is not supplied.
- Below those two, a **non-primary** intent can set its own surface transparency: the `backgroundTransparency` of that intent's own entry for the current state, falling back to its own `default` entry (checked in `styleOverride.intents` first, then `theme.components.button.intents`), is used before `theme.components.button.backgroundTransparency`. It is read from that intent's entry only, never inherited from `primary`. For `primary` (and an unset `intent`) the component-level `backgroundTransparency` always applies, as before.
- Stroke `Thickness` resolves as the merged intent/state `borderThickness` (optional `IntentScheme` field) `?? styleOverride.borderThickness ?? theme.components.button.borderThickness`. No shipped theme sets the intent field on `primary`, so thicknesses are unchanged.
- `intent="secondary"`: see [Components](../index.md) for the fallback to `primary`. Defaults: Default theme = neutral grey (`#E4E7EC` fill, `#C5CAD3` border, `#1D2433` text; hover `#D5D9E0`/`#B8BEC9`). `WoodenTheme` = vertical gradient `#7A4A20` → `#5C3A18` (hover `#8A5A28` → `#6B4520`) on a white, opaque background, image cleared (`image: ""`), text `#D3CBA3`, 3px `#3D2712` stroke. Dark and Sandstone have their own muted secondary entries.

## Story

Also show `intent="secondary"` next to `primary`.

Worth demonstrating: a row of `fill` buttons sharing the width equally, a fixed-`width` button, a `pressOn="down"` hold button whose label shows held/released via `onRelease`, each `intent`, icon-only vs. text-only vs. both, custom `children` composed from `Button.Icon`/`Button.Text`, a `disabled` example per intent showing the muted color state and inert click, a `Group` of buttons with `group` set on each to show width alignment across differing label lengths, and a `styleOverride` example (e.g. borderless/flat) to contrast against the default themed appearance.

## Implementation notes

- The root's `UIPadding` comes from `<Padding {...props} />`, so it is keyed by `props.name ?? "Padding"` — a `Button` with `name` set gets a `UIPadding` with that same name. `padding` was already honoured at runtime through this spread before it was typed; typing it did not change the render path.
- The per-intent transparency skips `primary` on purpose. `DefaultTheme`'s `button.intents.primary.disabled.backgroundTransparency: 0.35` has never been applied, and honouring it would change the default disabled look. It is read from the intent's own entry rather than the merged scheme for the same reason: merging would pull that `primary` value into every other intent.
- `spinning` needs no extra `Container` around the icon in the `HStack`. With `spinning`, `Icon` renders a non-rotating auto-sized `Frame` (named `ButtonIcon`) as the list child, and the rotating `ImageLabel` (named `Icon`) sits inside it. The list layout never sees the rotated instance. Don't add another wrapper, and don't pass `Rotation` straight to `ButtonIcon` in the row.
- `Button.Icon` forwards `LayoutOrder` to `Icon` (the automatic icon passes `1`, the label `2`). With `spinning`, `Icon` puts `LayoutOrder` on its outer `Frame` (the list child), so the order holds either way.
- `modal` is passed as `props.modal ?? false` rather than raw, so toggling it from `true` back to unset explicitly writes `false` instead of leaving the native `Modal` stuck on.
- Toggling `spinning` switches `Icon` between an `ImageLabel` and a `Frame`, so the icon instance remounts rather than updating in place.
- `pressOn="down"` and `onRelease` live in `Button.press.ts` (`isPointerPress`, `usePressRelease`), shared with `HoverButton`. The release is detected from the pressed `InputObject`'s own `UserInputState` changing to `End`/`Cancel`, not from the button's `InputEnded`: a `GuiObject`'s `InputEnded` isn't reliable when the pointer is released off the button, which would leave a hold-to-sprint stuck on.
- The press-down `InputBegan` handler is only added to `Event` when `pressOn === "down"`, so the default event table (and any caller `InputBegan`) is exactly what it was. Don't fire the caller's handler on press-down *and* on `Activated`: the `isPointerPress` check in `Activated` is what prevents a double fire.
- `fill` uses a zero base width for the same reason as `Tabs.List fill`: flex only shares out free space, so content-sized buttons would keep unequal widths.
