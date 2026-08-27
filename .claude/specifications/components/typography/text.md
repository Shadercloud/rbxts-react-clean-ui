# Text

`Text` is a themed, auto-sizing wrapper around a native `TextLabel`. It follows the shared conventions in [Components](../index.md).

## Public API

- `TextProps extends React.InstanceProps<TextLabel>` plus `text: string` (required), `variant?: TextVariant`, `typography?: TypographyStyle`, `weight?: Enum.FontWeight | "bold"`, `align?: "Left" | "Right" | "Center"`, `TextWrap?: boolean`, `letterSpacing?: number`.
- `Text` forwards a ref to the underlying `TextLabel` — **except** when letter spacing is active (see below), in which case the root instance is a `Frame` and the ref is not forwarded.

## Behavior

- `typography` (when supplied) is used verbatim and takes full precedence over `variant`; otherwise the style comes from `theme.typography[variant ?? "body"]`.
- `weight` resolution order: `"bold"` (→ `Enum.FontWeight.Bold`) → explicit `Enum.FontWeight` prop → the resolved style's own `weight` → `Enum.FontWeight.Regular`.
- Wrapping is enabled unless either `TextWrap={false}` or the native `TextWrapped={false}` is set — both `TextWrap` and `TextWrapped` must be non-`false` for wrapping to stay on; either one being `false` disables it (and both underlying `TextWrap`/`TextWrapped` instance properties are set together).
- `TextXAlignment` resolves from `align`, then a native `TextXAlignment` prop, then `Enum.TextXAlignment.Left`.
- `Size`/`AutomaticSize` are always `UDim2.fromScale(0, 0)` / `Enum.AutomaticSize.XY` — the label always auto-sizes to its text and cannot be given a fixed `Size`.
- `FontFace`/`FontSize` are always derived from the resolved style and `weight`; they cannot be overridden via native props even though `React.InstanceProps<TextLabel>` technically exposes them.
- `TextColor3` falls back to `theme.colors.intents.primary.default.textColor`; `BackgroundTransparency` falls back to `1`; `RichText` falls back to `true`; `TextScaled` falls back to `false`.

### Letter spacing

- `letterSpacing` resolves as `props.letterSpacing ?? style.letterSpacing` (the resolved typography style, per above).
- Roblox's `TextLabel` has no native letter-spacing property. When the resolved `letterSpacing` is a nonzero number and `text` is non-empty, `Text` renders a different tree instead of a single `TextLabel`: a non-visual, auto-sizing `Frame` (`BackgroundTransparency={1}`, `Size={UDim2.fromScale(0, 0)}`, `AutomaticSize={Enum.AutomaticSize.XY}`) containing a `UIListLayout` (`FillDirection = Horizontal`, `SortOrder = LayoutOrder`, `Padding = UDim.new(0, letterSpacing)`, `VerticalAlignment = Center`, `HorizontalAlignment` from `align` — defaulting to `Left`) and one `TextLabel` per character of `text` (each with an explicit `LayoutOrder` matching its position, and otherwise reusing the same font/weight/size/line-height/color/stroke/transparency resolution as the single-label path).
- When `letterSpacing` is unset, `0`, or `text` is `""`, rendering is unchanged from the plain single-`TextLabel` path (zero behavior change for existing callers, since no shipped theme other than the sample "Wooden" theme sets a nonzero `letterSpacing` today).
- This mode is intended for short, single-line, plain-text content (headings, titles, buttons, badges) — not wrapped paragraphs. `RichText` is always forced off on the per-character labels (markup tags cannot survive being split apart, so any `<...>` markup in `text` renders as literal characters instead of being interpreted). `TextWrap`/`TextWrapped`/`TextTruncate` are not applied to the per-character labels; they have no effect there since each character label always auto-sizes to exactly fit its own single character and therefore never wraps or overflows regardless of those props.
- `ref` is not forwarded while this mode is active — the root instance is a `Frame`, not a `TextLabel`, so a caller relying on `ref` together with a nonzero `letterSpacing` gets no ref callback/value from that render.

## Theme

- `theme.typography.<variant>` (`display`, `title`, `heading`, `body`, `label`, `caption`) supplies `font`, `size`, optional `weight`, optional `lineHeight`, and optional `letterSpacing` for each named style.
- `theme.colors.intents.primary.default.textColor` supplies the default text color.
