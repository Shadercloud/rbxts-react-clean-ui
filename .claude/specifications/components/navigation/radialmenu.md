# RadialMenu

`RadialMenu` is a donut-shaped selection ring: its items sit evenly spaced around the ring, the selected item's wedge of the ring is filled with the accent colour, and the centre of the donut shows the selected item's icon, title and description. It follows the shared conventions in [Components](../index.md).

## Public API

- `RadialMenuProps` (extends `ScalableElementProps`, `ZIndexElementProps`, and `Position`/`AnchorPoint` from `PositionElementProps`):
  - `items: RadialMenuItem[]` (required). Order is clockwise from 12 o'clock.
  - `value?: string`: switches to controlled mode (see Selection).
  - `defaultValue?: string`: initial selection in uncontrolled mode. Omitted means nothing is selected.
  - `onValueChange?: (value: string, item: RadialMenuItem) => void`.
  - `size?: CssSize`: the diameter (default `theme.components.radialMenu.size`). A `%` size is a fraction of the parent's width. The menu stays square either way.
  - `thickness?: CssSize`: the ring's thickness (default `theme.components.radialMenu.thickness`). A `%` is a fraction of the menu's **radius**, so `"36%"` scales with `size`. A pixel value stays fixed.
  - `showLabels?: boolean` (default `false`): also shows each item's `text` under its icon on the ring. The ring is icon-only by default.
  - `placeholder?: RadialMenuPlaceholder`: what the centre shows when nothing is selected.
  - `scale`: sizes the ring icons (falling back to `theme.components.radialMenu.iconScale`, then `theme.default.scale`) and the centre/label typography.
  - `LayoutOrder?`, `ZIndex?`, `Position?`, `AnchorPoint?`: applied to the root frame. `name?` names the root instance (default `"RadialMenu"`).
- `RadialMenuItem` (extends `IconElementProps`): `value: string` (required, the stable identifier), `icon?: IconName`, `text?: string`, `description?: string`.
- `RadialMenuPlaceholder` (extends `IconElementProps`): `icon?`, `text?`, `description?`.
- `RadialMenu`, `RadialMenuProps`, `RadialMenuItem` and `RadialMenuPlaceholder` are exported through the Navigation barrel. `RadialMenu` forwards a ref to its root `Frame`. It has no sub-parts.

## Selection

- This follows the `Tabs` model. When `value` is not `undefined`, the menu is controlled: the displayed selection is always `value`, and a click only calls `onValueChange`. Otherwise the menu keeps its own selection, seeded from `defaultValue`, and a click selects the item and then calls `onValueChange`.
- `onValueChange` fires on every activating click, including a click on the item that is already selected. It never fires on mount.
- A `value`/`defaultValue` that matches no item means nothing is selected. When two items share a `value`, the first one matches.
- Activation is a primary mouse button release (`MouseButton1`) or a touch release over a segment. The segment is the one under the release point, not the press point.
- There is no disabled state, and no keyboard or gamepad navigation.

## Hit-testing

- Segments are hit-tested by angle and distance from the centre, not by rectangles. A point belongs to a segment when its distance from the centre is between the inner radius and the outer radius (inclusive). The segment is the one whose angular range contains the point's angle, measured clockwise from 12 o'clock. Item `i` of `n` is centred at `i * 360/n` degrees and spans half a step on either side, so item 0's wedge straddles 12 o'clock.
- Points in the centre hole or outside the ring hit nothing. Moving the pointer there clears the hover, and releasing there selects nothing.

## Visuals

- Layers, bottom to top: the full ring disc (`Ring`), the hover wedge (`HoverWedge`, present only while an unselected segment is hovered), the selected wedge (`SelectedWedge`, hidden when nothing is selected), the centre disc (`Center`), the item icons/labels (`Items`), and a transparent `HitArea` that receives input.
- Segment colours come from `ColorHelper.getIntentColors(theme, "primary", state, theme.components.radialMenu.intents)`, always resolved against `"primary"` (there is no `intent` prop, as with `Tabs`). `default` is the ring's fill and each idle icon's colour. `hover` is the hover wedge and the hovered icon. `focus` is the selected wedge and the selected icon. `backgroundColor` fills the region, `backgroundTransparency` sets its transparency, and `textColor` colours the icon and label.
- Each item's icon (and its label, when `showLabels` is set and `text` is non-empty) is centred at mid-thickness of the ring at the item's angle. Icons are not rotated. Labels use the next scale down from `scale`.
- The centre disc's diameter is the menu's diameter minus twice the thickness. Its content box is 75% of the disc and stacks the following vertically, centred both ways, `center.gap` px apart:
  - `CenterIcon`: the selected item's `icon`, sized `center.iconSize` px and coloured `center.iconColor` (fallback: the theme's primary text colour).
  - `CenterTitle`: the item's `text`, wrapped and centred, at `scale`.
  - `CenterDescription`: the item's `description`, wrapped and centred, one scale down.
- With nothing selected, the centre shows `placeholder`'s fields the same way. An omitted field (or empty text) renders no instance, so with no selection and no placeholder the centre is empty.

## Animation

- When the selection moves from one item to another, the selected wedge rotates to the new item along the shortest arc, over `theme.components.radialMenu.animation.duration` seconds. A `duration` of `0` jumps instead. If the selection changes again mid-rotation, the wedge continues from its current angle.
- Going from no selection to a selection snaps the wedge into place without rotating. Item icon colours switch immediately and are not tweened.

## Theme

