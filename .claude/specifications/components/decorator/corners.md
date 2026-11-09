# Corners

`Corners` renders a Roblox corner-rounding instance (`UICorner`) from a single size value. It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts a single `radius?: CssRadius` prop: either the library's shared CSS-style size (`CssSize`, e.g. a pixel number or percentage string) or a theme radius token, `"sm"`, `"md"` or `"lg"`, which resolves to that entry of the active theme's `radius` scale (`theme.radius.sm` etc., in pixels). See [Components](../index.md#theming) for radius tokens across the library.
- Renders nothing when `radius` is `undefined`, so a component can pass a possibly-unset theme radius straight through without an extra guard.
- A radius (or token) that resolves to `0` also renders nothing.
- When set, the corner radius is resolved through the shared size-resolution helper used elsewhere in the library, not applied as a raw pixel value.

## Implementation notes

- `Corners` reads `CleanThemeContext` before its early returns so the hook order is stable, and resolves tokens with `SizeHelper.toRadius(theme, radius)`. Every component that passes a theme `cornerRadius` through `Corners` gets token support from this one place.
