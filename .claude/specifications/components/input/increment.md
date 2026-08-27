# Increment

`Increment` is a numeric stepper: a minus button, a numeric text field, and a plus button laid out horizontally. It composes the existing `Button` and `Input` components rather than rendering its own icon/text-field visuals. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `IncrementProps` composes `ScalableElementProps`, `SpacedElementProps`, `IntentElementProps`, and `React.InstanceProps<Frame>`, plus:
  - `value: number` (required) — the initial value, unless `controlled` is set.
  - `onChange?: (value: number) => void`.
  - `step?: number` — amount the minus/plus buttons change the value by; defaults to `1`.
  - `min?`, `max?: number` — inclusive bounds enforced when a step button is activated, and (via the underlying `Input`'s own `min`/`max`/`validation="Number"` clamping) when a typed value loses focus.
  - `controlled?: boolean` — mirrors `Input`'s controlled/uncontrolled convention.
- `scale` and `intent` are forwarded to both the minus and plus `Button`s (icon size/color, background/border color). `intent` has no effect on the numeric field, since `Input` has no `intent` prop.
- `spacing` is forwarded to the root layout gap between the three parts and to the minus/plus `Button`s' and the `Input`'s own internal padding, mirroring how `Button` reuses a single `spacing` prop for both its icon/text gap and its padding.
- The root renders through `Container`, always at `Size={UDim2.fromScale(1, 0)}` with `AutomaticSize.Y` (full available width, height fit to content) — `Size`/`AutomaticSize` props are not honored (same override behavior as `Select`'s root).

## Behavior

- `Increment` owns numeric state itself (`React.useState(props.value)`), separate from `Input`'s own string state. `Input` is always rendered `controlled={true}` with `value={tostring(current)}`, where `current` is `props.value` when `controlled` is set, otherwise the internal numeric state.
- Activating the minus/plus `Button` computes `current - step`/`current + step`, clamps it to `[min, max]`, and — unless `controlled` — updates internal state, then always calls `onChange` with the clamped value. If the current value already sits at `min` (minus) or `max` (plus), activating that button is a no-op: neither state nor `onChange` fire.
- Typing into the field forwards `Input`'s `onChange` (fired on every valid keystroke, per `Input`'s own validation) straight through as a number, without clamping it against `min`/`max` mid-edit — this matches `Input`'s own behavior of only clamping `min`/`max` on `FocusLost`. When the field loses focus with an out-of-range number, `Input`'s internal `FocusLost` handling clamps its text and calls `Increment`'s `onChange` handler again with the corrected value, which is applied the same way as any other change.
- On every render, `Increment` re-derives whether the minus/plus buttons are at their bound by calling `resolveSteppedValue` for that direction against the current value/step/min/max and checking for `undefined`, and passes the result as `disabled` to the corresponding `Button`. This gives each button `Button`'s theme-driven disabled visual (muted colors, inert clicks, no hover) whenever stepping further would no-op, in addition to the `Activated` handler's own no-op guard (kept as defense in depth).

## Layout

- The root lays out its three children horizontally via `HStack` (`valign="Center"`), with the minus `Button` first, the `Input` (wrapped in a `FlexItem` so it grows to fill the space between the two buttons) second, and the plus `Button` last.
- The `Input`'s text is centered (`TextXAlignment={Enum.TextXAlignment.Center}`).

## Theme

- The minus/plus `Button`s use the normal `theme.components.button` styling by default, and the numeric field uses `theme.components.input`, resolved by those components exactly as documented in `button.md` and `input.md`.
- `theme.components.increment.button` is an optional `Partial<theme.components.button>` that, when set, is passed as `styleOverride` to both the minus and plus `Button`s (see `button.md`'s Theme section for how `styleOverride` resolves per-field). Any field left unset on `theme.components.increment.button` falls back to the normal `theme.components.button` value for that field — a theme that wants Increment's buttons borderless while every other button keeps its border only needs to set `borderThickness: 0` under `theme.components.increment.button`, for example. The default theme leaves `theme.components.increment.button` unset, so `Increment` uses ordinary button styling out of the box.
- The gap between the three parts uses the same `spacing`-driven default as `HStack`/`Button` elsewhere (`theme.default.spacing` when `spacing` is omitted), not a bespoke layout knob.

## Story

Worth demonstrating: a default stepper with no bounds, one with `min`/`max` showing the buttons becoming visually disabled at the bounds, a `step` other than `1`, each `intent`, and a `controlled` example wired to external state.
