# Components

This specification defines conventions shared by every component in `src/Components/`. Component- and category-specific behavior belongs in the corresponding spec file; this file exists so those files don't have to repeat it.

## Props

- A component's public props interface is composed from the shared element-prop interfaces (size, position, background, z-index, intent, icon, spacing/padding, shadow, scalable) rather than redeclaring the same fields per component.
- `scale` (one of `xs`, `sm`, `md`, `lg`, `xl`) is the shared sizing knob: it drives typography, icon size, and spacing together through the theme rather than each being sized independently.
- `intent` (one of `primary`, `success`, `warning`, `danger`, `info`) is the shared semantic-color knob for interactive/status components. It selects a themed color scheme rather than the component taking raw color props as its primary styling surface.
- A component with distinguishable named sub-parts (e.g. an icon or text region) exposes them as properties on the component itself (`Button.Icon`, `Button.Text`) rather than as separately exported components, so a consumer can compose or restyle just that part.

## Theming

- Every themeable component reads its defaults from `theme.components.<name>`, and a corresponding prop always takes precedence over the theme default when both are supplied.
- Interactive components support at least `default` and `hover` visual states from the theme; components with a focus/selected or disabled state add those too. State-dependent colors are resolved from the active `intent` rather than being fixed per component.
- Every complete theme (default, dark, and any other shipped theme) provides a full, distinct set of values for every themeable component — a new component's theme addition is not complete until all shipped themes have concrete values for it, not just the default.
- `ColorHelper.getIntentColors` resolves a scheme from up to three tiers, each layered on top of (not replacing) the ones before it: the theme tier (`theme.colors.intents`), the component tier (the `intents` map passed in from `theme.components.<name>`), and an optional override tier (a per-instance `intents` map, e.g. `Button`'s `styleOverride.intents`) for components that support one. Within each tier, layers apply lowest to highest precedence: the primary intent's `default`, the matching intent's `default`, the primary intent's requested state, then the matching intent's requested state — i.e. every `default` layer in a tier is applied before any state-specific layer in that same tier, so a shared `primary.disabled`-style override can't be clobbered by another intent's own `default` colors. Scalar fields (colors, transparency, etc.) are last-wins: a later layer that sets a field fully replaces the earlier value. The nested-object fields, `backgroundImage`, `backgroundGradient`, and `typography`, instead merge field-by-field across every layer that sets them — a layer only needs to specify the fields it wants to override (e.g. a `hover` layer overriding just `backgroundImage.tintColor`, `backgroundGradient.rotation`, or `weight` within `typography`) and inherits the rest from earlier layers rather than restating the whole object.
- A duration/size knob that gates an optional visual effect (animation length, shadow, border) always accepts `0` (or omission) to mean "disabled," rather than requiring a separate boolean toggle.

### Padding resolution

A component with the standard padding/spacing prop set (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding` — see `PaddingProps`) resolves its per-side padding through `SpacingHelper.GetResolvedPadding`, which layers four tiers, each falling back to the one below when unset, merged **per side** rather than wholesale:

1. **Global spacing** — `theme.spacing: ScaleSizeValue<number>`, keyed by scale name.
2. **Component spacing** — `theme.components.<name>.spacing?: ScaleSizeValue<number>`, overriding the global map per scale key (falling back to the global map for any key it doesn't define).
3. **Component padding** — `theme.components.<name>.padding?: CssPadding | ScaleSizeValue<CssPadding>` (a `ScaledCssPadding`) — a fixed quad, or a quad keyed the same way as tier 2 — overriding tiers 1/2 at the active scale key.
4. **Inline prop** — `resolvedPadding` (raw, wins outright and skips every other tier) > individual `top`/`bottom`/`left`/`right` > instance `padding` (a single quad, not scale-indexed) > tiers 3/2/1 at the active scale key.

The active scale key is `props.spacing` (if set and not `"None"`), else a component's own pinned default if it has one (e.g. `Card.Header`/`Card.Footer` always pin `"md"` regardless of `theme.default.spacing`), else `theme.default.spacing`. This key selects both the tier-1/2 magnitude and which tier-3 quad shape applies — `spacing` is not a separate override that bypasses tier 3, it is what tiers 1/2/3 all key off of. `spacing === "None"` forces `0` for every side not otherwise overridden, before any per-side/instance-`padding` override applies on top.

Because resolution merges per side, setting only one side (e.g. `top`) leaves the other sides to fall through tiers 3/2/1 rather than resetting the whole quad to the generic global default — a partial override never silently discards a sibling side's component- or theme-driven value.

A component built on `PositionElementProps` (which declares `top`/`left`/`right`/`bottom` as *position* offsets, `CssSize`) cannot also cleanly extend the full `PaddingProps` (same names, `ScaleSize` scale keys) — on those components, only `spacing`, `padding`, and `resolvedPadding` are safe, collision-free padding-prop additions; per-side padding overrides aren't exposed there (`Box`, `Card.Header`, `Card.Footer`, `Tooltip`).

## Composition and layout

- Components compose from other library components (layout primitives, `Icon`, `Text`, decorators) rather than hand-rolling equivalent Roblox instances inline, so behavior/theming stays centralized.
- A component that needs a corner radius, drop shadow, or padding applies it via the shared decorator components rather than reimplementing the underlying `Instance` properties directly.
- Unless a component's spec says otherwise, it sizes to fill the width made available by its parent and sizes its height automatically to its content.

## Interaction

- Pointer/gamepad activation on a clickable surface goes through the shared hover-aware button primitive so default/hover (and selected/focus) states stay consistent across components, rather than each component wiring its own `MouseEnter`/`MouseLeave` handling.
- A component that can be disabled does not fire its change/activation callbacks while disabled, and renders a distinct disabled visual state from the theme.

## Animation

- Where a component animates a transition (expand/collapse, value change, mount), the animation uses the library's shared tweening utility and is driven by a theme (or prop) duration that can be set to `0` to disable it outright.
- Repeated/rapid triggering of an animated transition continues smoothly from the current visual state rather than restarting or stacking animations.
