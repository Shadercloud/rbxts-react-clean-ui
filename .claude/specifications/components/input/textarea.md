# Textarea

`Textarea` is a fixed-height, multi-line, scrollable text field. It has the same look, value handling and fieldset integration as [Input](./input.md); the differences are listed below. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `Textarea` is a `React.forwardRef` component. Its ref is the inner `TextBox`, so a consumer can call `CaptureFocus()`/`ReleaseFocus()` on it. `TextareaProps` is exported.
- `TextareaProps` composes `ScalableElementProps`, `SpacedElementProps`, `Omit<SizeElementProps, "Size" | "AutomaticSize" | "height">` and `Omit<React.InstanceProps<TextBox>, "Size" | "AutomaticSize">`, plus:
  - `value: string` (required), `controlled?: boolean`, `onChange?: (value: string) => void`, `placeholder?: string`, `disabled?: boolean`, `name?: string`: same meaning as on `Input`, including the focus guard ([Controlled vs. uncontrolled](./input.md#controlled-vs-uncontrolled)). While focused the box belongs to the user, and the box is synced to the value on blur unless the value is a stale echo.
  - `height?: CssPixelSize`: the field's height in pixels (`%` and `"Auto"` are not accepted).
  - `rows?: number`: the number of visible lines, used when `height` is unset.
  - `maxLength?: number`: the most characters the user can type or paste.
  - `showCount?: boolean`: draws a character counter under the field.
- `Event` and `Change` handlers passed in still run. `Event.Focused`/`Event.FocusLost` are how a consumer listens for focus and blur, as on `Input`, and `Change.Text`/`Change.CursorPosition`/`Change.TextBounds` are forwarded after the component's own handling.
- Gamepad selection props (`Selectable`, `SelectionImageObject`, `NextSelectionUp/Down/Left/Right`, `SelectionGroup`, `SelectionOrder`) are passed to the `TextBox`, as on `Input`.
- The `TextBox` always has `MultiLine = true`, `TextWrapped = true`, `ClearTextOnFocus = false`, and text aligned top-left. Those props, along with `Text`, `FontFace`, `FontSize`, `LineHeight`, `TextScaled`, `TextTruncate` and the TextBox's size, are managed by the component. Any value passed for them is ignored.
- There is no `validation`, `min`/`max` or `icon`. Those are `Input` features for single-line values.

## Size

- Width: `width` (default `100%`, resolved like any `width`), clamped by `minWidth`/`maxWidth` through a `UISizeConstraint` named `SizeConstraint` on the root.
- Field height, highest precedence first:
  1. `height`, in pixels.
  2. `rows` × line height + top padding + bottom padding. The line height is the input typography's text size × its `lineHeight` (`1` when unset), so it follows `scale` and the theme font size.
  3. `theme.components.textarea.rows`, the same way.
  4. `4` rows.
  Rows are floored and at least `1`. The result is then clamped to `[minHeight, maxHeight]`. These two clamp the field directly and are not rendered as a `UISizeConstraint`.
- The height is fixed. Typing, pasting or deleting never changes the size of the component or its parent. The root's height is set explicitly (it has no `AutomaticSize`): the field height, plus, with `showCount`, the `xs` spacing gap and one counter line (the counter typography's text size × its `lineHeight`, `1` when unset). The field height, gap and counter line are each rounded up to whole pixels (see Implementation notes).

## Scrolling

- The text scrolls inside a [Scroller](../layout/scroller.md) that fills the field and has `stableGutter` set. The scrollbar's gutter is always reserved, so the text wraps at **field width − left padding − right padding − gutter** whether or not the bar is showing. The gutter is `theme.components.scroller.gutter`, or the scroller `thickness` (default `12`) when that is unset. The Scroller's `spacing` gap is not added.
- The canvas height is the text's height plus top and bottom padding, and is never less than the field height. The text height is measured on a hidden copy of the text at the same wrap width, without any height limit (see Implementation notes), so the canvas updates on every change that alters the wrapped text. While the text fits, the canvas equals the window, so no bar shows. Text whose height plus padding is within 1 screen pixel of the window also counts as fitting, so `UIScale` rounding can't leave a 1px sliver of scrollbar. Once the text is taller than the field, the bar appears. Because the wrap width never depends on the bar, the bar doesn't flicker on and off around the boundary.
- Padding scrolls with the text, as in a browser textarea. The scrollbar spans the field's full height at its right edge.
- Clicking or tapping anywhere in the field focuses the `TextBox`, except in the gutter strip. On the text area, the `TextBox` takes the click and places the caret. On the left, top and right padding, the transparent `Canvas` button behind it takes the click and calls `CaptureFocus()`, so the caret goes wherever Roblox puts it on focus.
- The mouse wheel and touch drags scroll the field through the native `ScrollingFrame`. While the field is focused, the right thumbstick (`Thumbstick2`) also scrolls it, at up to 480px per second, with a 0.2 deadzone.
- **Caret follow:** while the field is focused, a change to the text or the caret position keeps the caret's line in view. If the canvas hasn't grown yet when that happens (a new line at the bottom), the follow completes once it has. The line is measured with a margin of the top padding above it and the bottom padding below it, so the first and last lines scroll fully into view with their padding. When that span is below the window, the field scrolls until its bottom sits at the window's bottom edge. When it is above, the field scrolls until its top sits at the top edge. Otherwise the scroll position doesn't change. A line taller than the window aligns to its top. `CanvasPosition` is only written when the caret line would leave the view. Scrolling with the wheel, a touch drag or the thumbstick never triggers caret follow, and it cancels a follow that is still waiting for the canvas, so the view stays where the user put it until the next keystroke or caret move.

## maxLength and counter

- `maxLength` counts Unicode code points (`utf8.len`; bytes for invalid UTF-8), not bytes or graphemes. An emoji made of several code points counts as several characters.
- When an edit made while focused (typing or pasting) would exceed the limit, the text is cut to the first `maxLength` code points and `onChange` reports only the cut text. The cut happens on a code-point boundary and never splits a character.
- `maxLength` doesn't rewrite a longer `value` set by the parent. That value is shown in full until the user edits it.
- `showCount` draws a right-aligned, single-line counter under the field. It shows the box's current length, grouped with commas: `"77"` without `maxLength`, `"77 / 1,500"` with it. It updates on every keystroke, also while focused. The separator is always `,`, whatever the locale.

## Fieldset integration

As on `Input`: activating the paired `Fieldset.Label` calls `CaptureFocus()` on the `TextBox`, unless `disabled` is set.

## Theme

- The field look is read from `theme.components.input`, not from a separate key, so a Textarea always matches the theme's Input: `typography`, `placeholder` (only `.color` applies), `backgroundColor`/`backgroundTransparency`, `backgroundImage`, `backgroundGradient`, `borderColor`/`borderThickness` (inner stroke), `cornerRadius`, `boxShadow`, `innerShadow`, and `states.hover`/`focus`/`disabled` with the same precedence. See [Input → Theme](./input.md#theme). `iconColor` isn't used.
- `theme.components.textarea` (optional) adds:
  - `rows?: number`: the default visible line count when neither `height` nor `rows` is set.
  - `counter?: Partial<TypographyStyle> | ScaledTypographyStyle`: the counter's typography, resolved at the component's `scale`. Its `.color` and `.transparency` colour the counter.
- Every shipped theme sets `rows: 4` and a muted counter colour: default `#8A8A8A`, dark `#697386`, sandstone `#8A7A61`, wooden `#FFF7CF`.
- The scrollbar uses `theme.components.scroller`, as every `Scroller` does.
- Padding resolves through the standard `spacing` padding cascade with no component tiers (like `Input`). The counter gap is the `xs` spacing value.
- Under `CleanUiProvider ignorePreferredTextSize`, the `TextBox` and the measuring labels (`TextMeasure`, `CaretProbe`, `LineProbe`) get a `PinTextSize` pin (see [Player text size](../index.md#player-text-size-preferredtextsize)). The counter is drawn by `Text`, which pins itself.

## Instance tree

- Root: a transparent `Frame` named `name ?? "Textarea"`, with an explicit height (see Size) and no `AutomaticSize`, carrying `AnchorPoint`, `Position`, `LayoutOrder`, `Visible`, `ZIndex` and the optional width `SizeConstraint`. With `showCount`, it also holds a vertical `UIListLayout` named `Layout`.
- `Field` (`ImageLabel`, `LayoutOrder` 1): the themed box, with `Stroke`, `Corners`, gradient and shadow decorators. It holds:
  - The Scroller, named `Scroller`. In the default theme that's the `ScrollingFrame` itself. With a scroller track or custom thumb in the theme, it's a `Frame` named `Scroller` with a `ScrollingFrame` inside, so find it with `FindFirstChildWhichIsA("ScrollingFrame", true)`. With `innerShadow` set, it sits inside a `Content` frame (ZIndex 2), next to `InnerShadow`, as on `Input`.
  - Inside the Scroller's `ScrollerContent`: `Canvas`, a transparent `TextButton` (no text, `AutoButtonColor` off, not selectable) whose height is the canvas height. Inside it, `TextBox` sits at `(left padding, top padding)`, is `100% − left − right padding` wide and `canvas − top padding` tall (plus one more canvas height in the Loom fallback, see Implementation notes), and has no `UIPadding`.
  - `Measure`: a 0x0 `Frame` with `Visible = false`, outside the Scroller. It holds three transparent, non-interactable `TextLabel`s, `TextMeasure`, `CaretProbe` and `LineProbe` (text `" "`), each the wrap width wide and 100000px tall.
- `Counter` (`Text`, `LayoutOrder` 2), only with `showCount`.
- The scrollbar shows exactly when the `ScrollingFrame`'s `AbsoluteCanvasSize.Y > AbsoluteWindowSize.Y`. `ScrollerContent`'s width stays the same whether or not it shows.

## Pure helpers

`src/Components/Input/Textarea.layout.ts` has no imports and touches no Roblox API, so tests can run it under Lune:

- `resolveTextareaHeight(height, rows, lineHeight, paddingTop, paddingBottom)`: the height precedence above, before min/max clamping.
- `resolveTextareaCanvasHeight(textHeight, paddingTop, paddingBottom, viewportHeight = 0, screenScale = 1)`: `textHeight + top + bottom`, or `viewportHeight` when that content is at most `viewportHeight + 1 / screenScale` (1 screen pixel, in design pixels). A NaN or infinite text height counts as `0`, and a non-positive `screenScale` counts as `1`.
- `resolveTextareaWholePixels(value)`: `max(0, ceil(value − 0.001))`. NaN and infinity count as `0`. The epsilon keeps a float like `125.0000001` at `125`.
- `resolveTextareaScreenScale(screenHeight, designHeight, fallback)`: the screen-to-design ratio. With `context = fallback > 0 ? fallback : 1`, it returns `context` when either height isn't positive, or when `screenHeight` is within 1px of `designHeight × context`. Otherwise it returns `screenHeight / designHeight`.
- `resolveTextareaWrapWidth(fieldWidth, paddingLeft, paddingRight, gutter)`: `max(0, fieldWidth − left − right − gutter)`. It takes no bar-visibility input.
- `resolveTextareaCaretScroll(caretTop, caretBottom, canvasY, viewportHeight)`: the caret-follow target Y.
- `resolveTextareaCaretText(text, cursorPosition)`: the text before the caret, or `undefined` when `cursorPosition < 1`. A space is appended when that text is empty or ends in a newline, so the measured text still has a line for the caret.
- `resolveTextareaCaretLineText(text, cursorPosition)`: `resolveTextareaCaretText` plus the rest of the caret's word (the bytes from `cursorPosition` up to, not including, the next ASCII whitespace byte, or the end of the text). Nothing is added when the caret is at the start of the text or of a line. Measuring this puts the caret on the line its word is drawn on. It is byte-safe, because a whitespace byte is never part of a multi-byte UTF-8 character. Returns `undefined` when `cursorPosition < 1`.
- `resolveTextareaLength(text)`, `trimTextareaText(text, maxLength?)`, `formatTextareaCount(length, maxLength?)`: the counting, trimming and counter formatting described above.
- `TEXTAREA_DEFAULT_ROWS` (`4`).

## Story

Worth demonstrating: the default (4 rows) with a placeholder, `rows={2}` and a pixel `height`, text long enough to scroll from the start, `maxLength` with `showCount` (e.g. `1500`), `disabled`, a `controlled` example that mirrors the value into a label, and the textarea inside a `Fieldset` whose label focuses it. Controls: `rows`, `maxLength`, `showCount`, `disabled`.

## Loom

A fixed-width container with one `Textarea` at `rows={4}`, pre-filled with enough text to show the scrollbar, and `showCount` with a `maxLength`.

## Implementation notes

- **Feedback loop avoided by design.** A hand-rolled textarea that showed its bar only on overflow reflowed its text when the bar appeared: the narrower text was taller, which changed the canvas, which hid the bar again. That made the bar flicker or never appear. Here, `stableGutter` reserves the gutter all the time and the Scroller's inset is always `None`, so the `TextBox` width never depends on the bar. Don't drop `stableGutter`, and don't size the `TextBox` from anything that depends on bar visibility.
- **Single canvas source.** Only `canvasHeight` sizes the canvas: `max(field height, textHeight + top padding + bottom padding)`, set as the explicit `Size` height of `Canvas`, the one child of `ScrollerContent`. `textHeight` (design px, state) comes only from `updateTextHeight`, which reads `TextMeasure`. The Scroller's `AutomaticCanvasSize.Y` only reflects that one explicitly sized child. Nothing sets `CanvasSize`, neither `Canvas` nor the `TextBox` has `AutomaticSize` (the original "grows and pushes its parent" bug), and the caret probes never feed it, so moving the caret can't change the canvas.
- **A wrapped label's `TextBounds` is capped by its own height.** It only covers the lines that fit. Consumer measurements of 40 short lines: height 0 gave 24, height 143 gave 124, and heights of 10k or 100k gave 1334.4. In this component, 40 lines in a `height={160}` Textarea reported (53, 118) on the `TextBox`, so the canvas never grew. The `TextBox`'s own bounds can't be used (that would also be circular, since its height is the canvas). `TextMeasure`, `CaretProbe` and `LineProbe` are `UDim2.fromOffset(wrapWidth, MEASURE_HEIGHT)`, with `MEASURE_HEIGHT` 100000. Text taller than that would be under-measured.
- **Why `Measure` is hidden.** `AutomaticSize` and `AutomaticCanvasSize` count every descendant's bounds and see through clipping frames, fixed-size frames and CanvasGroups. They do not see through a frame with `Visible = false`. Labels inside a hidden frame still update `TextBounds`: in Studio, `TextMeasure` reported 1000.8 at scale 1 under a hidden parent, and the root stayed at 160. The 100000px labels therefore sit in a hidden 0x0 `Measure` frame inside `Field`, outside the Scroller.
  - **Rejected: putting them directly in `Field`, or in a `ClipsDescendants` frame.** Both made the root 100000px tall.
  - **Rejected: portalling them under the nearest `LayerCollector`.** That was 2.5.0-dev. It worked, but it added a frame that a `UIListLayout` in the ScreenGui would lay out, and nothing was measured until the field had a `LayerCollector` ancestor.
- **Writing measurement text.** `TextMeasure.Text` and `CaretProbe.Text` are written imperatively, and React never sets them. That's needed because the `TextBox`'s `Text` prop is frozen while focused (the focus guard), so its live text has to be copied. `measureText` runs from `Change.Text` and from an effect on placeholder, wrap width, scale and typography changes. `TextMeasure`'s `Change.TextBounds` re-runs `updateTextHeight`. Nothing is measured while `wrapWidth` is `0`, which avoids a one-character-per-line canvas before the first layout.
- `wrapWidth` comes from `resolveTextareaWrapWidth`, using `Field`'s measured width in design px, minus padding and gutter. That is exactly the `TextBox`'s text area. The field size doesn't depend on the text, so this is not a loop.
- The canvas's lower bound is the computed field height (not a measured `AbsoluteWindowSize`). The Scroller fills the `Field`, so window and canvas come from the same number and are exactly equal while the text fits. The lower bound is what lets clicks below short text reach `Canvas`/`TextBox`.
- **Units: `TextBounds`, `CanvasPosition`, `AbsoluteCanvasSize` and `AbsoluteWindowSize` are all screen pixels under any ancestor `UIScale`, not only a `UiScaleRoot`.** The scale is taken from the component's own subtree: `resolveTextareaScreenScale(Field.AbsoluteSize.Y, fieldHeight, useUiScale())`, read live from `Field` in every callback (`currentScale`). This catches a plain `UIScale` that `useUiScale()` doesn't know about, and `useUiScale()` is used only before the first layout.
  - Measurements are divided by the scale before they size the canvas.
  - Caret-follow and gamepad scroll targets are worked out in design px and multiplied by the scale before `CanvasPosition` is written. The current `CanvasPosition` and the max scroll are divided by it when read.
- **Scale check in Studio** (40 lines, `height={160}`, default theme, 12px padding, a plain `UIScale` around the Textarea):

  | Scale | Field | `TextMeasure.TextBounds.Y` | `TextBox` height (design) | `AbsoluteCanvasSize.Y` | Window | Max `CanvasPosition.Y` | Caret at end scrolled to |
  | --- | --- | --- | --- | --- | --- | --- | --- |
  | 0.75 | 120 | 722.8 | 987 | 740.25 | 120 | 620.25 | 620.25 |
  | 1 | 160 | 1000.8 | 1024 | 1024 | 160 | 864 | 864 |
  | 1.5 | 240 | 1501.2 | 1024 | 1536 | 240 | 1296 | 1296 |

  - At 0.75 the engine renders text at a rounded size, so the text is shorter in design px (963.7 rather than 1000.8). The canvas follows the rendered text, which is the point of measuring.
  - At every scale the root stayed at the field height, and a user `CanvasPosition` of 40 design px (30, 40 and 60 screen px) stayed put while focused.
- **Caret follow, step by step.** `followCaret` runs on `Change.Text` and `Change.CursorPosition`. It writes the text before the caret into `CaretProbe`, sets `followRequested`, and calls `scrollToCaret`.
  - `scrollToCaret` also runs on `CaretProbe`'s `Change.TextBounds` and on the `ScrollingFrame`'s `AbsoluteCanvasSize` change, but only while `followRequested` is set. A hidden label's `TextBounds` isn't updated synchronously when its `Text` is set, and the canvas grows a frame after a new line, so the first attempt may see stale numbers.
  - `scrollToCaret` writes `CanvasPosition` only when `resolveTextareaCaretScroll` returns a different Y, and records the screen Y it wrote in `lastWrittenY`.
  - The Scroller's `onScroll` clears `followRequested` on any `CanvasPosition` change that isn't that write (a wheel, drag or thumbstick scroll), so a user scroll is never undone by a later canvas or bounds change.
  - The caret line height comes from `LineProbe` (`" "`), so it follows PreferredTextSize and font rounding.
  - All three labels must keep the `TextBox`'s `FontFace`, `FontSize`, `LineHeight`, `RichText` and text-size pin, or their wrapping won't match.
- **Gating on `IsFocused()`, not `focusedRef`.** Caret follow checks `textBox.IsFocused()`. In Studio, after `CaptureFocus()` the `CursorPosition` change can arrive before the `Focused` event handler has run, and gating on `focusedRef` dropped that follow.
- **Loom docs preview.** The vendored Loom renderer (`docs/public/loom-preview`) differs from Roblox in four ways that matter here:
  - It never writes `TextBounds` back to `TextLabel` instances, which stay `Vector2.zero`. It writes it only for a `TextBox`, unwrapped.
  - It writes `AbsoluteSize` back.
  - It treats `TextSize` as the line box: CSS font-size is `TextSize / ratio`, so a plain line is about `TextSize` tall.
  - It draws a `TextBox` as an absolutely positioned HTML `<textarea>` with `padding: 0` (a `UIPadding` inside it is ignored), no `line-height` (the theme's `LineHeight` is ignored), and the browser's default `overflow: auto`.
- **Not measured yet vs. never measures.** In Studio, `TextMeasure` can report `0` on the frames before its first layout. `updateTextHeight` then keeps the last `textHeight` (initially `0`, so the canvas is the window height) and starts a `Heartbeat` countdown of `FALLBACK_FRAMES` (3) frames.
  - If the bounds become non-zero in that time (normally through `Change.TextBounds`), the countdown is cancelled and the real height is used.
  - Only if the label still reports `0` for non-empty text after the countdown is the renderer treated as one that never measures. That sets `neverMeasures`, and later updates go straight to the estimate. Any non-zero reading clears it again.
  - Before 2.5.1, the estimate (and the `estimated` doubled `TextBox`) also kicked in on those first Studio frames.
  - Checked in Studio: the `TextBox` stays at `canvas − top padding` on every frame after mounting 40 lines. In headless Chrome, Loom still shows one bar and the same heights in all four themes on first render.
- **Loom fallback measurement.** When the countdown ends with `TextMeasure`'s bounds still `0` for non-empty text, `updateTextHeight` falls back to `TextService:GetTextSize(text, textSize, font, Vector2(wrapWidth, MEASURE_HEIGHT)).Y × FALLBACK_LINE_SLACK` (`1.17`) and sets `estimated`. Loom's `GetTextSize` wraps with a real canvas measurer and returns lines × `TextSize`. Studio doesn't reach this branch once its labels have laid out, so `estimated` stays `false` and the Studio path measures exactly.
  - **No `× lineHeight`.** The fallback multiplied by the theme `lineHeight` (1.4) until 2.5.0-dev. Loom's `<textarea>` ignores `LineHeight`, so the canvas came out about 7px per line too tall.
  - **The second bar can't appear while `estimated`.** The `<textarea>` only draws its own bar when its text is taller than the element. While `estimated` is set, the `TextBox` gets an extra `canvasHeight` of height below the canvas: `canvas − top padding + canvas`. It is transparent and top-aligned, and the `ScrollingFrame` clips everything below the canvas, so nothing shows. Loom sizes the canvas from `Canvas` (its child), not from the taller grandchild; in headless Chrome `ScrollerContent` stayed at `Canvas`'s height. Without `estimated` (always, in Studio) the `TextBox` is `canvas − top padding`, reaching the canvas bottom.
  - **The slack now only decides how far you can scroll.** Loom's `<textarea>` uses the browser's `normal` line height, which depends on the font. Measured line pitch per `TextSize` in headless Chrome: Roboto (default) about 1.056, Jura (dark) about 1.0, SourceSans (sandstone) about 1.17, PatrickHand (wooden) about 1.04. `1.17` covers every shipped theme, so the last line can always be scrolled into view, at the cost of some blank space under the text for fonts with tighter lines (about 80px under 40 Roboto lines). Before `estimated` existed, `1.06` was too small for SourceSans, and the Sandstone preview showed the native bar every time.
  - Loom gives the component nothing to read the font's real line height from: neither `GetTextSize` nor a label's `AbsoluteSize` includes the browser's line metrics. So the slack can't be derived per font.
  - **The fallback `setTextHeight` is deferred with `task.defer`.** In Loom, the first non-zero `Field` size arrives through `Change.AbsoluteSize` while the renderer is applying layout. The render that set the taller canvas was committed but never laid out again. Headless Chrome showed the `TextBox` stuck at 124.8 (window height) while React had rendered `canvas=200.4`, until any later flush (the user's scroll, which writes `CanvasPosition`) applied it. Deferring the state update lets the renderer schedule a new flush, and the first render is correct. Studio is unaffected, because the fallback branch never runs there.
  - Caret follow does nothing in Loom, because the probes report no bounds.
  - The proper fix belongs in the renderer: `overflow: hidden` and `line-height` on a `<textarea>` inside a `ScrollingFrame`, honouring `UIPadding`, writing `TextBounds` back to labels, and flushing commits made during a flush.
- **Padding is a position, not a `UIPadding`.** Loom ignores a `UIPadding` inside a `TextBox`, so the text touched the border there. The `TextBox` now sits at `(left, top)` inside `Canvas`, `left + right` padding narrower than it.
  - In Studio this is pixel-identical: text inset 12,12 in the default theme, wrap width `field − padding − gutter`, canvas `text + top + bottom padding`, and caret-follow targets unchanged. In Studio, caret follow at the end still reaches exactly the max scroll.
  - `Canvas` is a `TextButton` rather than a `Frame`, so clicks on the padding still focus the box.
  - No pure helper changed.
- **Root height is explicit (story gap).** In the story (`Container` > `VStack`), a `height={120}` Textarea with long text was 394px tall: its root had `AutomaticSize.Y`, which picked up the canvas-sized `TextBox` through the fixed `Field` and the `ScrollingFrame`, and the parent's list layout spaced the next item by that height. The root now has an explicit height and no `AutomaticSize`.
  - In Studio, a `Container`/`VStack` parent and a plain `AutomaticSize.Y` parent both kept the same height for empty and 493-byte text: 180 and 149 with `showCount`.
  - The `Counter` is sized explicitly to one line (`AutomaticSize.None`). Under an unpinned PreferredTextSize, its text can be taller than that line and draws over the space below rather than resizing anything.
  - Scroller gives its `ScrollingFrame` `AutomaticSize.X` when no width is set. Setting it to `None` here made no difference, so it was left alone.
- **Whole pixels everywhere.** `UDim.Offset` is an integer, so a fractional offset is truncated when rendered. With `rows={4}` in the default theme, `fieldHeight` was 4 × 25.2 + 24 = 124.8, but `Field` rendered 124 tall. The scale then came out 124 / 124.8 ≈ 0.9936, which inflated every measured height by about 0.64%. The measuring labels were also 265 wide against a 264px text area, so a line 264–265px wide was measured as one line fewer than it draws.
  - **Rounding up:** `fieldHeight`, `counterHeight`, the counter gap and `canvasHeight` all go through `resolveTextareaWholePixels` before they are rendered or used in any calculation, so rendered and computed sizes always agree. The root height is the sum of these whole numbers. `rows` promises that many visible lines, and rounding up never cuts the last line or the counter's text by a fraction of a pixel; the extra under 1px falls into the bottom padding. With `rows={4}`: field 125, root with `showCount` 125 + 4 + 26 = 155.
  - **Label width from the TextBox:** `wrapWidth` (the `Size` width of `TextMeasure`, `CaretProbe` and `LineProbe`) comes from the `TextBox`'s own rendered width, `round(TextBox.AbsoluteSize.X / scale)`, tracked from its `Change.AbsoluteSize` (`screenTextBoxWidth`). The `TextBox` width depends only on the field width, never on the text. Before the `TextBox` has laid out, `resolveTextareaWrapWidth(floor(field width / scale), …)` is used.
  - **Scale tolerance:** `resolveTextareaScreenScale` ignores a difference of up to 1px from the context scale, as a further guard against truncation.
  - **Studio, default theme, `rows={4}`:** field 125 (offset 125), scale exactly 1, and `TextMeasure`/`CaretProbe` widths equal to the `TextBox` width at host widths 300, 301 and 289 (264, 265, 253).
- **Redraw nudge for script-set text.** Roblox sometimes draws nothing in a multi-line `TextBox` inside a `ScrollingFrame` when about 20 or more lines are set while it is unfocused, until the box is next touched (scrolled, resized by 1px, edited). This reproduces on a bare `TextBox` with no React, and typing or pasting while focused is fine.
  - **Trigger:** after any value change while unfocused (the mount value, a controlled `value` change, or the sync after blur), an effect keyed on `[focused, sourceText]` calls `nudgeTextBox` once per distinct source text (`nudgedSource`).
  - **What it does:** on the next `Heartbeat` it shrinks the `TextBox`'s `Size` height by 1px, and on the following `Heartbeat` restores it to the size React last rendered (`textBoxSizeRef`, not the size it saved, in case React resized it in between).
  - **No side effects:** shrinking never moves the canvas bottom, which is `Canvas`'s height, so the canvas and `CanvasPosition` don't change. A `Size` write fires no `Text` or `CursorPosition` change, so there is no `onChange`, `maxLength` trim or caret follow.
  - **Studio check (40 lines):** `TextBox` height went 1012 → 1011 → 1012 with the canvas fixed at 1024. A user `CanvasPosition` of 100 stayed at 100 through a controlled update. `onChange` didn't fire on mount. The update fired `onChange` once, but that is the existing echo from React writing `Text` (as on `Input`), not the nudge. A 795-byte value with `maxLength={100}` was not trimmed.
  - **Not detectable by property:** `TextBounds`, `TextFits` and `AbsoluteSize` read normally while the box draws blank. On a bare `TextBox`, `TextBounds` was 93×480 and `TextFits` `true` straight after setting 40 lines. So the blank state itself can't be detected by property, and the fix was checked by its side effects, not visually.
  - Pending nudge and fallback connections are disconnected on unmount.
- **Touch drag over `Canvas`.** `Canvas` is a `TextButton` covering the canvas. It is left as is: a `ScrollingFrame` takes over a touch that starts on a child button and moves, and the button's press is cancelled instead of firing `Activated`, which is the normal list-of-buttons case in Roblox. The `TextBox` on top behaves the same way. Checked 2026-11-25 in Studio's device simulator (iPhone 17 Pro, play mode, simulated touch). The check used a plain-Roblox copy of this structure: a 300x200 `ScrollingFrame`, a full-canvas `Canvas` button, and a `TextBox` inset by 12 px. A drag starting on the text scrolled 71 px. A drag starting in the padding, where only `Canvas` is under the finger, scrolled 68 px. Neither fired `Activated` nor focused the box. A tap on the text focused the `TextBox`, and a tap in the padding fired `Canvas.Activated`.
- **CursorPosition is a byte offset.** `CursorPosition` is a 1-based UTF-8 byte index and always falls on a code-point boundary. So `string.sub(text, 1, CursorPosition - 1)` (`resolveTextareaCaretText`) is exactly the text before the caret, and is valid UTF-8. Don't convert it to a character count first, or the slice will be wrong for any multi-byte text.
- **Caret line = the caret's whole word.** `CaretProbe` measures `resolveTextareaCaretLineText`: the text before the caret plus the rest of the caret's word. Measuring only up to the caret put a caret in the middle of a word that wraps on the line above, and caret follow stopped one line short until the next keystroke.
  - Remaining limit: a single word longer than the wrap width is broken across lines by the engine, and the caret inside it is measured at the word's last line.
  - With `RichText`, `CursorPosition` counts markup bytes too, so the measured text can include half a tag.
- **maxLength** is enforced in `Change.Text` only while `focusedRef` is set (the `Focused` event has run), so a programmatic value (the unfocused sync, a parent's value) is never cut. When the text is cut, the handler writes the cut text and returns. The write fires `Change.Text` again with text within the limit, which is the one reported. `utf8.len`/`utf8.offset` are called through single-return casts, for the same Loom-runtime reason as `TextHelper.utf8Length` (see [shared-modules.md](../../../architecture/shared-modules.md#srchelperstexthelperts)).
- The `AbsoluteCanvasSize` connection used for caret follow re-subscribes when the `ScrollingFrame` can remount: `innerShadow` toggled, or the Scroller switching to its decorated tree. It calls `scrollToCaret` through `scrollToCaretRef`, so it always sees the latest padding and scale.
- Gamepad scrolling reads `Thumbstick2` from `CustomInputService.InputChanged` (so it works in ui-labs stories), and moves `CanvasPosition` on `Heartbeat`, only while the field is focused. The left stick is left alone, because console on-screen keyboards use it.
- The root is always a wrapper `Frame` (unlike `Input`, whose root is the themed `ImageLabel`), so the tree doesn't change shape when `showCount` toggles. For the same reason, min/max height clamp the computed field height, and only min/max width go into `SizeConstraint`: the root's height is derived from the field height, so a separate height constraint on it would only fight that value.
- `height` accepts pixels only. A `%` height on `Field` would be relative to the auto-sized root, which is circular.
