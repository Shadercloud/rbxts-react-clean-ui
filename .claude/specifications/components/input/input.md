# Input

`Input` is a themed wrapper around a native `TextBox`, with text validation and fieldset integration. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `InputProps` composes `ScalableElementProps`, `SpacedElementProps`, and `React.InstanceProps<TextBox>`, plus:
  - `value: string` (required) — the initial text, unless `controlled` is set.
  - `placeholder?: string` — alias for `PlaceholderText`; `PlaceholderText`, if supplied, takes priority.
  - `validation?: "Number" | "String" | "None" | "Int" | "Telephone" | "Alphanumeric" | "Email"`.
  - `min?`, `max?: number` — only enforced when `validation` is `"Number"` or `"Int"`.
  - `onChange?: (value: string) => void`.
  - `controlled?: boolean`.
  - `icon?: IconName` — when set, renders an `Icon` before the text field in the same row.
  - `disabled?: boolean` — when `true`, the `TextBox` cannot be edited or focused (`TextEditable` forced to `false`, `Interactable` to `false`), loses focus if it currently has it, ignores `Fieldset.Label` activation, and the field takes its `states.disabled` look (see Theme). Unset/`false` behaves exactly as before the prop existed (an explicit `TextEditable` prop still passes through).
- Several native `TextBox` properties are managed internally and cannot be meaningfully overridden: `Text`, `FontFace`, `FontSize`, `BackgroundTransparency` (theme-driven, see Theme), `ClearTextOnFocus` (defaults to `false` unless overridden), and `AutomaticSize`.
- Internally, the icon and the `TextBox` sit in a single non-wrapping `HStack` (`Wraps={false}`, matching the convention used by `Button`/`Increment`/`Accordion` for icon+content rows) with the `TextBox` wrapped in a `FlexItem` so it fills the remaining width; when `icon` is omitted, the `HStack` renders with only the `FlexItem`+`TextBox` child, unchanged from the pre-`icon` layout.

## Controlled vs. uncontrolled

- Without `controlled`, `value` seeds internal state (`React.useState(props.value)`) once; the rendered `Text` afterward comes from that internal state, updated as the user types.
- With `controlled: true`, the field shows `props.value`, so the consumer is responsible for feeding back `onChange` into `value`.
- In both modes, **while the `TextBox` is focused the box belongs to the user**: changes to `props.value` (or internal state) are not written into it. `onChange` still fires on every keystroke. A parent that reformats on each keystroke (e.g. uppercasing) is therefore only shown once focus is lost.
- When focus is lost (after `min`/`max` clamping), and on any later value change while unfocused, the box is synced to the current value — unless that value is one `Input` itself reported via `onChange` during the last focus session and the box doesn't show it yet (a stale echo from a parent or store that hasn't caught up); then the box keeps its text until the value changes again or catches up. A value the parent set on its own (reformatting `"4"` to `"4.00"` on blur, switching records, rejecting input) is shown.

## Validation

- Validation is applied on every keystroke via the `Change.Text` handler, using `resolveValidatedText` (`Input.validation.ts`): if the candidate text is rejected, the `TextBox`'s `Text` is reset back to the last valid text (`lastValidText`) and neither `onChange` nor state update run for that keystroke.
- `"Number"`/`"Int"`: rejects text that doesn't parse as a number, except it always allows `""` and `"-"` so a negative number can be typed. `"Int"` is not distinguished from `"Number"` at the character-filtering stage — both allow decimals while typing; the `Int`/`Number` distinction only affects the min/max-clamping behavior below.
- `"Telephone"`, `"Alphanumeric"`, `"Email"`: reject text that doesn't match a fixed Lua pattern allow-list (`CHARACTER_ALLOW_LIST_PATTERNS`). `"String"` and `"None"` (or omitting `validation`) apply no character filtering.
- `min`/`max` are enforced only in the `FocusLost` handler, and only when `validation` is `"Number"` or `"Int"`: if the parsed number is outside `[min, max]`, it is clamped, written back to the `TextBox`, and `onChange` is called with the clamped text.
- `props.Change`/`props.Event` handlers passed by the consumer are merged with (and run alongside) the component's internal `Change.Text`/`Event.FocusLost` handling.

## Fieldset integration

Per the [Input](./index.md) convention, when rendered inside a `Fieldset`, activating the paired `Fieldset.Label` calls `CaptureFocus()` on the underlying `TextBox`.

## Theme

`theme.components.input` supplies:

