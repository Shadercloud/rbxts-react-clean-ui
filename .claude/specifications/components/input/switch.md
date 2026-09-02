# Switch

`Switch` is a clickable pill-shaped track with a circular thumb that slides between an off (left) and on (right) position, toggling a boolean value. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `SwitchProps` composes `IntentElementProps`, `BackgroundElementProps`, and `ZIndexElementProps`, plus `checked?: boolean`, `onChange?: (value: boolean) => void`, `disabled?: boolean`, and `name?: string` (sets the rendered instance's `Name`, defaulting to `"Switch"`).
- `checked` only seeds the component's internal state on mount (`React.useState(props.checked ?? false)`), matching `Checkbox`'s pattern — changing the `checked` prop after the initial render has no further effect. The component is uncontrolled from that point on.
- `onChange` is called from a `React.useEffect` on the internal checked state, so it fires once immediately after mount with the initial value, in addition to firing on every subsequent toggle.
- `disabled`, unlike `Checkbox` (which has no disabled state), suppresses both activation (clicking, and a paired `Fieldset.Label` activation) and `onChange`, and renders a distinct dimmed visual state — following `Button`'s disabled convention instead.
- There is no `Switch.Thumb`/sub-part API — the thumb is an internal implementation detail, not a composable part.

## Behavior

- Activating the switch (or, per the [Input](./index.md) fieldset convention, activating a paired `Fieldset.Label`) toggles the internal checked state, unless `disabled`.
- The thumb animates its horizontal position, and the track animates its background/border color, from the off state to the on state (and back) over `theme.components.switch.animation.duration` seconds. Both animate together, driven by a single 0-to-1 tween progress value: the thumb's X position is linearly interpolated between its off/on offsets, and the track's background/border colors are `Color3.Lerp`'d between the off (`theme.components.switch.track` static colors) and on (intent-resolved) colors, both keyed off that same progress value. A `duration` of `0` snaps instantly instead of animating.
- The on-state colors are resolved via `ColorHelper.getIntentColors(theme, props.intent, disabled ? "disabled" : "default", theme.components.switch.track.intents)` — there is no hover state, matching `Checkbox`'s "no hover treatment" convention. The off-state colors are always the theme's static `track.backgroundColor`/`track.borderColor`, independent of `intent` and of checked state.
- When `disabled`, both the track and thumb render at a flat `theme.components.switch.disabledTransparency`, overriding (not blending with) their normal transparency — the same flat-override pattern `Button` uses for its own `disabled` intent entry.

## Theme

`theme.components.switch` supplies:

- `width`, `height` — the track's fixed size (the control does not auto-size or accept `width`/`height` override props).
- `cornerRadius`, `borderThickness` — the track's corner rounding and border thickness (rendered via `Corners`/`uistroke`, `BorderStrokePosition.Inner`).
- `disabledTransparency` — the flat transparency applied to both track and thumb while `disabled`.
- `animation.duration` — the tween duration described above.
- `track.backgroundColor`, `track.backgroundTransparency`, `track.borderColor` — the off-state track appearance.
- `track.intents` — optional per-`Intent` color overrides (`default`/`disabled` states only) layered on top of `theme.colors.intents` for the on-state track appearance, resolved the same three-tier way every other themed component's `intents` map is (see [Components](../index.md#theming)).
- `thumb.inset` — the gap between the thumb's edge and the track's edge/border, on all four sides. The thumb's diameter is derived as `height - 2 * inset` (not a separate size field) and its off/on X offsets are derived from `inset` and `width` so it never overlaps the track's border, mirroring how `Slider`'s `bar.padding` reserves room for its handle.
- `thumb.cornerRadius` — the thumb's corner rounding (independently themeable per theme, the same way `Slider`'s `handle.cornerRadius` varies from a full circle to a smaller radius across shipped themes).
- `thumb.backgroundColor`, `thumb.backgroundTransparency`, `thumb.borderColor`, `thumb.borderThickness`, `thumb.boxShadow?` — the thumb's fixed appearance (not intent- or checked-state-driven).

## Story

Worth demonstrating: an uncontrolled switch with `onChange` wired to visible state, a `disabled` switch (both checked and unchecked), and a couple of `intent` variants to show the on-state color changing.
