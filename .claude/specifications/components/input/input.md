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
- Several native `TextBox` properties are managed internally and cannot be meaningfully overridden: `Text`, `FontFace`, `FontSize`, `BackgroundTransparency` (fixed at `1`), `ClearTextOnFocus` (defaults to `false` unless overridden), and `AutomaticSize`.
- Internally, the icon and the `TextBox` sit in a single non-wrapping `HStack` (`Wraps={false}`, matching the convention used by `Button`/`Increment`/`Accordion` for icon+content rows) with the `TextBox` wrapped in a `FlexItem` so it fills the remaining width; when `icon` is omitted, the `HStack` renders with only the `FlexItem`+`TextBox` child, unchanged from the pre-`icon` layout.

## Controlled vs. uncontrolled

- Without `controlled`, `value` seeds internal state (`React.useState(props.value)`) once; the rendered `Text` afterward comes from that internal state, updated as the user types.
- With `controlled: true`, the rendered `Text` is always `props.value` directly, so the consumer is responsible for feeding back `onChange` into `value`.

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
- `borderThickness` and `borderColor` for an `Enum.BorderStrokePosition.Inner` stroke.
- `cornerRadius`.
- `backgroundImage` (a flat `CssBackgroundImage`, matching `theme.components.box.backgroundImage`/`theme.components.checkbox.backgroundImage`) is resolved unconditionally and rendered as the root element's `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize`. `Input`'s root element is an `ImageLabel` (the `TextBox` ref stays on the inner `<textbox>`), so the background image is drawn directly on the root rather than a separate overlay layer.
- `placeholder?: Partial<TypographyStyle> | ScaledTypographyStyle` — same shape and resolution mechanism as `typography` (`TypographyHelper.getTypography(theme, props.scale, theme.components.input.placeholder)`), for API symmetry with the main text field. **Only `.color` from the resolved result is actually applied**, as `PlaceholderColor3`. This is intentional, not a bug: Roblox's `TextBox` exposes no `PlaceholderTransparency`, and font/size/weight/lineHeight are shared between `Text` and `PlaceholderText` (no separate placeholder-specific property exists), so `.transparency`, `.font`, `.size`, `.weight`, and `.lineHeight` on `placeholder` are accepted by the type but have no visual effect.
- `iconColor?: Color3` — the color passed to the prepended `Icon` when `props.icon` is set. Falls back to `Icon`'s own default (`theme.colors.intents.primary.default.textColor`) when unset.

`TextColor3` resolves as `props.TextColor3 ?? typography.color ?? theme.colors.intents.primary.default.textColor`. `TextTransparency` resolves as `props.TextTransparency ?? typography.transparency` (no further fallback — `undefined` leaves Roblox's own default). `PlaceholderColor3` resolves as `props.PlaceholderColor3 ?? placeholderTypography.color`, with no further fallback beyond that — if neither is set, Roblox's built-in default placeholder color is used.