- `typography?: Partial<TypographyStyle> | ScaledTypographyStyle`, resolved via `TypographyHelper.getTypography(theme, props.scale, theme.components.input.typography)` — the same typography-cascade mechanism used throughout the theme (flat partial = override on top of the resolved scale's base typography; per-scale partial = different overrides per `ScaleSize`, resolved to the closest matching scale). Drives `FontFace`, `FontSize`, `LineHeight`, and (via `.color`/`.transparency`) `TextColor3`/`TextTransparency`.
- `backgroundColor?: Color3` and `backgroundTransparency?: number` (default `1`, invisible) — a flat fill on the root `ImageLabel` (`BackgroundColor3`/`BackgroundTransparency`). Unset in every shipped theme, so the field stays transparent. A `backgroundImage`, when set, draws over the fill (same instance). `WoodenTheme` sets a `backgroundImage`; a theme extending it clears that with `backgroundImage: { image: "" }` to show only the flat colour.
- `borderThickness` and `borderColor` for an `Enum.BorderStrokePosition.Inner` stroke.
- `cornerRadius` (`0` = square, no `UICorner`).
- `backgroundImage` (a flat `CssBackgroundImage`, matching `theme.components.box.backgroundImage`/`theme.components.checkbox.backgroundImage`) is resolved unconditionally and rendered as the root element's `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize`. `Input`'s root element is an `ImageLabel` (the `TextBox` ref stays on the inner `<textbox>`), so the background image is drawn directly on the root rather than a separate overlay layer.
- `backgroundGradient` (a flat `CssBackgroundGradient`, matching `theme.components.box.backgroundGradient`/`theme.components.checkbox.backgroundGradient`) is resolved unconditionally and rendered on the root element via the `Gradient` decorator (see [Box](../surface/box.md#backgroundgradient)). There is no instance override prop — `backgroundGradient` is theme-only, same as `backgroundImage` here.
- `placeholder?: Partial<TypographyStyle> | ScaledTypographyStyle` — same shape and resolution mechanism as `typography` (`TypographyHelper.getTypography(theme, props.scale, theme.components.input.placeholder)`), for API symmetry with the main text field. **Only `.color` from the resolved result is actually applied**, as `PlaceholderColor3`. This is intentional, not a bug: Roblox's `TextBox` exposes no `PlaceholderTransparency`, and font/size/weight/lineHeight are shared between `Text` and `PlaceholderText` (no separate placeholder-specific property exists), so `.transparency`, `.font`, `.size`, `.weight`, and `.lineHeight` on `placeholder` are accepted by the type but have no visual effect.
- `iconColor?: Color3` — the color passed to the prepended `Icon` when `props.icon` is set. Falls back to `Icon`'s own default (`theme.colors.intents.primary.default.textColor`) when unset.
- `boxShadow?: CssShadow | CssBoxShadow` — an outer `UIShadow` on the root. A bare `CssShadow` string (the same type `tooltip`/`switch.thumb` take) uses the global `theme.components.boxShadow` colour/transparency; a `CssBoxShadow` table (`{ shadow, color, transparency }`, the `charts.pie` shape) carries its own. An all-zero shadow, or unset, draws nothing. `{ shadow: "0px 1px 0px 0px", color, transparency: 0 }` draws a 1px light lip under the field. The shadow is cast by the root's shape, so it needs a visible root fill to read well.
- `innerShadow?: { color: Color3; transparency: number; size: number }` — an inset shadow, which Roblox has no native instance for. Draws a `color` band inside the field's border (inset by the current border thickness, rounded with `cornerRadius` minus that thickness) whose transparency fades from `transparency` at the top edge to fully transparent `size` px down, under the icon and text. Unset = no band and the original instance tree (see Implementation notes).
- `states?: { hover?, focus?, disabled? }`, each a `FieldStateStyle` (`borderColor?`, `borderThickness?`, `backgroundColor?`, `backgroundTransparency?`, `backgroundGradient?`). The base keys above are the default state; the active state's keys override them key by key, with no cascade between states. Precedence: `disabled` (the `disabled` prop) > `focus` (the `TextBox` is focused) > `hover` (the pointer is over the field) > default. Unset, or a state without a given key, = the base key. The inner shadow follows the active `borderThickness`.
- A flat field such as `backgroundColor #295896`, `backgroundTransparency 0`, `borderColor #3D2712`, `borderThickness 3`, `cornerRadius 0`, `typography.color #FFF7CF`, `placeholder.color #8FA6C4`, `iconColor #FFF7CF` is reachable from these keys alone. Because `Select`'s search row renders an `Input`, it picks the same look up.

`TextColor3` resolves as `props.TextColor3 ?? typography.color ?? theme.colors.intents.primary.default.textColor`. `TextTransparency` resolves as `props.TextTransparency ?? typography.transparency` (no further fallback — `undefined` leaves Roblox's own default). `PlaceholderColor3` resolves as `props.PlaceholderColor3 ?? placeholderTypography.color`, with no further fallback beyond that — if neither is set, Roblox's built-in default placeholder color is used.

## Theme example: sunk "ink well"

Reproduces a field cut into the panel (CSS `linear-gradient(#173a66, #214c84 45%, #295896)`, `2px solid #3d2712`, `8px` radius, `inset 0 3px 5px rgba(0,0,0,.5), 0 1px 0 #a87a45`, focus border `#f2a65a`):

```ts
input: {
    borderColor: Color3.fromHex("#3D2712"),
    borderThickness: 2,
    cornerRadius: 8,
    backgroundColor: Color3.fromHex("#FFFFFF"),
    backgroundTransparency: 0,
    backgroundGradient: { colors: [Color3.fromHex("#173A66"), Color3.fromHex("#214C84"), Color3.fromHex("#295896")], stops: [0, 0.45, 1], rotation: 90 },
    boxShadow: { shadow: "0px 1px 0px 0px", color: Color3.fromHex("#A87A45"), transparency: 0 },
    innerShadow: { color: Color3.fromHex("#000000"), transparency: 0.5, size: 8 },
    states: { focus: { borderColor: Color3.fromHex("#F2A65A") } },
}
```

`backgroundColor` is white because `UIGradient` multiplies the fill. A theme extending `WoodenTheme` also needs `backgroundImage: { image: "" }` to drop Wooden's sliced image.

## Implementation notes

- Focus guard: while focused, `Text` renders `heldText` (the `Text` prop of the last committed render, captured in `Focused`), so React sees no change and never writes. Writing `props.value` every commit lost keystrokes: React could commit a render computed before the next keystroke, writing `"2"` back over `"24"`. Don't go back to `Text={props.controlled ? props.value : value}` unguarded.
- The unfocused sync is an effect on `[focused, sourceText]` that writes through `ref` and then releases `heldText`. Writing through the ref is required: if the new value equals `heldText`, React would skip the write and leave the user's text in the box. `reportedTexts` (every text passed to `onChange` since the last `Focused`) is what tells a stale echo from a parent's own value; without it an async store still one keystroke behind at blur (typing then Enter) would overwrite the last keystroke or the clamp.
- `FocusLost` clamps (and reports the clamped text) before clearing `focusedRef`/calling `setFocused(false)`, so the render that ends the focus already sees the clamp.
- `FontFace` is built with `TypographyHelper.toFontFace` (see [shared-modules.md](../../../architecture/shared-modules.md#srchelperstypographyhelperts)), not `Font.fromName(font.Name, ...)`, so legacy `Enum.Font` values whose name differs from their family file (e.g. `Fantasy`, `SourceSans`) render their real typeface instead of falling back to Builder Sans.
- `innerShadow` cannot be a plain child of the root: `HStack` is a fragment, so its `UIListLayout` sits on the root and would lay the band out as a row item, and the root's `UIPadding` would inset it. When `innerShadow` is set, the root `Padding` + `HStack` move into a transparent `Content` frame (`Size` scale 1x1, `AutomaticSize.Y`, `ZIndex` 2) and the `InnerShadow` frame is its sibling at `ZIndex` 1, so the band draws under the text. When unset, the tree is the original one, so existing descendant paths don't change. The 1x1 scale on `Content` keeps a fixed-height `Size` vertically centring the row. A child scaled on its auto-sized parent's axis is relied on here and should be checked visually in Studio.
- `FieldInnerShadow` (`Input.field.tsx`, shared with `Select`) fills the whole interior and fades via a `UIGradient` (`Rotation` 90) whose middle keypoint is `size / measuredHeight`. A band only `size` px tall was rejected: `UICorner` clamps its radius to half the frame height, so a short band's top corners would be less round than the field's and poke out past them. The band stays hidden until its `AbsoluteSize` has been measured.
- The `Focused` handler is added on top of `props.Event` and forwards to `props.Event.Focused`, just as `FocusLost` does; dropping that forwarding would silently swallow a consumer's handler.
- `disabled` does not read `FieldsetContext.disabled` (see ISSUES.md): wiring it would change how existing disabled fieldsets look.
- Multi-line input was considered and skipped: scrolling at a fixed height needs a `ScrollingFrame` around an auto-sized `TextBox` plus caret-follow scrolling (`CursorPosition` → text bounds), which the current `HStack`/`FlexItem` row doesn't support cleanly. The native `MultiLine` prop still passes through.