Defaults live under `theme.components.radialMenu`:

- `size` (`CssSize`) and `thickness` (`CssSize`, `%` of radius): the diameter and ring thickness defaults.
- `iconScale?` (`ScaleSize`): the scale of the ring icons when no `scale` prop is set.
- `intents?`: the per-state segment schemes, as described under Visuals. Every shipped theme sets `primary.default`/`hover`/`focus`.
- `labels.typography?`: the ring label typography, layered on the scale's typography.
- `center.backgroundColor`, `center.backgroundTransparency`, `center.iconSize` (px), `center.iconColor?`, `center.gap?` (px, default `0`), `center.title.typography?`, `center.description.typography?`. A typography `color` overrides the text colour.
- `animation.duration` (seconds; `0` disables the rotation tween).

## Layout

- The root is a square `Frame` (`UIAspectRatioConstraint` `1`) of the resolved `size`. It does not fill its parent, and it doesn't auto-size to content.
- The centre text wraps within the centre content box. Very long titles can overflow the disc vertically. Nothing clips them.

## Story

A story should demonstrate:

- An eight-item icon menu like the concept: airplane, bluetooth, location, volume, brightness, phone, message and wifi, with `text`/`description`, and a placeholder (e.g. a gear, "System Settings" and "Radial Menu") shown before anything is selected.
- Selection in both uncontrolled (`defaultValue`) and controlled (`value` + `onValueChange`) modes.
- `showLabels`, and different `size`/`thickness` values.
- Small item counts (2 and 3) to show the wedge geometry.

A Loom scene can be a single uncontrolled menu with a handful of items and a placeholder.

## Implementation notes

- **Wedge rendering (`RadialMenuWedge`).** This uses `Pie`'s half-circle technique: a full disc (`UICorner` 0.5) whose `UIGradient` transparency hides one half, clipped to the right half of the menu. Opaque at gradient rotation 0 is the right half (clockwise 0 to 180 degrees from 12 o'clock), so `Rotation = sweep - 180` leaves exactly clockwise `[0, sweep]` inside the right-half clip. The wedge's start angle comes from rotating a full-size parent `Frame`. Because Roblox `ClipsDescendants` stops working once an ancestor is rotated, the half-clip has to be a `CanvasGroup`. A rotated `CanvasGroup` still clips its content, the same trick `RoactRadial` uses. Don't replace it with a clipping `Frame`.
- **The `Clip` `CanvasGroup` also sets `ClipsDescendants`.** In Roblox it changes nothing, because a `CanvasGroup` clips to its bounds anyway. The Loom web renderer (`@loom-dev/renderer`) doesn't model that implicit clip: it only emits `overflow: hidden` for a `ScrollingFrame` or a node with `ClipsDescendants = true`. Without the flag, the double-width `Fill` spills into the left half in the docs preview, and every wedge (hover and selected) draws as the gradient's opaque half-disc, 180 degrees wide, instead of a `step`-wide slice. CSS `overflow: hidden` still clips under a CSS-rotated ancestor, so this one flag fixes the preview. Loom does render the `UIGradient` mask, `UICorner` and nested `Rotation` faithfully: the mask's hard edge at time 0.5 always passes through the box centre. Its input `Position` and `AbsolutePosition` share the mount-relative pixel space, so hit-testing needs no Loom-specific path either. Don't remove the flag as redundant.
- `RadialMenuWedge` handles only `sweep <= 180` (any count of 2 or more) and `sweep >= 360` (one item, a plain full disc). Sweeps between 180 and 360 can't occur with equal segments, so they aren't handled.
- `Pie`'s own `Segment` wasn't reused directly. It's module-private, and it relies on later segments painting over earlier ones within a half, which can't draw an isolated wedge on top of an arbitrary ring.
- `SelectedWedge` is a full-size `Frame` whose `Rotation` is the `useTween` binding, with the wedge itself fixed at `-step/2` inside it, so rotating the parent moves the whole wedge. `goalRef` holds the unwrapped goal angle, and each new goal is `previous + shortest delta` (computed with `wrapDegrees`, which uses `math.floor`, not `%`, so it never depends on TS-vs-Luau modulo sign semantics). That keeps the tween from spinning the long way around when it crosses 0/360 degrees.
- The ring and the centre are sized in scale/offset (`thickness.Scale` is a fraction of the radius, so the inner diameter is `UDim2(1 - s, -2o, 1 - s, -2o)`). Item positions are built the same way, which avoids measuring `AbsoluteSize` to lay anything out. Only hit-testing reads `AbsoluteSize`/`AbsolutePosition`, at event time.
- **Hit-testing** compares `InputObject.Position` with the `HitArea`'s `AbsolutePosition` directly, the same as `Slider`/`Draggable`. It assumes the usual alignment between those two spaces, so under a `ScreenGui` whose inset handling makes them disagree, hits shift by the inset, as they would in those components. `math.atan2(dx, -dy)` gives the clockwise angle from 12 o'clock in screen space (y grows downward).
- Hover can't use the shared `HoverButton` primitive, because segments aren't rectangles. Hover comes from the `HitArea`'s `InputChanged` (mouse movement and touch) and is cleared on `MouseLeave` and on touch release.
- The layers' `ZIndex` values (1 to 6) are sibling-relative. They assume the default `Sibling` `ZIndexBehavior`, as the rest of the library does.
- The identifier inside the component is `selectIndex`, not `select`: `select` is reserved by the roblox-ts compiler (`roblox-ts/no-invalid-identifier` lint error).
