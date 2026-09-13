# Badge

`Badge` is a small, non-interactive pill showing a count, status or short label, optionally preceded by an icon. It follows the shared conventions in [Components](../index.md).

## Public API

- `BadgeProps` composes `IntentElementProps`, `ScalableElementProps` and `IconElementProps`, plus:
  - `text: string` (required) — the label.
  - `intent?: Intent` (default `"primary"`) — selects the colour scheme.
  - `scale?: ScaleSize` (default `theme.default.scale`) — moves text size, icon size, padding and icon/text gap together.
  - `icon?: IconName` — drawn before the text, tinted with the resolved text colour.
  - `name?: string` (default `"Badge"`), `LayoutOrder?: number`, `Position?: UDim2`, `AnchorPoint?: Vector2`.
- `Badge` forwards a ref to its root `ImageLabel`.
- No `spacing`/padding/colour/size props: styling comes only from the theme.

## Behavior

- Sizes to its content (`AutomaticSize` XY, zero base size); never stretches to the parent width.
- Never takes input: root has `Active` and `Selectable` set to `false`, and no events are wired. There are no hover/disabled states; colours always resolve with the `default` state.
- Children, left to right, vertically centred, never wrapping: optional icon, then text (text wrapping disabled).
- Gap between icon and text is half of the resolved spacing at the active scale (component `spacing` over global `theme.spacing`), rounded up, the same as `HStack`'s default gap.
- Background colour, transparency (default `0`), border colour, text/icon colour, `backgroundImage` and `backgroundGradient` all come from the merged intent scheme.
- An inner border stroke renders only when `borderThickness > 0`. Corners use `cornerRadius`.

## Theme

`theme.components.badge`:

- `cornerRadius: CssSize`, `borderThickness: number`.
- `spacing?` / `padding?` — tiered [padding resolution](../index.md#padding-resolution), keyed by the badge's `scale` (not `theme.default.spacing`).
- `typography?` — plain `Partial<TypographyStyle>` or `ScaledTypographyStyle`, merged over the theme typography for the scale (`typeScaleMap`).
- `intents?` — per-intent `InlineIntentColors`, merged via `ColorHelper.getIntentColors` like `Button` (`textColor`, `backgroundColor`, `borderColor`, `backgroundTransparency`, `backgroundImage`, `backgroundGradient`).

Shipped values:

- **Default**: pill (`"50%"` radius), 1px border; neutral light-grey `primary`, solid intent-coloured backgrounds with white text for the others; per-scale padding (`"1px 4px"` to `"6px 14px"`) and bold per-scale text sizes (10 to 24) with no font, so each theme keeps its own font.
- **Dark**: pill, 1px border; dark tinted backgrounds with the dark palette's intent text/border colours. Inherits Default's padding/typography.
- **Sandstone**: 4px radius, 1px border; the Sandstone intent palette. Inherits Default's padding/typography.
- **Wooden**: 4px radius, 2px `#3D2712` border, `"2px 10px"` padding, `#FFF7CF` text at the `label` style (PatrickHand, Size18, regular) for every scale; flat backgrounds `primary #7A4A20`, `success #4E6A24`, `info #2C5270`, `warning #A67A20`, `danger #7A3220`; no image or gradient.

## Story

Worth demonstrating: all five intents side by side, each scale, with and without an icon, a numeric count, and a badge placed next to a `Button`/`Text` to show it sizing to content.

## Implementation notes

- Every theme's `badge.intents` sets `backgroundColor`/`borderColor`/`textColor` on **every** intent. `getIntentColors` layers the component `primary` entry over the theme-tier matching intent, so an intent left unset would inherit `primary`'s neutral pill colours.
- Default's `badge.typography` is scale-keyed, and `createTheme` deep-merges, so a theme overriding it with a plain `{ font, size }` object ends up with both scale keys and plain fields; `TypographyHelper` then treats it as scaled and ignores the plain fields. Override per scale key (as Wooden does).
- Deep merge can't remove keys, so Default's `badge` must never gain `backgroundImage`/`backgroundGradient`: every derived theme (Wooden's flat badges in particular) would inherit it.
- Root `Image` falls back to `""` when no `backgroundImage` resolves so a flat badge never shows a stale image.
