# Text

`Text` is a themed, auto-sizing wrapper around a native `TextLabel`. It follows the shared conventions in [Components](../index.md).

## Public API

- `TextProps extends React.InstanceProps<TextLabel>` and `Pick<SizeElementProps, "minWidth" | "maxWidth" | "minHeight" | "maxHeight">`, plus `text: string` (required), `variant?: TextVariant`, `typography?: TypographyStyle`, `weight?: Enum.FontWeight | "bold"`, `align?: "Left" | "Right" | "Center"`, `TextWrap?: boolean`, `letterSpacing?: number`, `outline?: TypographyOutline | boolean`, `shrinkToFit?: boolean`, `shrinkMinScale?: number`, `minTextSize?: number`, `maxTextSize?: number`.
- `TypographyOutline` (exported from the theme module) is `{ color?: Color3; thickness?: number; transparency?: number }`.
- `Text` forwards a ref to the underlying `TextLabel` — **except** when letter spacing is active (see below), in which case the root instance is a `Frame` and the ref is not forwarded.
- With none of the new props set (and no theme `outline`), the instance tree is exactly the plain label (or letter-spaced frame) described below, with no extra UI objects.

## Behavior

- `typography` (when supplied) is used verbatim and takes full precedence over `variant`; otherwise the style comes from `theme.typography[variant ?? "body"]`.
- `weight` resolution order: `"bold"` (→ `Enum.FontWeight.Bold`) → explicit `Enum.FontWeight` prop → the resolved style's own `weight` → `Enum.FontWeight.Regular`.
- Wrapping is enabled unless either `TextWrap={false}` or the native `TextWrapped={false}` is set — both `TextWrap` and `TextWrapped` must be non-`false` for wrapping to stay on; either one being `false` disables it (and both underlying `TextWrap`/`TextWrapped` instance properties are set together).
- `TextXAlignment` resolves from `align`, then a native `TextXAlignment` prop, then `Enum.TextXAlignment.Left`.
- `Size`/`AutomaticSize` default to `UDim2.fromScale(0, 0)` / `Enum.AutomaticSize.XY`, so the label auto-sizes to its text; the native `Size`/`AutomaticSize` props override them on the plain-label path (the letter-spaced frame always auto-sizes).
- `FontFace`/`FontSize` are always derived from the resolved style and `weight`; they cannot be overridden via native props even though `React.InstanceProps<TextLabel>` technically exposes them.
- `TextColor3` falls back to `theme.colors.intents.primary.default.textColor`; `BackgroundTransparency` falls back to `1`; `RichText` falls back to `true`; `TextScaled` falls back to `false`.

### Min and max size (wrap at a width)

