# Pie Chart

`Pie` displays proportional values as segments of a circle, with optional per-segment labels, hover highlighting, and click selection. It follows the shared requirements in [Charts](./index.md) and the general conventions in [Components](../index.md).

## Public API

- The component accepts a single required `values: PieValue[]` prop (via `PieProps`), plus `label-distance?`, `label-hover?`, `Label-hidden?`, `label-spacing?`, `hover-darken?`, `onChangeSelected?`, and `onClick?`.
- `PieValue`: `value: number`, `color?: Color3`, `label?: string | PieLabel`.
- `PieLabel`: `text?: string`, `spacing?: ScaleSize | "None"`, `content?: React.ReactNode`, `BackgroundColor3?: Color3`, `BorderColor3?: Color3`.
- `PieProps`, `PieValue`, and `PieLabel` are declared in `Pie.tsx` but are **not exported**, even though `PieProps` is the component's public prop type. This is a gap against the [Charts](./index.md) convention that chart-specific interfaces forming part of a chart's public API should be exported — consumers currently cannot name these types directly when authoring typed `values` arrays outside the same module.
- The hide-all-labels prop is named `Label-hidden` (capital `L`) in the implementation, not `label-hidden` as shown in the component's `.mdx` documentation. Treat `Label-hidden` as the actual prop name when specifying or testing behavior; the lowercase `label-hidden` used in docs does not exist on the type and has no effect.

## Segments

- Segment order follows `values` array order, laid out clockwise starting at 12 o'clock (`Top`).
- Each value's share of the circle is `value / totalValue` where `totalValue` is the sum of all `values[].value`. If `totalValue` is `0` (e.g. an empty array or all-zero values), the resulting proportions are `NaN` — the component has no explicit guard for this empty/zero-total case, and its rendered output in that situation is not well-defined.
- Segments are rendered as a sequence of half-circle radial-gradient masks (one per `Top`/`Bottom` half in use), splitting a single value's wedge across the `Top`/`Bottom` boundary when it doesn't fit within the remaining space of the current half. This is an implementation detail of how proportions become masked colored discs, not a data-facing behavior.
- Without an explicit `color`, a segment uses `theme.components.charts.colors[index % colors.size()]` (the same shared chart palette [Charts](./index.md) describes for other chart types).
- The disc is clipped to a circle via a full corner radius on the outer frame; there is no square/other outer shape option.

## Hover and selection

- Hovering the pie's circular area computes the pointer's angle from center (adjusted for `GuiService`'s inset) and maps it to a normalized position around the circle, then walks `values` in order accumulating percentages to find which segment contains that position; pointer positions outside the inscribed circle (`min(width, height) / 2`) clear the hover.
- The hovered segment's color is darkened (or lightened, if `hover-darken` is negative) by `Lerp`-ing toward black or white by `abs(hover-darken)`. `hover-darken` defaults to `0.2` when omitted. `theme.components.charts.pie.hoverDarken` is declared in the theme shape but is **not read** by the component — there is currently no way to change this default via the theme, only via the `hover-darken` prop per-instance.
- `onChangeSelected(index, value)` fires whenever the hovered index changes (including transitions to no hover, where `index` is `-1` and `value` is `undefined`); it does not fire repeatedly while hovering the same segment.
- `onClick(index, value)` fires on `InputEnded` for `MouseButton1` (i.e. on release) while a segment is currently hovered; releasing outside any segment does not fire it.
- Mouse leaving the whole chart clears the hover the same way as moving outside the inscribed circle.

## Labels

- A value renders a label only when `label` is set, `Label-hidden` is not `true`, and (if `label-hover` is `true`) only while that value's segment is the hovered one.
- Label position is the angular midpoint of the segment's wedge, at a radius of `label-distance` (default `0.3`, range conceptually `0`–`1`) from center — except when there is exactly one value, in which case its label is centered.
- A `string` label, or a `PieLabel` with `text` set, renders as a themed pill: background/border/typography/corner radius/padding each individually overridable per-label (`BackgroundColor3`, `BorderColor3`, `spacing`) and otherwise falling back to `theme.components.charts.pie.labels.*`, which in turn falls back further to the corresponding `theme.components.box.*` value where the pie-label theme field is `undefined`.
- If a `PieLabel` has both `text` and `content` set, `text` takes precedence and `content` is ignored — the label is never rendered as a hybrid.
- A `PieLabel` with only `content` set (no `text`) renders that content directly inside a transparent, auto-sized, centered frame at the computed position, with no background/border/padding/typography applied by `Pie` itself.

## Theme

Pie defaults live under `theme.components.charts.pie`:

- `boxShadow` (`CssBoxShadow`, not the general `CssShadow` most other components use) — an optional shadow around the entire disc. When present, extra padding is reserved around the whole chart so the shadow is not clipped.
- `hoverDarken` — declared but currently unused; see above.
- `labels.spacing`, `labels.backgroundColor`, `labels.backgroundTransparency`, `labels.typography`, `labels.borderColor`, `labels.borderThickness`, `labels.cornerRadius` — each falls back to the equivalent `theme.components.box.*` value when undefined (except `spacing` and `typography`, which have no such box fallback and instead fall back to the shared spacing/typography helpers' own defaults).

## Layout

- The chart fills its parent per the shared chart layout specification ([Charts](./index.md)).
- Unlike `BarChart`, `Pie` has no theme-driven tween/animation — segments and labels appear immediately with no grow-in or fade effect.

## Story

A story should demonstrate: string labels, a custom-styled `PieLabel` (background/border override), a `PieLabel` using `content` for fully custom React content, `label-hover` (labels appearing only on hover), and the `onChangeSelected`/`onClick` callbacks. Do not rely on the documented `label-hidden` prop name — use `Label-hidden` to match the actual implementation.
