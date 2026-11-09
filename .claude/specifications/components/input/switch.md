# Switch

`Switch` is a clickable pill-shaped track with a circular thumb that slides between an off (left) and on (right) position, toggling a boolean value. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `SwitchProps` composes `IntentElementProps`, `BackgroundElementProps`, and `ZIndexElementProps`, plus `checked?: boolean`, `defaultChecked?: boolean`, `onChange?: (value: boolean) => void`, `disabled?: boolean`, `name?: string` (sets the rendered instance's `Name`, default `"Switch"`), and `LayoutOrder?: number` (passed to the root; unset leaves Roblox's default `0`).
- Controlled/uncontrolled, same contract as [Checkbox](./checkbox.md#public-api): passing `checked` makes the switch controlled (the visual follows the prop, activation calls `onChange(!checked)` and changes nothing internally); leaving it `undefined` makes it uncontrolled, starting at `defaultChecked` (default `false`).
- `onChange` fires only in response to a user toggle (click or paired `Fieldset.Label`). It never fires on mount and never fires when a controlled `checked` prop changes.
- `disabled`, unlike `Checkbox` (which has no disabled state), suppresses activation (clicking, and a paired `Fieldset.Label` activation), so `onChange` never fires while disabled, and renders a distinct dimmed visual state, following `Button`'s disabled convention.
- There is no `Switch.Thumb`/sub-part API; the thumb is internal.

### Breaking changes (2.0.0)

- `checked` used to only seed internal state on mount. It now makes the switch controlled; use `defaultChecked` for the old seed-only behaviour.
- `onChange` used to fire once right after mount with the initial value. It no longer does.

## Behavior

- Activating the switch (or, per the [Input](./index.md) fieldset convention, a paired `Fieldset.Label`) toggles as described above, unless `disabled`.
- The thumb animates its horizontal position, and the track animates its background/border colour, between the off and on states over `theme.components.switch.animation.duration` seconds. Both are driven by a single 0-to-1 tween progress value: the thumb's X position is linearly interpolated between its off/on offsets, and the track colours are `Color3.Lerp`'d between the off (`track` static colours) and on (intent-resolved) colours. A `duration` of `0` snaps instantly. In controlled mode the animation runs whenever the `checked` prop changes.
- The on-state colours are resolved via `ColorHelper.getIntentColors(theme, props.intent, disabled ? "disabled" : "default", theme.components.switch.track.intents)`; there is no hover state. The off-state colours are always the theme's static `track.backgroundColor`/`track.borderColor`.
- When `disabled`, both the track and thumb render at a flat `theme.components.switch.disabledTransparency`, overriding their normal transparency.

## Theme

`theme.components.switch` supplies:

- `width`, `height`: the track's fixed size (no auto-size, no size props).
- `cornerRadius`, `borderThickness`: the track's corner rounding and inner border thickness.
- `disabledTransparency`: the flat transparency applied to track and thumb while `disabled`.
- `animation.duration`: the tween duration described above.
- `track.backgroundColor`, `track.backgroundTransparency`, `track.borderColor`: the off-state track appearance.
- `track.intents`: optional per-`Intent` colour overrides (`default`/`disabled` states) for the on-state track, resolved the same three-tier way as every other component's `intents` map (see [Components](../index.md#theming)).
- `thumb.inset`: the gap between the thumb's edge and the track's edge on all four sides. Thumb diameter is `height - 2 * inset` and its off/on X offsets are derived from `inset` and `width`, so it never overlaps the track border.
- `thumb.cornerRadius`, `thumb.backgroundColor`, `thumb.backgroundTransparency`, `thumb.borderColor`, `thumb.borderThickness`, `thumb.boxShadow?`: the thumb's fixed appearance (not intent- or state-driven).

## Story

Worth demonstrating: an uncontrolled switch (`defaultChecked`) with `onChange` wired to visible state, a controlled switch driven by story state, a `disabled` switch (both checked and unchecked), a couple of `intent` variants, and switches in a list ordered with `LayoutOrder`.

## Implementation notes

- `toggleRef` holds the latest toggle closure (reassigned each render) so the `Fieldset` `labelActivated` connection, whose effect depends only on `fieldset`, never calls a stale `checked`/`disabled`/`onChange`. The disabled check lives inside that closure (`requestChange`), not in the connection.
- `onChange` is called from the activation handlers, not from an effect on the checked value; the old effect is what fired it on mount.
