# Tabs

`Tabs` groups related content into a row of selectable buttons with one associated content panel shown at a time. It uses a compound-component API similar to `Accordion`. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

## Public API

- `Tabs` accepts the shared `scale` prop (`ScalableElementProps`) in addition to `children`. It is currently uncontrolled only — there is no `value`/`onValueChange`/`defaultValue` prop; the selected tab is entirely internal state.
- The component exposes `Tabs.Tab`, `Tabs.Title`, and `Tabs.Content` child components.
- `Tabs.Tab` accepts `children: React.ReactNode` and defines one tab; it renders nothing itself.
- `Tabs.Title` accepts a required `text: string` prop plus the full shared `PaddingProps` set (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding` — no `PositionElementProps` collision on this sub-part) and defines a tab's button label; it renders nothing itself (children on `Tabs.Title`, if any, are not used). Any padding prop set on `Tabs.Title` overrides that tab button's own padding, per side, against `theme.components.tabs.button.spacing`/`.padding`.
- `Tabs.Content` accepts `children: React.ReactNode` and defines the panel shown while its tab is selected; it renders nothing itself.

## Composition

- Only direct `Tabs.Tab` children of `Tabs` are read; other direct children are ignored.
- Within each `Tabs.Tab`, only the first direct `Tabs.Title` child and the first direct `Tabs.Content` child are used (found by scanning `tab.props.children` for `child.type === TabTitle` / `child.type === TabContent`).
- A `Tabs.Tab` without a `Tabs.Title` is dropped entirely — it is not added to the tab list and does not render a button or reserve a slot.
- A `Tabs.Tab` with a title but no `Tabs.Content` is included and rendered as a selectable button, but selecting it shows no content panel (the content area is left empty for that tab).

## Selection behavior

- The first tab (index `0`) is selected by default.
- Clicking a tab's button selects it via `Activated`; there is no keyboard/gamepad-specific handling beyond what the shared `HoverButton` provides.
- If the set of tabs shrinks such that the currently selected index is no longer valid (e.g. tabs are removed), selection clamps to the last valid index (`tabCount - 1`), or `0` if there are no tabs left.
- Selecting a tab shows only its content; content panels for unselected tabs are not mounted (only `selectedTab?.content` is rendered).
- There is no disabled-tab concept — every tab in the list is always selectable.

## Input and feedback

- Each tab button uses the shared `HoverButton` primitive, so default/hover/selected (`focus`) states come from the theme via `ColorHelper.getIntentColors` against the `"primary"` intent — `Tabs` does not expose its own `intent` prop; the tab-button color scheme is always resolved against `"primary"`.
- The selected tab's button uses the `focus` state color scheme; hovering an unselected tab uses `hover`; otherwise `default`.
- Tab button content (icon/text-equivalent) is text-only: each button renders its `Tabs.Title.text` through the shared `Text` component, styled from `theme.components.tabs.button` (corner radius, padding, shadow, text color, and typography), auto-sized (`Size={UDim2.fromScale(0,0)}`, `AutomaticSize.XY`). The full `Tabs.Title` props object (not just `text`) is passed through to the button-content renderer, so its padding props (see Public API) take effect per side against `theme.components.tabs.button.spacing`/`.padding`.

## Layout

- `Tabs` renders as a `VStack` containing two sections: the tab-button list on top and the content panel below.
- The tab list is a full-width (`width="100%"`) `Container` styled with `theme.components.tabs.list` (background color, corner radius, padding) containing an `HStack` of the tab buttons in declaration order.
- The content panel is a `Container` with an inner border (`Enum.BorderStrokePosition.Inner`, styled from `theme.components.tabs.borderColor`/`borderThickness`), padding from `theme.components.tabs.spacing`, and the same corner radius as the tab list (`theme.components.tabs.list.cornerRadius`) — reused rather than a separate content corner radius.
- Only the currently selected tab's content node is rendered inside the content panel.

## Theme

Tabs defaults live under `theme.components.tabs`:

- `borderColor` and `borderThickness` style the content panel's inner border.
- `cornerRadius` is declared on the top-level `tabs` theme node but is not currently read anywhere in `Tabs.tsx` (both the list and the content panel instead reuse `tabs.list.cornerRadius`) — treat the top-level `cornerRadius` as unused today rather than assuming it drives a distinct visual.
- `backgroundColor` is likewise declared at the top level but not read directly; the tab list's background instead comes from `tabs.list.backgroundColor`.
- `spacing` / `padding` (top-level) control the content panel's padding (tier 2/3 of the shared [padding resolution](../index.md#padding-resolution)). `Tabs` exposes no per-instance override for the content panel — it always resolves against `{}` (no inline padding props), so only the theme tiers (and the global scale-token fallback) apply there.
- `list.backgroundColor`, `list.cornerRadius`, `list.spacing`, and `list.padding` style the tab-button row container — `list.spacing`/`list.padding` are the tier 2/3 padding overrides, resolved the same way as the content panel's (no per-instance override exposed). `list.borderColor`/`list.borderThickness` are declared but not read in `Tabs.tsx`. `list.backgroundTransparency` (default `0`, fully opaque) and `list.backgroundImage` (a `CssBackgroundImage`, resolved the same way as `Box`'s `backgroundImage`) let a theme layer or replace the flat `backgroundColor` fill with an image — set `backgroundTransparency: 1` to hide the flat fill entirely and let the image show through cleanly.
- `button.cornerRadius`, `button.spacing`, and `button.padding` style each tab button's corner rounding and internal padding (`button.spacing`/`button.padding` are the tier 2/3 overrides; a per-tab `Tabs.Title` padding prop is the tier-4 override — see Public API); `button.boxShadow` supplies the shadow via the resolved intent scheme; `button.typography` styles the tab label text; `button.intents` supplies the `default`/`hover`/`focus` color schemes resolved through the shared intent-color system against the `"primary"` intent. Each state's `IntentScheme` can also set `backgroundImage` (a `Partial<CssBackgroundImage>`, merged field-by-field the same way as `Card.Header`/`Card.Footer`/`Button`), which the tab button renders through `HoverButton`'s underlying `imagebutton` `Image`/`ImageColor3`/`ImageTransparency`/`ScaleType`/`SliceCenter`/`SliceScale`/`TileSize`.
- `button.borderThickness` is declared but not read in `Tabs.tsx`.
- Component props take precedence over theme defaults only where `Tabs`/`Tabs.Title` expose an override — beyond `scale` on `Tabs` and the padding props on `Tabs.Title`, no other direct style-override props exist, so the remaining `theme.components.tabs` values apply unconditionally.

## Animation

- Tab switching is instantaneous — there is no animated transition between panels or button states beyond `HoverButton`'s own (unanimated) state swap.

## Story

The story should demonstrate:
- Three or more tabs with distinct content, including at least one `Tabs.Content` using a `Scroller` for overflow (per the existing documented pattern) to show a tall panel inside a fixed-height `Tabs`.
- Switching selection by clicking different tab buttons, and observing hover vs. selected visual states.
- A tab that has a `Tabs.Title` but no `Tabs.Content`, to show the empty-panel case.

## Loom

- A fixed-width `Container` showing `Tabs` with two or three tabs and the first tab initially selected, matching the documented basic-usage example.
