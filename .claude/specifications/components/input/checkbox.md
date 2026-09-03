# Checkbox

`Checkbox` is a clickable `ImageButton` that toggles a boolean value and displays a state-dependent icon. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `CheckboxProps` composes `IntentElementProps`, `PaddingProps`, `BackgroundElementProps`, `SpacedElementProps`, and `ScalableElementProps`, plus `checked?: boolean`, `onChange?: (value: boolean) => void`, `'icon-checked'?: IconName`, `'icon-unchecked'?: IconName`, `'intent-checked'?: Intent`, and `'intent-unchecked'?: Intent`.
- `checked` only seeds the component's internal state on mount (`React.useState(props.checked ?? false)`); changing the `checked` prop after the initial render has no further effect. The component is uncontrolled from that point on.
- `'icon-checked'` defaults to `"check"`. `'icon-unchecked'` has no default — when omitted, the unchecked state renders no icon.
- `'intent-checked'` defaults to `"success"`; `'intent-unchecked'` defaults to `"primary"`.

## Behavior

- Activating the checkbox toggles its internal checked state.
- Per the [Input](./index.md) fieldset convention, activating a paired `Fieldset.Label` also toggles the checkbox.
- `onChange` is called from a `React.useEffect` on `checked`, so it fires once immediately after mount with the initial checked value, in addition to firing on every subsequent toggle.
- The rendered icon and its color follow the current checked state: `'icon-checked'`/`'intent-checked'` while checked, `'icon-unchecked'`/`'intent-unchecked'` while unchecked.

## Theme

- `theme.components.checkbox.cornerRadius` sizes the corner radius.
- `theme.components.checkbox.spacing` (tier 2) and `theme.components.checkbox.padding` (tier 3, type `ScaledCssPadding`) are the component-level padding overrides, resolved through the shared [padding resolution](../index.md#padding-resolution) — `spacing` overrides the global spacing map per scale key, `padding` overrides tiers 1/2 at the active scale key, and either is overridable per side by the shared padding props (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding`, all available since `CheckboxProps` extends the full `PaddingProps` with no `PositionElementProps` collision to avoid).
- `theme.components.checkbox.intents` supplies the border and icon colors for the checked/unchecked intents (`default` state only — the checkbox has no hover treatment).
- The checkbox's background transparency and color come from `theme.components.button.backgroundTransparency`/`theme.components.button.intents` using `props.intent` (the generic `IntentElementProps`, independent of checked state) at the `default` state — the same theme source `Button`'s background uses. This is a different intent than the one driving the border/icon colors: background color follows `props.intent`, while border and icon color follow `intent-checked`/`intent-unchecked`.
- Border thickness comes from `theme.components.button.borderThickness`, not `theme.components.checkbox.borderThickness` — the `borderColor` and `borderThickness` fields declared on `theme.components.checkbox` in `theme.template.ts` are unused by this component; the border color it actually renders comes from `theme.components.checkbox.intents` instead.
- `theme.components.checkbox.backgroundImage` (a flat, non-intent-scoped `CssBackgroundImage`, matching `theme.components.box.backgroundImage` rather than `Button`'s per-intent scheme) is resolved unconditionally — the same image/tint/slice renders regardless of `checked` state or `intent`. It renders as `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize` on the same `imagebutton`, independently of the `BackgroundColor3`/`BackgroundTransparency` fill described above — on Roblox's `ImageButton`, the `Image` layer renders regardless of `BackgroundTransparency`, so a theme can rely on `backgroundImage` alone (with `backgroundTransparency` at `1`) for a checkbox's entire visible surface.
- `theme.components.checkbox.backgroundGradient` (a flat, non-intent-scoped `CssBackgroundGradient`, matching `theme.components.box.backgroundGradient`) is likewise resolved unconditionally, rendering the same `Gradient` decorator's `<uigradient>` (see [Box](../surface/box.md#backgroundgradient)) regardless of `checked` state or `intent`. There is no instance override prop — theme-only, same as `backgroundImage` here.