- `minWidth`/`maxWidth`/`minHeight`/`maxHeight` follow [Min and max size](../index.md#min-and-max-size): one `UISizeConstraint` named `SizeConstraint` on the root instance (the label, or the letter-spaced frame).
- `maxWidth` on its own is the "auto-sized label that wraps at a width" case: a text shorter than `maxWidth` is exactly its natural single-line size; a longer text is capped at `maxWidth`, wraps onto more lines, and grows in height to fit them (wrapping must be on, which is the default). It replaces a hand-written `<uisizeconstraint>` child; don't pass both.
- This works because the plain label's own wrapped text drives its `AutomaticSize`, which respects the constraint's `MaxSize`.
- On the letter-spaced path the text can't wrap and the frame auto-sizes to its character labels, so `maxWidth` doesn't narrow it (see the shared note on maximums); use `shrinkToFit` there instead.
- While `shrinkToFit` is on, `maxWidth` is the width to shrink into and is left out of the `UISizeConstraint` (the other three still apply).

### Outline

- `outline` draws a `UIStroke` with `ApplyStrokeMode = Contextual` on the text (on each character label when letter-spaced), named `Outline`, for text read over the 3D world.
- Resolution: `outline={false}` draws none, even if the theme style has one. `outline={true}` draws the resolved style's `outline` or, field by field, the defaults. An object overrides the style's `outline` field by field. Unset uses the resolved style's `outline` if it has one, otherwise draws none.
- Field defaults: `color` black (`Color3(0, 0, 0)`), `thickness` `1`, `transparency` `0`.
- It is separate from the native `TextStrokeColor3`/`TextStrokeTransparency`, which still pass through unchanged.

### Shrink to fit

- `shrinkToFit` scales the whole text (box and glyphs) down with a `UIScale` named `ShrinkScale` so that its visual width fits the available width. It never scales up (scale ≤ `1`) and never goes below `shrinkMinScale` (clamped to `0`–`1`, default `0`). Once the floor is reached, the text overflows.
- The available width is `maxWidth` when set, otherwise the parent's width minus the parent's `UIPadding` left/right. The parent's width must not depend on the text: inside a parent that auto-sizes on X, the text stays at scale `1`.
- The result is the largest scale (within `shrinkMinScale`–`1`) at which the rendered width fits the available width; it stops once the text is within half a pixel of the available width. Roblox renders text at whole-pixel text sizes and rounds each label's auto-size to whole pixels, so the rendered width is a step function of the scale, not proportional to it. The fitted text can therefore be narrower than the target by up to one text-size step (for an 18px letter-spaced title at about a third of its size, 54.7px in a 60px slot, because the next step is about 65px).
- The scale follows changes to the text's natural size, the parent's size and reparenting. Until the available width is known (`0` or no GUI parent), the scale stays where it is.
- Meant for single-line content, especially letter-spaced text, which can't wrap. With a wrapping label and no `maxWidth` constraint, the label is a single line anyway (it auto-sizes on X), so the scale fits that line.
- Because `UIScale` also shrinks the layout footprint, siblings in a list layout close up around the scaled text.

### Text size cap

- `minTextSize`/`maxTextSize` add a `UITextSizeConstraint` named `TextSizeConstraint` to the text (each character label when letter-spaced). Use them to bound `TextScaled` text. Unset is `1` for the minimum and `100` for the maximum. Both are clamped to Roblox's `1`–`100`, and a maximum below the minimum is raised to it.
- No constraint is rendered when both are unset.

### Letter spacing

- `letterSpacing` resolves as `props.letterSpacing ?? style.letterSpacing` (the resolved typography style, per above).
- Roblox's `TextLabel` has no native letter-spacing property. When the resolved `letterSpacing` is a nonzero number and `text` is non-empty, `Text` renders a different tree instead of a single `TextLabel`: a non-visual, auto-sizing `Frame` (`BackgroundTransparency={1}`, `Size={UDim2.fromScale(0, 0)}`, `AutomaticSize={Enum.AutomaticSize.XY}`) containing a `UIListLayout` (`FillDirection = Horizontal`, `SortOrder = LayoutOrder`, `Padding = UDim.new(0, letterSpacing)`, `VerticalAlignment = Center`, `HorizontalAlignment` from `align` — defaulting to `Left`) and one `TextLabel` per character of `text` (each with an explicit `LayoutOrder` matching its position, and otherwise reusing the same font/weight/size/line-height/color/stroke/transparency resolution as the single-label path).
- When `letterSpacing` is unset, `0`, or `text` is `""`, rendering is unchanged from the plain single-`TextLabel` path (zero behavior change for existing callers, since no shipped theme other than the sample "Wooden" theme sets a nonzero `letterSpacing` today).
- This mode is intended for short, single-line, plain-text content (headings, titles, buttons, badges) — not wrapped paragraphs. `RichText` is always forced off on the per-character labels (markup tags cannot survive being split apart, so any `<...>` markup in `text` renders as literal characters instead of being interpreted). `TextWrap`/`TextWrapped`/`TextTruncate` are not applied to the per-character labels; they have no effect there since each character label always auto-sizes to exactly fit its own single character and therefore never wraps or overflows regardless of those props.
- `ref` is not forwarded while this mode is active — the root instance is a `Frame`, not a `TextLabel`, so a caller relying on `ref` together with a nonzero `letterSpacing` gets no ref callback/value from that render.
- `SizeConstraint` and `ShrinkScale` go on the frame; `Outline` and `TextSizeConstraint` go on every character label.

## Theme

- `theme.typography.<variant>` (`display`, `title`, `heading`, `body`, `label`, `caption`) supplies `font`, `size`, optional `weight`, optional `lineHeight`, optional `letterSpacing` and optional `outline` (`TypographyOutline`) for each named style. No shipped theme sets `outline`.
- A style `outline` is honoured only where text renders through `Text`, including components that pass a resolved typography to `Text`. Components that draw their own native `TextLabel` ignore it.
- `theme.colors.intents.primary.default.textColor` supplies the default text color.

## Story

- Wrap at a width: the same long sentence with and without `maxWidth`, plus a short text under the same `maxWidth` that stays its natural width.
- Outline: a white label over a busy or bright background, with `outline={true}` and a custom colour/thickness.
- Shrink to fit: a letter-spaced title in a fixed-width slot that you can resize, with and without `shrinkMinScale`.
- Text size cap: a `TextScaled` label in a large box with `maxTextSize`.

## Loom

- One letter-spaced, outlined title with `shrinkToFit` inside a fixed-width frame, and one wrapping paragraph with `maxWidth`.

## Implementation notes

- `FontFace` is built with `TypographyHelper.toFontFace` (see [shared-modules.md](../../../architecture/shared-modules.md#srchelperstypographyhelperts)), not `Font.fromName(font.Name, ...)`, so legacy `Enum.Font` values whose name differs from their family file (e.g. `Fantasy`, `SourceSans`) render their real typeface instead of falling back to Builder Sans.
- `maxWidth` uses the shared `SizeElementProps` keys and `SizeHelper.GetSizeConstraint` rather than a Text-only prop, so there is only ever one `UISizeConstraint` (`SizeConstraint`) on the root. Roblox honours only one per instance.
- `maxWidth` is dropped from the `UISizeConstraint` while `shrinkToFit` is on. The constraint clamps the unscaled box before `UIScale` applies, so keeping it would cap the box at `maxWidth` and then scale that box down a second time, and the root's `AbsoluteSize` would no longer give the natural width.
- Shrink measurement: the scale is found by a bounded synchronous search in `update` (`SHRINK_SEARCH_STEPS`), not a single `available / (AbsoluteSize.X / currentScale)` estimate. The old single estimate assumed the width is proportional to the scale, but text renders at whole-pixel sizes and each auto-sized label rounds to whole pixels, so `AbsoluteSize.X / currentScale` changes with the scale. On the letter-spaced path that made the estimate oscillate (every `UIScale` write re-fired `AbsoluteSize` and produced a new estimate, swinging between about 47px and 74px in a 60px slot, overflowing on some frames), and a plain label stopped at 52px in a 60px slot.
- The search proposes `scale * available / width` and falls back to bisection inside the bracket of the largest fitting scale and the smallest overflowing scale; if it ends overflowing, it goes back to the best fitting scale. It relies on `AbsoluteSize` being current right after a `UIScale` write (Studio lays out synchronously); `width` is read after the parent's width, since reading the parent can flush a pending layout of the root.
- `searching` blocks the `AbsoluteSize` events the search's own writes fire, and `settledAvailable`/`settledScale`/`settledWidth` make a re-run on an unchanged result a no-op (so deferred signals don't restart the search). The scale is a `useBinding` (no re-render per write). `TextService` measurement was avoided because it yields, needs separate per-character maths for letter spacing, and would not see the user's child padding.
- The shrink effect depends on `letterSpaced` because switching modes remounts a different root (`Frame` vs `TextLabel`) and the listeners must move to it. It deliberately does not reset the scale to `1` on re-run: the new root already renders at the current scale, and a reset would flicker for a frame.
- `setLabel` merges the forwarded `ref` with the internal `rootRef` (same pattern as `Scroller`'s `setFrame`), so `ref` keeps working. It must go through `ElementHelper.assignRef`, never a `ref !== undefined` guard: browser React (the docs' Loom preview) passes an absent forwarded ref as `null`, so that guard crashed every scene containing a `Text` with `Cannot set properties of null (setting 'current')`.
- `getContentWidth` looks up the slot's padding with `FindFirstChildOfClass("UIPadding")`, not `FindFirstChildWhichIsA`: the Loom preview runtime doesn't implement `FindFirstChildWhichIsA` and `shrinkToFit` crashed there. `UIPadding` has no subclasses, so the two are equivalent in Roblox.
- `outline` is merged field by field (`outlineProp?.color ?? style.outline?.color ?? default`) rather than by spreading two possibly-undefined objects. Either way, `true` and an object both still pick up a theme outline's other fields.
- `renderTextDecorations`/`renderBoxDecorations` return Fragments whose unset parts are `false`, so they add no instances when nothing is set.
