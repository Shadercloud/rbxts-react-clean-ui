# BoxShadow

`BoxShadow` renders a Roblox drop-shadow instance (`UIShadow`) from either a CSS-style shadow value or a fully-specified shadow object. It follows the shared conventions in [Components](../index.md).

## Public API

- Accepts a `completeShadow` prop (offset, blur radius, spread, color, and transparency all specified together). When present, it fully determines the rendered shadow and no other prop is consulted.
- Without `completeShadow`, it accepts a CSS-style shadow shorthand via either a `box-shadow` prop or a `value` prop (`box-shadow` takes precedence). This shorthand is parsed into offset/blur/spread the same way box-shadow theme values are parsed elsewhere in the library.
- `color` and `transparency` props override the shadow's color and transparency; without them it falls back to `theme.components.boxShadow.color`/`.transparency`.
- Accepts an optional `zindex` prop, defaulting to `-1` so the shadow renders behind sibling content.
- Renders nothing if no shadow value is available (no `completeShadow`, and no usable `box-shadow`/`value`) or if the shorthand fails to parse.
