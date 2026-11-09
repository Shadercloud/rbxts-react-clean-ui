# Badge

`Badge` is a small pill showing a count, status or short label, optionally preceded by an icon. It is non-interactive unless given `onClick`. It follows the shared conventions in [Components](../index.md).

## Public API

- `BadgeProps` composes `IntentElementProps`, `ScalableElementProps`, `IconElementProps`, `BackgroundElementProps` and `BorderElementProps`, plus:
  - `text: string` (required): the label.
  - `intent?: Intent` (default `"primary"`): selects the theme colour scheme.
  - `scale?: ScaleSize` (default `theme.default.scale`): moves text size, icon size, padding and icon/text gap together.
  - `icon?: IconName`: drawn before the text.
  - `name?: string` (default `"Badge"`), `LayoutOrder?: number`, `Position?: UDim2`, `AnchorPoint?: Vector2`.
  - Per-instance colours, each overriding the intent scheme's value; unset uses the intent value:
    - `BackgroundColor3?: Color3 | Binding<Color3>`, `BackgroundTransparency?: number | Binding<number>`.
    - `textColor?: Color3`.
    - `iconColor?: Color3`: unset falls back to the resolved text colour (so `textColor` alone tints both).
    - `borderColor?: Color3`.
  - Border shape (`BorderElementProps`): `borderThickness?: number` (unset uses `badge.borderThickness`; the stroke renders only when the resolved value is `> 0`), `borderTransparency?: number` (unset leaves the stroke opaque), `borderPosition?: "inner" | "outer"` (default `"inner"`).
  - `padding?: CssPadding`: per-side override over the theme's [padding resolution](../index.md#padding-resolution) at the badge's `scale`.
  - `onClick?: () => void`: makes the badge clickable (see Clickable badges).
  - `hoverStyle?: BadgeStateStyle`, `pressStyle?: BadgeStateStyle`: colour overrides while hovered/pressed. Only used when `onClick` is set.
- `BadgeStateStyle` (exported): `{ backgroundColor?: Color3; backgroundTransparency?: number; textColor?: Color3; iconColor?: Color3; borderColor?: Color3 }`.
- `Badge` forwards a ref to its root `ImageLabel` in both modes.

## Behavior

- Sizes to its content (`AutomaticSize` XY, zero base size); never stretches to the parent width.
- Children, left to right, vertically centred, never wrapping: optional icon, then text (text wrapping disabled).
- Gap between icon and text is half of the resolved spacing at the active scale (component `spacing` over global `theme.spacing`), rounded up, the same as `HStack`'s default gap.
- `backgroundImage` and `backgroundGradient` always come from the merged intent scheme (no instance override). Background transparency defaults to `0`.
- Corners use `cornerRadius`.

## Clickable badges

- Without `onClick` the tree is unchanged from earlier versions: root `ImageLabel` (`Active`/`Selectable` `false`, no events) holding the corners, optional stroke, gradient, padding and content row directly.
- With `onClick`, the root `ImageLabel` keeps the background, corners, stroke and gradient, and its content (padding + row) moves into a single transparent, content-sized `ImageButton` child named `"BadgeButton"` (`AutoButtonColor` off). The root sizes to that button, so the whole pill is the click target. Activating it calls `onClick`.
- States: hovered while the pointer is over the button or it holds gamepad selection; pressed while mouse button 1 / touch is held down on it (cleared on release, on leave and on activation).
- Colours per state, highest priority first:
  - hovered: `hoverStyle` field, then the instance prop, then the intent value;
  - pressed: `pressStyle` field, then `hoverStyle` field, then the instance prop, then the intent value.
- If the state style gives no `backgroundColor`, the resting background (instance `BackgroundColor3` or intent colour) is shaded: lerped toward black by `badge.hoverDarken` while hovered or `badge.pressDarken` (falling back to `hoverDarken`) while pressed; a negative value lerps toward white by its absolute value, matching `charts.pie.hoverDarken`. Unset or `0` means no shading. Bindings are shaded through `map`.
- Removing `onClick` resets hover/press, so re-adding it doesn't show a stale state.

