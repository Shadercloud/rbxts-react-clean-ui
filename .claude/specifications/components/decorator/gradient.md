# Gradient

`Gradient` renders a Roblox gradient instance (`UIGradient`) from a `CssBackgroundGradient` value. It is how `backgroundGradient` gets drawn wherever the library supports it (`Container`, and through it `Box`, `Button`, `Card`, `Checkbox`, `Input`, `Select`, `Tabs`, `ProgressBar`). It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts a `value` prop, a `Partial<CssBackgroundGradient>`. It is partial so that a resolved intent scheme's `backgroundGradient` can be passed straight through without a guard.
- Accepts an optional `name` prop, used as the rendered instance's name. Defaults to `"Gradient"`.
- Renders nothing when `value` is `undefined`, or when `value` has no usable `colors` (unset or an empty array). A caller can pass a possibly-unset theme or intent gradient without checking it first, the same way it does with `BoxShadow`/`Corners`.
- Otherwise it renders a single `UIGradient` as a child of whatever it is placed in. The gradient composites over the parent's `BackgroundColor3`/image following ordinary Roblox `UIGradient` rules. `Gradient` sets no property on the parent itself.
- The props interface is not exported. The public shape is `CssBackgroundGradient` (`src/Interfaces/css.types.ts`).

## Field mapping

The field-by-field shape is documented under [Box → `backgroundGradient`](../surface/box.md#backgroundgradient). Each field maps to the rendered `UIGradient` like this:

- `colors` becomes `Color`.
  - A `ColorSequence` is used as-is, and `stops` is ignored.
  - A single-entry `Color3[]` produces a solid sequence of that color, and `stops` is ignored.
  - With two or more colors, each color becomes a keypoint. Its position is the matching `stops[i]` clamped to `0`–`1`, or evenly spaced (`i / (count - 1)`) when that stop is missing. The first color is always at `0` and the last at `1`, whatever `stops` says, so only interior stops take effect.
  - Keypoints are ordered by position, so interior stops don't have to be ascending: each color is placed at its own stop. Colors that share a position keep their array order, which gives a hard edge.
- `transparency` becomes `Transparency`. A number (clamped to `0`–`1`) gives uniform transparency, and a `NumberSequence` is used as-is. When omitted, the Roblox default applies (fully opaque).
- `rotation` becomes `Rotation` (degrees), and `offset` becomes `Offset`. Both pass through unchanged. When omitted, the Roblox defaults apply (`0` and `(0, 0)`).
- No other `UIGradient` property is set. `Enabled` keeps its default of `true`.

## Theming

- `Gradient` reads nothing from the theme itself. The calling component resolves the value (prop, then `theme.components.<name>.backgroundGradient`, then the intent/state `backgroundGradient`, per that component's spec) and passes it in.
- When the value comes from an intent scheme, it should be the field-by-field merge of every intent/state layer, as described in [Components → Theming](../index.md#theming). For example, a `hover` layer that sets only `rotation` keeps the `colors` from the `default` layer. The one exception is `stops`: a layer that sets `colors` never inherits an earlier layer's `stops`. It uses its own `stops` if it sets them, and even spacing otherwise. A layer that sets `stops` without `colors` repositions the inherited colors.

## Implementation notes

- The `colors` guard, the forcing of the first/last keypoints to `0`/`1`, and the keypoint sort all live in `CssHelper.resolveBackgroundGradient`/`buildColorSequence`. See `src/Helpers/css.helper.ts` in [shared-modules.md](../../../architecture/shared-modules.md#srchelperscsshelperts) before changing how `colors`/`stops` are resolved.
- `Gradient` passes its partial `value` straight to `resolveBackgroundGradient`, which accepts a `Partial<CssBackgroundGradient>`. Don't reintroduce a cast to the full type here. That cast is what let a colorless gradient reach `buildColorSequence` and throw.
