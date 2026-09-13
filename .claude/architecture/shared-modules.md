# Shared modules

Implementation notes for src/Helpers, src/Interfaces, src/Contexts and src/Providers — src/ carries no comments, so non-obvious rationale lives here.

## src/Helpers/color.helper.ts

- `ColorHelper.getIntentColors`: the tier cascade and layer order are specified in [components/index.md](../specifications/components/index.md#theming). A component or override entry can be either per-state `InlineIntentColors` or a flat `Partial<IntentScheme>`. A flat entry is applied as that tier's `default` layer for every requested state and never adds a state layer.
- `isInlineIntentColors` only checks for a `default`, `hover` or `focus` key. An entry that sets only `disabled` is treated as a flat scheme, so its `disabled` override is silently ignored.
- `mergeLayers` merges `backgroundImage`, `backgroundGradient` and `typography` field by field. Every other field is last-wins. A new nested-object field on `IntentScheme` needs its own accumulator here, or a partial state layer will silently drop the earlier layers' fields. Inside `backgroundGradient`, `colors`/`stops` are leaf values: a layer that sets `colors` replaces the whole array and also resets `stops` to its own `stops` (or `undefined`, so even spacing, when it sets none), because stops tuned for a different colour list would be misplaced. A layer that sets `stops` without `colors` overrides `stops` on the inherited colours, and a layer that sets neither keeps both.

## src/Helpers/css.helper.ts

- `parseCssSize` supports exactly one calc() shape: `"<n>% - <n>px"` or `"<n>% + <n>px"`. It splits on the literal `" - "`/`" + "`, so the spaces are required, and it keeps only the left term's Scale and the right term's Offset. Any other string falls through to single-token parsing.
- `resolveBackgroundGradient` takes a `Partial<CssBackgroundGradient>`, so `Gradient` can pass a merged `IntentScheme.backgroundGradient` straight through. It returns `undefined` when `value` is `undefined`, `colors` is unset, or `colors` is an empty array. Keep that guard here, where the partial is resolved, rather than at call sites. `buildColorSequence` indexes `colors[0]`, so it must never see an empty array.
- `buildColorSequence` always forces the first color to Time `0` and the last to Time `1`, because Roblox rejects a `ColorSequence` otherwise. As a result, the first and last `stops` entries are always overridden. It then sorts keypoints by Time, because Roblox also throws on non-ascending times (out-of-order interior `stops`). The sort tie-breaks on array index because Luau's `table.sort` isn't stable, so colors that share a Time keep their authored order.

## src/Helpers/gui.helper.ts

- `getGuiRenderOrder`: both sorts tie-break on child index (`rootIndex` for surfaces, `siblingIndex` for siblings) because Luau's `table.sort` is not stable. Without that, siblings with equal `DisplayOrder`/`ZIndex` come out in arbitrary order. A nested `LayerCollector` becomes its own render surface and is not recursed into from its parent surface.

## src/Helpers/size.helper.ts

- `"Auto"` for `width`/`height`: `GetAutoSize` treats it as unset when it picks the AutomaticSize axes, while `GetSize` resolves it to `0` on that axis. Together, that gives a zero base size that grows with content.

## src/Helpers/spacing.helper.ts

- `GetExplicitPadding` returns only a theme's tier-3 component padding, with no fallback to the spacing scale, and returns `undefined` when the theme sets none. Use it for an opt-in floor that must be a no-op in themes that don't configure padding (Card's wood-frame clearance). `GetResolvedPadding` always produces a value and would engage in every theme.

## src/Helpers/typography.helper.ts

- `getClosestTypography`: for a per-scale `ScaledTypographyStyle`, it tries the exact scale, then the nearest smaller scale, then the nearest larger one.

## src/Interfaces/css.types.ts

- `CssCalcSize` is kept separate from `CssSize` on purpose. Folding the calc template literals into `CssSize` multiplies through `CssDual`/`CssQuad` and hits TypeScript's "union type that is too complex to represent" error at call sites that spread props with several quad fields (e.g. `<BoxShadow {...props} />` in `Button`). Use `CssCalcSize` only where a calc term is needed (currently `CssPosition.width`).

## src/Contexts/breakpoint.context.ts

- `BreakpointContext`, `useBreakpoint` and `useBreakpointValue` are specified with their provider in [layout/breakpointprovider.md](../specifications/components/layout/breakpointprovider.md), including the implementation notes on hook ordering and the camera/viewport fallback.