## Theme

`theme.components.badge`:

- `cornerRadius: CssSize`, `borderThickness: number`.
- `spacing?` / `padding?`: tiered [padding resolution](../index.md#padding-resolution), keyed by the badge's `scale` (not `theme.default.spacing`).
- `typography?`: plain `Partial<TypographyStyle>` or `ScaledTypographyStyle`, merged over the theme typography for the scale (`typeScaleMap`).
- `intents?`: per-intent `InlineIntentColors`, merged via `ColorHelper.getIntentColors` like `Button` (`textColor`, `backgroundColor`, `borderColor`, `backgroundTransparency`, `backgroundImage`, `backgroundGradient`). Only the `default` state is read, also for clickable badges.
- `hoverDarken?: number`, `pressDarken?: number`: clickable background shading described above. Unset means no shading.

Shipped values:

- **Default**: pill (`"50%"` radius), 1px border; neutral light-grey `primary`, solid intent-coloured backgrounds with white text for the others; per-scale padding (`"1px 4px"` to `"6px 14px"`) and bold per-scale text sizes (10 to 24) with no font, so each theme keeps its own font. `hoverDarken 0.08`, `pressDarken 0.16`.
- **Dark**: pill, 1px border; dark tinted backgrounds with the dark palette's intent text/border colours. Inherits Default's padding/typography. `hoverDarken -0.1`, `pressDarken -0.2` (lightens, since the backgrounds are dark).
- **Sandstone**: 4px radius, 1px border; the Sandstone intent palette. Inherits Default's padding/typography. `hoverDarken 0.08`, `pressDarken 0.16`.
- **Wooden**: 4px radius, 2px `#3D2712` border, `"2px 10px"` padding, `#FFF7CF` text at the `label` style (PatrickHand, Size18, regular) for every scale; flat backgrounds `primary #7A4A20`, `success #4E6A24`, `info #2C5270`, `warning #A67A20`, `danger #7A3220`; no image or gradient. Inherits Default's `hoverDarken`/`pressDarken`.

## Story

Worth demonstrating: all five intents side by side, each scale, with and without an icon, a numeric count, a badge placed next to a `Button`/`Text` to show it sizing to content, a badge with custom per-instance colours and `padding`, and a clickable pill (`onClick`) showing theme hover/press shading plus one with explicit `hoverStyle`/`pressStyle`.

## Implementation notes

- Every theme's `badge.intents` sets `backgroundColor`/`borderColor`/`textColor` on **every** intent. `getIntentColors` layers the component `primary` entry over the theme-tier matching intent, so an intent left unset would inherit `primary`'s neutral pill colours.
- Default's `badge.typography` is scale-keyed, and `createTheme` deep-merges, so a theme overriding it with a plain `{ font, size }` object ends up with both scale keys and plain fields; `TypographyHelper` then treats it as scaled and ignores the plain fields. Override per scale key (as Wooden does).
- Deep merge can't remove keys, so Default's `badge` must never gain `backgroundImage`/`backgroundGradient`: every derived theme (Wooden's flat badges in particular) would inherit it.
- Root `Image` falls back to `""` when no `backgroundImage` resolves so a flat badge never shows a stale image.
- Clickable hover/press deliberately doesn't call `getIntentColors` with the `"hover"` state: that would layer `theme.colors.intents.<intent>.hover` (meant for buttons, possibly carrying images/gradients) under the badge's own entries and leak into the badge. Shading plus `hoverStyle`/`pressStyle` keep the badge independent of button hover colours.
- The clickable mode wraps the content in a child `ImageButton` instead of turning the root into one, so the forwarded ref stays an `ImageLabel` (no public ref type change) and the non-clickable tree stays identical. An absolutely-positioned overlay button was rejected: under the root's `UIPadding` it would need negative offsets, and scale-sized children interact badly with `AutomaticSize`.
