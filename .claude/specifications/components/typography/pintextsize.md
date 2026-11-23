# PinTextSize

`PinTextSize` fixes a native text instance's size so Roblox's player Text Size setting (`GuiService.PreferredTextSize`) can't enlarge it. It is for a game's own `textlabel`/`textbox`/`textbutton` elements; library components pin their own text (see [Player text size](../index.md#player-text-size-preferredtextsize)). It follows the shared conventions in [Components](../index.md).

## Public API

- `PinTextSizeProps`: `size?: number` (the element's `TextSize`, in design pixels), `enabled?: boolean` (default `true`).
- Renders one `UITextSizeConstraint` named `PinTextSize`, a direct child of the text element, with `MinTextSize = MaxTextSize = size × useUiScale()` (see [UiScaleRoot](../layout/uiscaleroot.md); nested roots multiply). `size` is first clamped to `1`-`100` like `TextSize` itself, and the result is raised to at least `1`. Place it as a child of the text element and pass the same value as its `TextSize`. It re-renders when the effective scale changes. With no root (scale `1`) the pin is `size` clamped to `1`-`100`, as in 2.4.0.
- **Cap:** when the clamped `size × scale` is greater than `100` (Roblox's `UITextSizeConstraint` limit), nothing is rendered, so the text renders at its full scaled size and the player's Text Size setting can affect it. Exactly `100` is still pinned.
- Renders nothing when `size` is `undefined` or `enabled` is `false`. It does not read `ignorePreferredTextSize` itself; gate it with `enabled={useIgnorePreferredTextSize()}` to follow the provider switch.
- Don't use it on `TextScaled` text: it would fix the scaled size too.
- It only knows about `UiScaleRoot` scaling. A caller's own `UIScale` above the element is not included, so the pin would hold the text at the pre-`UIScale` size there.
- `useIgnorePreferredTextSize(): boolean` returns `CleanUiProvider`'s `ignorePreferredTextSize` (`false` with no provider).

## Story

- A `CleanUiProvider` with an `ignorePreferredTextSize` toggle around a few library components (Text, Button, Input), next to a native `textlabel` with `<PinTextSize size={...} enabled={useIgnorePreferredTextSize()} />`. Changing Studio's Text Size accessibility setting enlarges the text only while the toggle is off.

## Loom

- One native `textlabel` with a `PinTextSize` child of the same size.

## Implementation notes

- Roblox has no global opt-out from `PreferredTextSize`; a child `UITextSizeConstraint` with equal min and max is the documented per-element one.
- `MinTextSize`/`MaxTextSize` clamp the final rendered text size, which Roblox computes after every ancestor `UIScale`. They are screen pixels, not `TextSize`'s design pixels. 2.4.0 pinned the design size, so under `UiScaleRoot scale={3}` a 20 px label rendered at 20 px while its box grew to 3x. The pin is therefore `toScreenTextSize(size, useUiScale())` (`src/Helpers/uiscale.helper.ts`). `useUiScale()` is the product of every root above the element, and portalled content keeps the portalling component's scale while `OverlayScaleFrame` makes the rendered scale match, so it is the right factor in overlays too. `useUiScale()` is called before the early returns so the hook order is fixed.
- Cap choice: above `100` screen pixels the pin is omitted. Rejected alternatives: pinning at `100` shrinks the text below its scaled size (the original bug); `TextScaled` in a sized box changes the element's sizing (it no longer auto-sizes from its text) and needs a box whose size the library controls, which `PinTextSize` doesn't have. Omitting gives the correct size at the cost of letting `PreferredTextSize` act on that one element, and such text is already very large.
- The design size is clamped to `1`-`100` before multiplying because `TextSize` itself is clamped to that range. That keeps a scale-`1` pin of e.g. `120` at `100`, exactly as 2.4.0 did, instead of omitting it.
- The pin overrides RichText `<font size="...">` markup in the element's text: every run renders at the pinned size.
