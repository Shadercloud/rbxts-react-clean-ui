# Padding

`Padding` renders a Roblox padding instance (`UIPadding`) resolved from the shared padding/spacing prop set. It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts the shared padding props: a `spacing` scale value, individual `top`/`bottom`/`left`/`right` scale overrides, a CSS-style `padding` shorthand, and a pre-resolved `resolvedPadding` (exact pixel values per side).
- When `resolvedPadding` is supplied, it is used directly and no other padding prop is consulted.
- Otherwise, per-side pixel padding is resolved via the shared tiered [padding resolution](../index.md#padding-resolution) — `Padding` itself only ever exercises tiers 1 (global spacing) and 4 (inline props); the component- level tiers 2/3 (`theme.components.<name>.spacing`/`.padding`) are resolved by the calling component (e.g. `Box`, `Card`, `Checkbox`, `Tabs`, `Accordion`) before being handed to `Padding` as a pre-resolved `resolvedPadding`, not by `Padding` reading `theme.components.<name>` itself.
- Always renders a `UIPadding` (with resolved per-side pixel values, defaulting to `0` on any side without an applicable value) — it does not omit itself when padding resolves to zero.
