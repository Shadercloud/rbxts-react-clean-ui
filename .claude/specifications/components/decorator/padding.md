# Padding

`Padding` renders a Roblox padding instance (`UIPadding`) resolved from the shared padding/spacing prop set. It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts the shared padding props: a `spacing` scale value, individual `top`/`bottom`/`left`/`right` scale overrides, a CSS-style `padding` shorthand, and a pre-resolved `resolvedPadding` (exact pixel values per side).
- When `resolvedPadding` is supplied, it is used directly and no other padding prop is consulted.
- Otherwise, per-side pixel padding is resolved from the theme's spacing scale combined with whichever of `spacing`/`top`/`bottom`/`left`/`right`/`padding` the caller supplied, using the same spacing-resolution rules other components use for padding.
- Always renders a `UIPadding` (with resolved per-side pixel values, defaulting to `0` on any side without an applicable value) — it does not omit itself when padding resolves to zero.
