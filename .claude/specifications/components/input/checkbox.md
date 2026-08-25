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
- `theme.components.checkbox.spacing` is the default padding scheme resolved via `SpacingHelper.GetResolvedPadding`, overridable by the shared padding props.
- `theme.components.checkbox.intents` supplies the border and icon colors for the checked/unchecked intents (`default` state only — the checkbox has no hover treatment).
- The checkbox's background transparency and color come from `theme.components.button.backgroundTransparency`/`theme.components.button.intents` using `props.intent` (the generic `IntentElementProps`, independent of checked state) at the `default` state — the same theme source `Button`'s background uses. This is a different intent than the one driving the border/icon colors: background color follows `props.intent`, while border and icon color follow `intent-checked`/`intent-unchecked`.
- Border thickness comes from `theme.components.button.borderThickness`, not `theme.components.checkbox.borderThickness` — the `borderColor` and `borderThickness` fields declared on `theme.components.checkbox` in `theme.template.ts` are unused by this component; the border color it actually renders comes from `theme.components.checkbox.intents` instead.
