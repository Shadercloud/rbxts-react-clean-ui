# Checkbox

`Checkbox` is a clickable `ImageButton` that toggles a boolean value and displays a state-dependent icon, optionally followed by a clickable text label. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `CheckboxProps` composes `IntentElementProps`, `PaddingProps`, `BackgroundElementProps`, `SpacedElementProps`, and `ScalableElementProps`, plus `checked?: boolean`, `defaultChecked?: boolean`, `onChange?: (value: boolean) => void`, `'icon-checked'?: IconName`, `'icon-unchecked'?: IconName`, `'intent-checked'?: Intent`, `'intent-unchecked'?: Intent`, `label?: string`, and `name?: string`.
- **Controlled** when `checked` is passed (not `undefined`): the rendered state always follows `checked`. Activation calls `onChange(!checked)` and changes nothing internally; the caller must feed the new value back through `checked` for the visual to change.
- **Uncontrolled** when `checked` is `undefined`: internal state starts at `defaultChecked` (default `false`) and activation flips it, then calls `onChange` with the new value. Changing `defaultChecked` after mount has no effect.
- `onChange` fires only in response to a user toggle (box click, label click, or a paired `Fieldset.Label`). It never fires on mount and never fires when a controlled `checked` prop changes.
- `'icon-checked'` defaults to `"check"`. `'icon-unchecked'` has no default: when omitted, the unchecked state renders no icon.
- `'intent-checked'` defaults to `"success"`; `'intent-unchecked'` defaults to `"primary"`.
- `name` names the root instance (default `"Checkbox"`).

### Breaking changes (2.0.0)

- `checked` used to only seed internal state on mount (the checkbox stayed uncontrolled afterwards). It now makes the checkbox controlled, so a caller passing `checked` without updating it from `onChange` gets a checkbox that no longer changes visually. Use `defaultChecked` for the old seed-only behaviour.
- `onChange` used to fire once right after mount with the initial value. It no longer does; callers that relied on that initial call to sync their own state must read the initial value themselves.

## Behavior

- Activating the box toggles as described above.
- Per the [Input](./index.md) fieldset convention, activating a paired `Fieldset.Label` toggles the checkbox the same way.
- The rendered icon and its colour follow the current checked state: `'icon-checked'`/`'intent-checked'` while checked, `'icon-unchecked'`/`'intent-unchecked'` while unchecked.

## Label

- With `label` unset, the rendered tree is exactly the single box `ImageButton` (named by `name`), with no wrapper.
- With `label` set, the root becomes a transparent, content-sized `Frame` named by `name` (default `"Checkbox"`) laid out as a horizontal, vertically centred, non-wrapping row:
  1. the box `ImageButton`, renamed `"CheckboxBox"`, otherwise identical;
  2. a transparent, content-sized `ImageButton` named `"CheckboxLabel"` (not gamepad-selectable, so gamepad selection stays on the box) containing a non-wrapping `Text` named `"CheckboxLabelText"`.
- Activating the label toggles exactly like activating the box.
- Label text uses the theme typography for the checkbox's `scale` (`theme.typeScaleMap`), merged with `theme.components.checkbox.label.typography`. Text colour is `checkbox.label.textColor`, falling back to `Text`'s default (the theme's `primary` default text colour).
- Gap between box and label is `checkbox.label.gap` (pixels); unset, it is half the resolved spacing at the checkbox's `scale` (`checkbox.spacing` over `theme.spacing`), rounded up, like `HStack`'s default gap.

## Theme

- `theme.components.checkbox.cornerRadius` sizes the corner radius.
- `theme.components.checkbox.spacing` (tier 2) and `theme.components.checkbox.padding` (tier 3, type `ScaledCssPadding`) are the component-level padding overrides, resolved through the shared [padding resolution](../index.md#padding-resolution), and can be overridden per side by the shared padding props (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding`).
- `theme.components.checkbox.intents` supplies the border and icon colours for the checked/unchecked intents (`default` state only; the checkbox has no hover treatment). It also supplies the background colour, but keyed by `props.intent` (independent of checked state) instead of the checked/unchecked intent.
- Background transparency is `props.BackgroundTransparency`, falling back to `theme.components.button.backgroundTransparency` (the checkbox has no transparency key of its own).
- Border: `theme.components.checkbox.borderThickness` and `borderTransparency` (default `0`), inner stroke. The declared `checkbox.borderColor` is unused; border colour comes from `checkbox.intents`.
- `theme.components.checkbox.backgroundImage` (a flat, non-intent-scoped `CssBackgroundImage`) is resolved unconditionally onto the box's `Image*` properties, independently of the background fill. On Roblox's `ImageButton` the `Image` layer renders regardless of `BackgroundTransparency`, so a theme can use `backgroundImage` alone (with transparency `1`) for the whole visible surface.
- `theme.components.checkbox.backgroundGradient` (flat `CssBackgroundGradient`) renders through the `Gradient` decorator (see [Box](../surface/box.md#backgroundgradient)) regardless of state. Theme-only, no instance prop.
- `theme.components.checkbox.label?: { typography?: Partial<TypographyStyle> | ScaledTypographyStyle; textColor?: Color3; gap?: number }`, all optional, described under Label. No shipped theme sets it.

## Story

Worth demonstrating: an uncontrolled checkbox (`defaultChecked`) with `onChange` shown as text, a controlled checkbox driven by story state (including one whose `onChange` is ignored to show it stays put), a checkbox with `label` where clicking the text toggles it, and a `Fieldset` checkbox pairing.

## Implementation notes

- `toggleRef` holds the latest "toggle" closure and is reassigned every render. The `Fieldset` `labelActivated` connection calls through it, so the effect only depends on `fieldset` and never reads a stale `checked`/`controlled`/`onChange`. Reconnecting on every prop change instead would work but churns the connection each render.
- `onChange` is called from the activation handlers, not from an effect on the checked value. The old effect-based approach is what fired `onChange` on mount; don't reintroduce it.
- In label mode the box key changes from `name` to `"CheckboxBox"`, so React remounts the box when `label` toggles between set and unset. That is intended: the root has to change from `ImageButton` to `Frame`.
