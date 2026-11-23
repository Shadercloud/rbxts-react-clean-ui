# PinTextSize

`PinTextSize` fixes a native text instance's size so Roblox's player Text Size setting (`GuiService.PreferredTextSize`) can't enlarge it. It is for a game's own `textlabel`/`textbox`/`textbutton` elements; library components pin their own text (see [Player text size](../index.md#player-text-size-preferredtextsize)). It follows the shared conventions in [Components](../index.md).

## Public API

- `PinTextSizeProps`: `size?: number` (the element's `TextSize`, in pixels), `enabled?: boolean` (default `true`).
- Renders one `UITextSizeConstraint` named `PinTextSize` with `MinTextSize = MaxTextSize = size` (clamped to Roblox's `1`-`100`). Place it as a child of the text element and pass the same value as its `TextSize`.
- Renders nothing when `size` is `undefined` or `enabled` is `false`. It does not read `ignorePreferredTextSize` itself; gate it with `enabled={useIgnorePreferredTextSize()}` to follow the provider switch.
- Don't use it on `TextScaled` text: it would fix the scaled size too.
- `useIgnorePreferredTextSize(): boolean` returns `CleanUiProvider`'s `ignorePreferredTextSize` (`false` with no provider).

## Story

- A `CleanUiProvider` with an `ignorePreferredTextSize` toggle around a few library components (Text, Button, Input), next to a native `textlabel` with `<PinTextSize size={...} enabled={useIgnorePreferredTextSize()} />`. Changing Studio's Text Size accessibility setting enlarges the text only while the toggle is off.

## Loom

- One native `textlabel` with a `PinTextSize` child of the same size.

## Implementation notes

- Roblox has no global opt-out from `PreferredTextSize`; a child `UITextSizeConstraint` with equal min and max is the documented per-element one. It is in the same pixels as `TextSize`, so under a `UiScaleRoot` the pinned value is the design size and the `UIScale` still scales it.
- The pin overrides RichText `<font size="...">` markup in the element's text: every run renders at the pinned size.
