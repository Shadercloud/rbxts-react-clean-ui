# Tabs

`Tabs` groups related content into a row of selectable buttons with one associated content panel shown at a time. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

Unlike `Accordion`, `Tabs` is not a scanning compound component: `Tabs.List`, `Tabs.Body`, `Tabs.Title`, and `Tabs.Content` are real, independently self-rendering components (the same "Root provides context, subparts consume it independently" pattern `Card`'s `Card.Header`/`Card.Footer` use) wired together only through shared context and a shared `value` string — `Tabs` never walks or harvests its `children`.

## Public API

- `Tabs` accepts `children: React.ReactNode` and an optional `defaultValue?: string` that seeds the initially-selected tab. It is otherwise uncontrolled — there is no `value`/`onValueChange` prop; the selected tab is internal state. `Tabs` no longer accepts `scale` or `backgroundImage` directly (see `Tabs.List`/`Tabs.Body` below).
- The component exposes `Tabs.List`, `Tabs.Body`, `Tabs.Title`, and `Tabs.Content`. There is no `Tabs.Tab` wrapper — a title and its content are associated only by sharing the same `value`, not by any parent/child pairing.
- `Tabs.List` accepts `children: React.ReactNode` and the shared `scale` prop (`ScalableElementProps`, declared but — as with the removed `Tabs`-level `scale` prop it replaces — not currently read anywhere) plus a forwarded ref (`React.forwardRef<ImageLabel, ...>`) to its underlying `Container`. It renders the themed tab-button bar and does not inspect its children.
- `Tabs.Body` accepts `children: React.ReactNode`, the shared `scale` prop (same caveat as `Tabs.List`), an optional `backgroundImage` (a `CssBackgroundImage` overriding `theme.components.tabs.backgroundImage`, resolved the same way `Tabs`'s own `backgroundImage` prop used to be), and a forwarded ref to its underlying `Container`. It renders the themed content pane and does not inspect its children.
- `Tabs.Title` accepts a required `value: string` (the tab's identity) and a required `text: string` (its label), plus the full shared `PaddingProps` set (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding`). It renders the actual button for that tab.
- `Tabs.Content` accepts a required `value: string` and `children: React.ReactNode`. It renders the actual panel for that tab, always mounted, shown only while its `value` matches the current selection.

## Composition

- `Tabs.Title` and `Tabs.Content` read the shared selection from context; they work no matter where under `Tabs` they're rendered — inside `Tabs.List`/`Tabs.Body`, or split across an unrelated layout entirely (e.g. `Tabs.List` inside a `Card.Header` and `Tabs.Body` inside that same `Card`'s `Body`, both nested under one shared `Tabs`). `Tabs.List`/`Tabs.Body` are themed wrappers only — nothing about them is required for `Tabs.Title`/`Tabs.Content` to function.
- Every `Tabs.Title` mounted anywhere under the enclosing `Tabs` participates in the same selection; there is no per-`Tabs.List` scoping.
- A `Tabs.Content` whose `value` doesn't match any rendered `Tabs.Title` is still mounted (and simply never shown, since nothing marks it selected) — there is no validation that a `Tabs.Content`'s `value` corresponds to an existing tab button.
- `Tabs.List`/`Tabs.Body` render their `children` as-is; they do not check that those children are `Tabs.Title`/`Tabs.Content` respectively.

## Selection behavior

- No tab is selected until the first `Tabs.Title` mounts (or `Tabs`'s `defaultValue` is set): each `Tabs.Title` claims the selection for its own `value` on mount if nothing is selected yet, so in the common case of declaring `Tabs.Title`s top-to-bottom with no `defaultValue`, the first one ends up selected — matching "first tab selected by default." This is driven by mount order, not by a scanned index.
- Clicking a tab's button selects it via `Activated`; there is no keyboard/gamepad-specific handling beyond what the shared `HoverButton` provides.
- If the `Tabs.Title` matching the currently-selected value unmounts, selection is **not** reassigned to another tab — this is a known limitation (no scanned array exists to clamp against, unlike an index-based model).
- Selecting a tab shows only the `Tabs.Content` sharing its `value`; every other mounted `Tabs.Content` stays mounted but hidden (see Layout).
- There is no disabled-tab concept — every rendered `Tabs.Title` is always selectable.

## Input and feedback

- Each tab button uses the shared `HoverButton` primitive, so default/hover/selected (`focus`) states come from the theme via `ColorHelper.getIntentColors` against the `"primary"` intent — resolved independently by each `Tabs.Title` instance (not hoisted to `Tabs`). `Tabs`/`Tabs.Title` do not expose an `intent` prop; the tab-button color scheme is always resolved against `"primary"`.
- The selected tab's button uses the `focus` state color scheme; hovering an unselected tab uses `hover`; otherwise `default`.
- Tab button content is text-only: each button renders its `Tabs.Title.text` through the shared `Text` component, styled from `theme.components.tabs.button` (padding, shadow, text color, and typography — see Theme for corner radius), auto-sized (`Size={UDim2.fromScale(0,0)}`, `AutomaticSize.XY`). The full `Tabs.Title` props object (including its padding props) is passed through to the button-content renderer, so per-side padding overrides on `Tabs.Title` take effect against `theme.components.tabs.button.spacing`/`.padding`.

## Layout

- `Tabs` renders a `VStack` wrapping whatever `children` it's given, inside a context provider — it renders no button bar or content pane itself. Arranging `Tabs.List` and `Tabs.Body` (directly, or split across other components) is entirely up to the caller.
- `Tabs.List` is a full-width (`width="100%"`) `Container` styled with `theme.components.tabs.list` (background color/transparency/image, corner radius, padding) wrapping an `HStack` of its children.
- `Tabs.Body` is a full-width (`width="100%"`) `Container` with an inner border (`Enum.BorderStrokePosition.Inner`, styled from `theme.components.tabs.borderColor`/`borderThickness`), padding from `theme.components.tabs.spacing`/`.padding`, corner radius from `theme.components.tabs.cornerRadius`, and an optional background image resolved from `theme.components.tabs.backgroundImage`/its own `backgroundImage` prop (see Public API and Theme), wrapping its children.
- Each `Tabs.Content` renders its `children` inside its own full-width (`width="100%"`) `Container` (so it resolves to `AutomaticSize.Y`, filling the width its parent gives it and auto-hugging height, rather than hugging both axes), with `Visible` set to whether its `value` matches the current selection. All `Tabs.Content` instances stay mounted simultaneously (only one `Visible` at a time) so that per-tab local state (e.g. a `Scroller`'s scroll position) survives switching tabs. This relies on a specific Roblox engine behavior: a `GuiObject` with `Visible=false` is excluded from its ancestors' `AutomaticSize`/`UIListLayout` content-size calculations, so the hidden panels don't inflate `Tabs.Body`'s own auto-size, and since none of the sibling `Tabs.Content` containers set an explicit `Position`, they all default to the same top-left placement without ever visibly overlapping (only one is ever visible at once).
- `Tabs.Body` and `Tabs.Content` both need a real (non-hugging) width so their contents — e.g. wrapped `Text` — get a real bound to wrap against, at any nesting depth. When `Tabs.Body` is a direct child of a `VStack` (the default usage, since `Tabs`'s own root renders one), that `VStack`'s default `HorizontalFlex={Fill}` already force-fills a direct child's width regardless of the child's own `AutomaticSize` — but `Tabs.Content` is nested one level *inside* `Tabs.Body`, with no `UIListLayout` between them, so it never benefited from that ambient fill and needs its own `width="100%"` regardless of nesting depth. Likewise, when `Tabs.List`/`Tabs.Body` are relocated elsewhere (e.g. into `Card.Header`/`Card.Body`, see Composition/Story), there is no `VStack` between the relocated parent's own `Container` and `Tabs.Body`, so `Tabs.Body` needs its own explicit `width="100%"` to inherit a real width from that parent rather than hugging its content's natural (unwrapped) size. Both `width="100%"` values are resolved as an ordinary `Container` `width` prop (`SizeHelper.GetAutoSize`, not a `Change`/`AbsoluteSize` measurement) and are safe to combine with an ambient `VStack` fill above them — the two mechanisms produce the same resolved width, so nesting one inside the other is redundant, not conflicting.

## Theme

Tabs defaults live under `theme.components.tabs`:

- `borderColor` and `borderThickness` style `Tabs.Body`'s inner border.
- `cornerRadius` (top-level) styles `Tabs.Body`'s own corner rounding.
- `backgroundColor` is declared at the top level but not read directly by `Tabs.Body`.
- `backgroundImage` (a `CssBackgroundImage`, resolved the same way as `Box`/`Select`'s `backgroundImage`) is read directly and rendered on `Tabs.Body`'s `Container` — it does not affect `BackgroundColor3`/`BackgroundTransparency` (neither is set there). `Tabs.Body`'s own `backgroundImage` prop takes precedence over this theme value.
- `spacing` / `padding` (top-level) control `Tabs.Body`'s padding (tier 2/3 of the shared [padding resolution](../index.md#padding-resolution)). `Tabs.Body` exposes no per-instance padding override — it always resolves against `{}` (no inline padding props), so only the theme tiers (and the global scale-token fallback) apply.
- `list.backgroundColor`, `list.cornerRadius`, `list.spacing`, and `list.padding` style `Tabs.List`'s row container — `list.spacing`/`list.padding` are the tier 2/3 padding overrides (no per-instance override exposed). `list.borderColor`/`list.borderThickness` are declared but not read. `list.backgroundTransparency` (default `0`, fully opaque) and `list.backgroundImage` (a `CssBackgroundImage`, resolved the same way as `Box`'s) let a theme layer or replace the flat `backgroundColor` fill with an image — set `backgroundTransparency: 1` to hide the flat fill entirely.
- `list.cornerRadius` is also reused for each tab button's own corner rounding (`Tabs.Title` does not read `button.cornerRadius` for this — see below).
- `button.spacing` and `button.padding` style each tab button's internal padding (tier 2/3 overrides; a per-tab `Tabs.Title` padding prop is the tier-4 override — see Public API); `button.boxShadow` supplies the shadow via the resolved intent scheme; `button.typography` styles the tab label text; `button.intents` supplies the `default`/`hover`/`focus` color schemes resolved through the shared intent-color system against the `"primary"` intent. Each state's `IntentScheme` can also set `backgroundImage` (a `Partial<CssBackgroundImage>`, merged field-by-field the same way as `Card.Header`/`Card.Footer`/`Button`), which the tab button renders through `HoverButton`'s underlying `imagebutton` `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize`.
- `button.cornerRadius` and `button.borderThickness` are declared but not read — button corner rounding actually reuses `list.cornerRadius` (see above), and no border is rendered on a tab button.
- Component props take precedence over theme defaults only where a prop exposes an override — beyond `defaultValue` on `Tabs`, `scale`/`backgroundImage` on `Tabs.Body`, `scale` on `Tabs.List`, and the padding props on `Tabs.Title`, no other direct style-override props exist, so the remaining `theme.components.tabs` values apply unconditionally.

## Animation

- Tab switching is instantaneous — there is no animated transition between panels or button states beyond `HoverButton`'s own (unanimated) state swap.

## Story

Two stories cover `Tabs`, mirroring the two-file (`<Component>.tsx` fixture + `<Component>.story.tsx`) split used throughout `/Stories/`:

- `Tabs.tsx`/`Tabs.story.tsx` demonstrate:
  - `Tabs` wrapping a `Tabs.List` (with three or more `Tabs.Title`s) and a `Tabs.Body` (with a matching `Tabs.Content` per title, matched by `value`), including at least one `Tabs.Content` using a `Scroller` for overflow to show a tall panel inside a fixed-height `Tabs.Body`.
  - Switching selection by clicking different tab buttons, and observing hover vs. selected visual states.
  - A `Tabs.Content` whose panel has no matching visible content beyond simple text, to keep the empty/simple-panel case covered.
- `TabsInCard.tsx`/`TabsInCard.story.tsx` demonstrate `Tabs.List` and `Tabs.Body` relocated into a different layout — `Tabs.List` inside a `Card.Header`, `Tabs.Body` inside that same `Card`'s `Body`, both still nested under one shared `Tabs` — to show that selection state works independent of where `Tabs.List`/`Tabs.Body` are placed.

## Loom

- A fixed-width `Container` showing `Tabs` (with a `Tabs.List` and `Tabs.Body`, two or three tabs) and the first tab initially selected, matching the documented basic-usage example.
