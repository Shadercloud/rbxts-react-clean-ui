# Text

`Text` is a themed, auto-sizing wrapper around a native `TextLabel`. It follows the shared conventions in [Components](../index.md).

## Public API

- `TextProps extends React.InstanceProps<TextLabel>` plus `text: string` (required), `variant?: TextVariant`, `typography?: TypographyStyle`, `weight?: Enum.FontWeight | "bold"`, `align?: "Left" | "Right" | "Center"`, `TextWrap?: boolean`.
- `Text` forwards a ref to the underlying `TextLabel`.

## Behavior

- `typography` (when supplied) is used verbatim and takes full precedence over `variant`; otherwise the style comes from `theme.typography[variant ?? "body"]`.
- `weight` resolution order: `"bold"` (→ `Enum.FontWeight.Bold`) → explicit `Enum.FontWeight` prop → the resolved style's own `weight` → `Enum.FontWeight.Regular`.
- Wrapping is enabled unless either `TextWrap={false}` or the native `TextWrapped={false}` is set — both `TextWrap` and `TextWrapped` must be non-`false` for wrapping to stay on; either one being `false` disables it (and both underlying `TextWrap`/`TextWrapped` instance properties are set together).
- `TextXAlignment` resolves from `align`, then a native `TextXAlignment` prop, then `Enum.TextXAlignment.Left`.
- `Size`/`AutomaticSize` are always `UDim2.fromScale(0, 0)` / `Enum.AutomaticSize.XY` — the label always auto-sizes to its text and cannot be given a fixed `Size`.
- `FontFace`/`FontSize` are always derived from the resolved style and `weight`; they cannot be overridden via native props even though `React.InstanceProps<TextLabel>` technically exposes them.
- `TextColor3` falls back to `theme.colors.intents.primary.default.textColor`; `BackgroundTransparency` falls back to `1`; `RichText` falls back to `true`; `TextScaled` falls back to `false`.

## Theme

- `theme.typography.<variant>` (`display`, `title`, `heading`, `body`, `label`, `caption`) supplies `font`, `size`, optional `weight`, and optional `lineHeight` for each named style.
- `theme.colors.intents.primary.default.textColor` supplies the default text color.
