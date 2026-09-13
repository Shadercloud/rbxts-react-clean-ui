# Tabs

`Tabs` groups related content into a row of selectable buttons with one associated content panel shown at a time. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

Unlike `Accordion`, `Tabs` is not a scanning compound component: `Tabs.List`, `Tabs.Body`, `Tabs.Title`, and `Tabs.Content` are real, independently self-rendering components (the same "Root provides context, subparts consume it independently" pattern `Card`'s `Card.Header`/`Card.Footer` use) wired together only through shared context and a shared `value` string — `Tabs` never walks or harvests its `children`.

## Public API

- `Tabs` accepts `children: React.ReactNode`, an optional `defaultValue?: string` that seeds the initially-selected tab in uncontrolled mode, an optional `value?: string` that switches it to controlled mode, and an optional `onValueChange?: (value: string) => void` (see Selection behavior). `Tabs` no longer accepts `scale` or `backgroundImage` directly (see `Tabs.List`/`Tabs.Body` below).
- The component exposes `Tabs.List`, `Tabs.Body`, `Tabs.Title`, and `Tabs.Content`. There is no `Tabs.Tab` wrapper — a title and its content are associated only by sharing the same `value`, not by any parent/child pairing.
- `Tabs.List` accepts `children: React.ReactNode`, an optional `fill?: boolean` (default `false`, see Layout), and the shared `scale` prop (`ScalableElementProps`, declared but — as with the removed `Tabs`-level `scale` prop it replaces — not currently read anywhere) plus a forwarded ref (`React.forwardRef<ImageLabel, ...>`) to its underlying `Container`. It renders the themed tab-button bar and does not inspect its children.
- `Tabs.Body` accepts `children: React.ReactNode`, the shared `scale` prop (same caveat as `Tabs.List`), an optional `backgroundImage` (a `CssBackgroundImage` overriding `theme.components.tabs.backgroundImage`, resolved the same way `Tabs`'s own `backgroundImage` prop used to be), an optional `backgroundGradient` (a `CssBackgroundGradient` overriding `theme.components.tabs.backgroundGradient`, resolved the same way), and a forwarded ref to its underlying `Container`. It renders the themed content pane and does not inspect its children.
- `Tabs.Title` accepts a required `value: string` (the tab's identity) and a required `text: string` (its label), plus the full shared `PaddingProps` set (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding`). It renders the actual button for that tab.
- `Tabs.Content` accepts a required `value: string` and `children: React.ReactNode`. It renders the actual panel for that tab, always mounted, shown only while its `value` matches the current selection.

## Composition

- `Tabs.Title` and `Tabs.Content` read the shared selection from context; they work no matter where under `Tabs` they're rendered — inside `Tabs.List`/`Tabs.Body`, or split across an unrelated layout entirely (e.g. `Tabs.List` inside a `Card.Header` and `Tabs.Body` inside that same `Card`'s `Body`, both nested under one shared `Tabs`). `Tabs.List`/`Tabs.Body` are themed wrappers only — nothing about them is required for `Tabs.Title`/`Tabs.Content` to function.
- Every `Tabs.Title` mounted anywhere under the enclosing `Tabs` participates in the same selection; there is no per-`Tabs.List` scoping.
- A `Tabs.Content` whose `value` doesn't match any rendered `Tabs.Title` is still mounted (and simply never shown, since nothing marks it selected) — there is no validation that a `Tabs.Content`'s `value` corresponds to an existing tab button.
- `Tabs.List`/`Tabs.Body` render their `children` as-is; they do not check that those children are `Tabs.Title`/`Tabs.Content` respectively.

## Selection behavior

- **Controlled vs. uncontrolled.** When `value` is not `undefined`, `Tabs` is controlled: the displayed selection is always `value`, internal state is ignored, and clicking a title does not change the selection by itself — it only calls `onValueChange(clickedValue)`, and the caller must feed the new `value` back. When `value` is omitted, `Tabs` is uncontrolled and behaves as below (`defaultValue` seed, mount-order claim, click selects); `onValueChange` still fires on each click.
- `onValueChange` fires on every title click (`Activated`), including a click on the already-selected title. It never fires for the mount-time claim or for `defaultValue`.
- In controlled mode titles make no mount-time claim, so a `value` that matches no title simply shows no panel.
- Uncontrolled: no tab is selected until the first `Tabs.Title` mounts (or `Tabs`'s `defaultValue` is set): each `Tabs.Title` claims the selection for its own `value` on mount if nothing is selected yet, so in the common case of declaring `Tabs.Title`s top-to-bottom with no `defaultValue`, the first one ends up selected — matching "first tab selected by default." This is driven by mount order, not by a scanned index.
- Clicking a tab's button selects it via `Activated`; there is no keyboard/gamepad-specific handling beyond what the shared `HoverButton` provides.
- If the `Tabs.Title` matching the currently-selected value unmounts, selection is **not** reassigned to another tab — this is a known limitation (no scanned array exists to clamp against, unlike an index-based model).
- Selecting a tab shows only the `Tabs.Content` sharing its `value`; every other mounted `Tabs.Content` stays mounted but hidden (see Layout).
- There is no disabled-tab concept — every rendered `Tabs.Title` is always selectable.

## Input and feedback

- Each tab button uses the shared `HoverButton` primitive, so default/hover/selected (`focus`) states come from the theme via `ColorHelper.getIntentColors` against the `"primary"` intent — resolved independently by each `Tabs.Title` instance (not hoisted to `Tabs`). `Tabs`/`Tabs.Title` do not expose an `intent` prop; the tab-button color scheme is always resolved against `"primary"`.
- The selected tab's button uses the `focus` state color scheme; hovering an unselected tab uses `hover`; otherwise `default`.
- Tab button content is text-only: each button renders its `Tabs.Title.text` through the shared `Text` component (`TabTitleText`, `TextColor3` = the resolved state's `textColor`), styled from `theme.components.tabs.button` (padding, shadow, per-state text color, border, gradient, and typography — see Theme for corner radius), auto-sized (`Size={UDim2.fromScale(0,0)}`, `AutomaticSize.XY`; inside a `fill` list, `AutomaticSize.Y` only — see Layout).
- Each tab button (`TabButton-<value>`, an `ImageButton`) carries, besides its `BackgroundColor3`/`BackgroundTransparency`/image from the resolved state: a `uistroke` named `Stroke` (`Inner`, `Color` = state `borderColor`) only when the resolved thickness is `> 0`; a `uigradient` named `Gradient` only when the state's `backgroundGradient` has colours; and a `uicorner` named `Corners` unless every corner resolves to `0`. The full `Tabs.Title` props object (including its padding props) is passed through to the button-content renderer, so per-side padding overrides on `Tabs.Title` take effect against `theme.components.tabs.button.spacing`/`.padding`.

## Layout

- `Tabs` renders a `VStack` (gap = `theme.components.tabs.gap` pixels when set, otherwise the `VStack` default) wrapping whatever `children` it's given, inside a context provider — it renders no button bar or content pane itself. Arranging `Tabs.List` and `Tabs.Body` (directly, or split across other components) is entirely up to the caller.
- `Tabs.List` is a full-width (`width="100%"`) `Container` styled with `theme.components.tabs.list` (background color/transparency/image, corner radius, padding) wrapping an `HStack` of its children. The gap between titles is `theme.components.tabs.list.gap` pixels when set, otherwise the `HStack` default (half the default spacing token, rounded up).
- `Tabs.List fill`: the `HStack` uses `HorizontalFlex = Fill` and no wrapping, and every `Tabs.Title` inside that list drops to a zero base width (`AutomaticSize.Y`), so the titles share the list's inner width equally regardless of text length. Each title then centres its text with a `uilistlayout` named `TitleLayout`. Without `fill` titles size to their text as before. Titles rendered outside any `Tabs.List` are never in fill mode.
- `Tabs.Body` is a full-width (`width="100%"`) `Container` with an inner border (`Enum.BorderStrokePosition.Inner`, styled from `theme.components.tabs.borderColor`/`borderThickness`; no `Stroke` instance at all when `borderThickness` is `0`), padding from `theme.components.tabs.spacing`/`.padding`, corner radius from `theme.components.tabs.cornerRadius`, an optional background image resolved from `theme.components.tabs.backgroundImage`/its own `backgroundImage` prop, and an optional background gradient resolved from `theme.components.tabs.backgroundGradient`/its own `backgroundGradient` prop (see Public API and Theme), wrapping its children.
- Each `Tabs.Content` renders its `children` inside its own full-width (`width="100%"`) `Container` (so it resolves to `AutomaticSize.Y`, filling the width its parent gives it and auto-hugging height, rather than hugging both axes), with `Visible` set to whether its `value` matches the current selection. All `Tabs.Content` instances stay mounted simultaneously (only one `Visible` at a time) so that per-tab local state (e.g. a `Scroller`'s scroll position) survives switching tabs. This relies on a specific Roblox engine behavior: a `GuiObject` with `Visible=false` is excluded from its ancestors' `AutomaticSize`/`UIListLayout` content-size calculations, so the hidden panels don't inflate `Tabs.Body`'s own auto-size, and since none of the sibling `Tabs.Content` containers set an explicit `Position`, they all default to the same top-left placement without ever visibly overlapping (only one is ever visible at once).
- `Tabs.Body` and `Tabs.Content` both need a real (non-hugging) width so their contents — e.g. wrapped `Text` — get a real bound to wrap against, at any nesting depth. When `Tabs.Body` is a direct child of a `VStack` (the default usage, since `Tabs`'s own root renders one), that `VStack`'s default `HorizontalFlex={Fill}` already force-fills a direct child's width regardless of the child's own `AutomaticSize` — but `Tabs.Content` is nested one level *inside* `Tabs.Body`, with no `UIListLayout` between them, so it never benefited from that ambient fill and needs its own `width="100%"` regardless of nesting depth. Likewise, when `Tabs.List`/`Tabs.Body` are relocated elsewhere (e.g. into `Card.Header`/`Card.Body`, see Composition/Story), there is no `VStack` between the relocated parent's own `Container` and `Tabs.Body`, so `Tabs.Body` needs its own explicit `width="100%"` to inherit a real width from that parent rather than hugging its content's natural (unwrapped) size. Both `width="100%"` values are resolved as an ordinary `Container` `width` prop (`SizeHelper.GetAutoSize`, not a `Change`/`AbsoluteSize` measurement) and are safe to combine with an ambient `VStack` fill above them — the two mechanisms produce the same resolved width, so nesting one inside the other is redundant, not conflicting.

## Theme

Tabs defaults live under `theme.components.tabs`:

- `borderColor` and `borderThickness` style `Tabs.Body`'s inner border. `borderThickness: 0` renders no `UIStroke`.
- `cornerRadius` (top-level) styles `Tabs.Body`'s own corner rounding. A `0` radius renders no `UICorner` (the shared `Corners` decorator skips zero).
- `gap?: number` (default unset = the root `VStack`'s default gap) — pixel gap between the direct children of `Tabs` (normally `Tabs.List` and `Tabs.Body`). Negative values overlap them (see [Tabs sitting on the panel](#tabs-sitting-on-the-panel)). Has no effect when `Tabs.List`/`Tabs.Body` are relocated elsewhere.
- `backgroundColor` is declared at the top level but not read directly by `Tabs.Body`.
- `backgroundImage` (a `CssBackgroundImage`, resolved the same way as `Box`/`Select`'s `backgroundImage`) is read directly and rendered on `Tabs.Body`'s `Container` — it does not affect `BackgroundColor3`/`BackgroundTransparency` (neither is set there). `Tabs.Body`'s own `backgroundImage` prop takes precedence over this theme value. A 9-slice image (`slice` + `sliceScale`) renders exactly as on `Box`: both go through `Container`, which sets `ScaleType = Slice`, `SliceCenter` and `SliceScale` from the same resolver.
- `backgroundGradient` (a `CssBackgroundGradient`, resolved the same way as `Box`'s `backgroundGradient`) is read directly and rendered on `Tabs.Body`'s `Container` via the `Gradient` decorator. `Tabs.Body`'s own `backgroundGradient` prop takes precedence over this theme value.
- `spacing` / `padding` (top-level) control `Tabs.Body`'s padding (tier 2/3 of the shared [padding resolution](../index.md#padding-resolution)). `Tabs.Body` exposes no per-instance padding override — it always resolves against `{}` (no inline padding props), so only the theme tiers (and the global scale-token fallback) apply.
- `list.backgroundColor`, `list.cornerRadius`, `list.spacing`, and `list.padding` style `Tabs.List`'s row container — `list.spacing`/`list.padding` are the tier 2/3 padding overrides (no per-instance override exposed). `list.borderColor`/`list.borderThickness` are declared but not read. `list.backgroundTransparency` (default `0`, fully opaque) and `list.backgroundImage` (a `CssBackgroundImage`, resolved the same way as `Box`'s) let a theme layer or replace the flat `backgroundColor` fill with an image — set `backgroundTransparency: 1` to hide the flat fill entirely. `list.backgroundGradient` (a `CssBackgroundGradient`, resolved the same way as `Box`'s) layers a gradient on top the same way, via the `Gradient` decorator; theme-only, no per-instance override.
- `list.gap?: number` (default unset = current `HStack` gap) — pixel gap between titles. It is separate from `list.spacing`, which keeps meaning the list's padding tier; reusing `list.spacing` would have changed every shipped theme's gap.
- `list.cornerRadius` is the fallback for each tab button's own corner rounding (see `button.cornerRadius` below).
- `button.spacing` and `button.padding` style each tab button's internal padding (tier 2/3 overrides; a per-tab `Tabs.Title` padding prop is the tier-4 override — see Public API); `button.boxShadow` supplies the shadow via the resolved intent scheme; `button.typography` styles the tab label text; `button.intents` supplies the `default`/`hover`/`focus` color schemes resolved through the shared intent-color system against the `"primary"` intent. Each state's `IntentScheme` can also set `backgroundImage` (a `Partial<CssBackgroundImage>`, merged field-by-field the same way as `Card.Header`/`Card.Footer`/`Button`), which the tab button renders through `HoverButton`'s underlying `imagebutton` `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize`.
- `button.cornerRadius: CssSize | CssCornerRadius`. The per-corner object form (`{ topLeft?, topRight?, bottomLeft?, bottomRight? }`, each a `CssSize`, from `theme.style.ts`) is applied to the button's `uicorner` `TopLeftRadius`/`TopRightRadius`/`BottomLeftRadius`/`BottomRightRadius`; any unset corner falls back to `list.cornerRadius`. The plain `CssSize` form keeps its old meaning — ignored, with every corner following `list.cornerRadius` — because every shipped theme sets a scalar that differs from the radius actually rendered today.
- `button.borderThickness` is the tab button's stroke thickness (all shipped themes: `0`, so no stroke). A state's `borderThickness` in `button.intents` (an optional `IntentScheme` field) overrides it. The stroke colour is the resolved state's `borderColor`.
- Each state's `backgroundGradient` (`button.intents.primary.default/hover/focus`) renders on the tab button via `Gradient`. A `UIGradient` multiplies `BackgroundColor3`, so a state that uses a gradient should set `backgroundColor` to white and `backgroundTransparency: 0`.
- Each state's `textColor` is the title text colour: unselected = `default`, hovered = `hover`, selected = `focus`.
- Component props take precedence over theme defaults only where a prop exposes an override — beyond `defaultValue` on `Tabs`, `scale`/`backgroundImage`/`backgroundGradient` on `Tabs.Body`, `scale` on `Tabs.List`, and the padding props on `Tabs.Title`, no other direct style-override props exist, so the remaining `theme.components.tabs` values apply unconditionally.

## Tabs sitting on the panel

Target look (titles on top of the panel, 3px outline, top corners 8px, bottom 0, selected gradient, unselected flat) is reachable from theme settings alone. A `UIStroke` cannot omit one side, and no per-side border exists, so the closest setting is to overlap the tab row onto the body by exactly the stroke thickness: each tab's bottom inner stroke then lies exactly on the body's top inner stroke, and the two draw as one 3px line. The limitation: that shared line still runs under the selected tab too, so the selected tab doesn't open into the panel. Example on top of `WoodenTheme` (`extendTheme`):

```ts
tabs: {
    gap: -3,
    borderColor: Color3.fromHex("#331D07"),
    borderThickness: 3,
    cornerRadius: 0,
    list: { backgroundTransparency: 1, backgroundImage: { image: "" }, padding: "0px", cornerRadius: 0 },
    button: {
        borderThickness: 3,
        cornerRadius: { topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 },
        intents: { primary: {
            default: { textColor: Color3.fromHex("#D3CBA3"), borderColor: Color3.fromHex("#331D07"), backgroundColor: Color3.fromHex("#5C3A18"), backgroundTransparency: 0, backgroundImage: { image: "" } },
            hover: { textColor: Color3.fromHex("#D3CBA3"), backgroundTransparency: 0 },
            focus: {
                textColor: Color3.fromHex("#FFF7CF"), backgroundColor: Color3.fromHex("#FFFFFF"), backgroundTransparency: 0,
                backgroundGradient: { colors: [Color3.fromHex("#BA854A"), Color3.fromHex("#A16B30"), Color3.fromHex("#7A4A20")], stops: [0, 0.48, 1], rotation: 90 },
            },
        } },
    },
},
```

- `gap` only overlaps when `Tabs.List` and `Tabs.Body` are direct children of `Tabs`.
- `list.padding` must be `0` on the bottom, or the list padding separates the tab bottoms from the list edge and the strokes no longer line up.
- `WoodenTheme` sets image backgrounds on the list and buttons. A theme merge can't delete a key, so `image: ""` is how to clear them.

## Animation

- Tab switching is instantaneous — there is no animated transition between panels or button states beyond `HoverButton`'s own (unanimated) state swap.

## Story

Two stories cover `Tabs`, mirroring the two-file (`<Component>.tsx` fixture + `<Component>.story.tsx`) split used throughout `/Stories/`:

- `Tabs.tsx`/`Tabs.story.tsx` demonstrate:
  - `Tabs` wrapping a `Tabs.List` (with three or more `Tabs.Title`s) and a `Tabs.Body` (with a matching `Tabs.Content` per title, matched by `value`), including at least one `Tabs.Content` using a `Scroller` for overflow to show a tall panel inside a fixed-height `Tabs.Body`.
  - Switching selection by clicking different tab buttons, and observing hover vs. selected visual states.
  - A `Tabs.Content` whose panel has no matching visible content beyond simple text, to keep the empty/simple-panel case covered.
  - A controlled `Tabs` (`value` + `onValueChange` driven by story state, e.g. with an external button that switches tabs), a `Tabs.List fill` example, and the tabs-on-panel theme from [Tabs sitting on the panel](#tabs-sitting-on-the-panel).
- `TabsInCard.tsx`/`TabsInCard.story.tsx` demonstrate `Tabs.List` and `Tabs.Body` relocated into a different layout — `Tabs.List` inside a `Card.Header`, `Tabs.Body` inside that same `Card`'s `Body`, both still nested under one shared `Tabs` — to show that selection state works independent of where `Tabs.List`/`Tabs.Body` are placed.

## Loom

- A fixed-width `Container` showing `Tabs` (with a `Tabs.List` and `Tabs.Body`, two or three tabs) and the first tab initially selected, matching the documented basic-usage example.

## Implementation notes

- `Tabs.Title`'s mount-time claim (`claimTab`) must use a functional updater (`setUncontrolledSelected((current) => current ?? value)`). Every title mounts in the same commit with the selection still `undefined`, so a plain setter would let each one claim, and the last-declared title would win. `claimTab` is a no-op while controlled.
- The context functions are named `claimTab`/`selectTab`, not `claim`/`select`: `select` is a Luau global, and roblox-ts rejects it as a destructured identifier ("reserved for compiler internal usage").
- Controlled mode is detected as `value !== undefined`. Luau can't tell an omitted prop from an explicit `undefined`, so there is no "controlled with nothing selected" state.
- `TabButtonCorners` tells the two `button.cornerRadius` forms apart with `typeIs(..., "table")`. `CssSize` is never a table. Don't start honouring the scalar form: shipped themes set `button.cornerRadius` to values (e.g. Default `4`) that differ from the `list.cornerRadius` they actually render with (Default `8`).
- `fill` sets each title's base width to `0` (`AutomaticSize.Y`). `HorizontalFlex = Fill` only shares out the *extra* space, so auto-sized titles would keep unequal widths.
- `TitleLayout` is safe beside `Padding`/`BoxShadow`/`Stroke`/`Corners`/`Gradient` in the button, because a `UIListLayout` only arranges `GuiObject`s and the title `Text` is the only one.
- The `Tabs` root renders no Instance of its own, but it's still wrapped in `React.forwardRef` so roblox-ts compiles it to a table that can hold `Tabs.List`/`Body`/`Title`/`Content`. The `ref` is unused. `RefAttributes<Frame>` is only a type-level placeholder, and `Tabs` doesn't support `ref` in practice.
