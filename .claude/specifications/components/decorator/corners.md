# Corners

`Corners` renders a Roblox corner-rounding instance (`UICorner`) from a single size value. It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts a single `radius` prop using the library's shared CSS-style size type (e.g. a pixel number or percentage string).
- Renders nothing when `radius` is `undefined`, so a component can pass a possibly-unset theme radius straight through without an extra guard.
- When set, the corner radius is resolved through the shared size-resolution helper used elsewhere in the library, not applied as a raw pixel value.
