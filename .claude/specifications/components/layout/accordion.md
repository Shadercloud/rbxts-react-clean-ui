# Accordion

`Accordion` displays vertically stacked sections whose content can be expanded and collapsed. It uses a compound-component API so consumers can compose each section's header and content. It follows the shared conventions in [Components](../index.md).

## Public API

- `Accordion` accepts `children`, `defaultValue`, `value`, `onValueChange`, and `collapsible` props in addition to the scalable element props used by other layout components.
- `onValueChange` receives the complete next value after a section is opened or closed.
- Supplying `value` makes the accordion controlled. Without `value`, the accordion owns its state and initializes it from `defaultValue`.
- `collapsible` defaults to `false` in single mode. When `false`, activating the open section does not close it. Multiple mode always permits individual sections to be collapsed.
- The component exposes `Accordion.Item`, `Accordion.Header`, and `Accordion.Content` child components.

## Composition

- `Accordion.Item` defines one section and requires a unique `value: string` prop.
- `Accordion.Item` accepts an optional `disabled` prop. A disabled item cannot change state and its header uses the disabled visual treatment.
- `Accordion.Header` defines the interactive header and accepts React children. It may also accept an optional leading `icon` using the library's existing icon type, plus the full shared `PaddingProps` set (`spacing`, `top`/`bottom`/`left`/`right`, `padding`, `resolvedPadding` — no `PositionElementProps` collision on this sub-part), which overrides that header's own padding per side against `theme.components.accordion.header.spacing`/`.padding`.
- `Accordion.Content` contains the content associated with the header and accepts React children, plus the same full `PaddingProps` set as `Accordion.Header`, overriding per side against `theme.components.accordion.content.spacing`/`.padding`.
- Only direct `Accordion.Item` children are treated as sections. Other direct children are ignored.
- Each item uses the first direct `Accordion.Header` and first direct `Accordion.Content` child it contains. An item without a header is not rendered.
- An item without content still renders its header but does not expand.
- `Accordion.Header` and `Accordion.Content` should both accept `text` prop.  If this is set then use this an create a `<Text>` component with this text.  If `text` props is undefined then use the children instead.

## Expansion behavior

- Activating a closed, enabled header opens its item.
- In single mode, opening an item closes the previously open item.
- In multiple mode, opening or closing an item does not affect other items.
- Controlled and uncontrolled accordions follow the same interaction rules. In controlled mode, interaction calls `onValueChange` but the rendered state changes only when the consumer supplies a new `value`.
- Values in `value` or `defaultValue` that do not match a rendered item are ignored.
- If items change, open values for removed items are discarded from uncontrolled state and omitted from the next change notification.
- The expanded content is mounted only while its item is open. Closing an item unmounts its content after any closing animation completes.

## Input and feedback

- The entire header is an activation target and uses `HoverButton` so mouse, touch, and gamepad activation are consistent with existing controls.
- Headers display default, hover, focus/expanded, and disabled visual states from the theme.
- Each header includes a trailing expand indicator. It points toward the content when expanded and away from it when collapsed.
- The indicator is decorative and does not create a separate activation target.
- Disabled headers do not respond to activation and do not emit `onValueChange`.

## Layout

- The accordion height should fill its parent.
- Items are arranged vertically and fill the accordion's available width.
- Headers use automatic height based on their content and fill the available width.
- Header content is aligned horizontally, with the label area filling remaining space and the expand indicator aligned to the trailing edge.
- Expanded content uses automatic height based on its children and fills the available width.
- Spacing inside headers and content uses the shared theme spacing system.
- Adjacent item borders must not render as visually doubled.

## Theme

Accordion defaults live under `theme.components.accordion`:

- `borderColor`, `borderThickness`, and `cornerRadius` style the outer accordion and its items.
- `spacing` controls spacing between accordion items.
- `header.spacing`, `header.padding`, `header.typography`, and `header.intents` configure header padding (tier 2/3 of the shared [padding resolution](../index.md#padding-resolution); a per-header `padding`/`spacing`/`resolvedPadding` prop is the tier-4 override — see Composition), text, and default, hover, focus, and disabled states.
- `header.intents.<intent>.<state>.backgroundImage` is supported the same way as other intent-driven components (e.g. Button, Card, Tabs): each header state resolves its own background image on top of `backgroundColor`/`backgroundTransparency`, so a theme can render a 9-slice background image per header state instead of a flat color. `backgroundGradient` is **not** supported here — the header renders through `HoverButton`'s flat instance-prop swapping, which can't carry a child `<uigradient>` element the way the other intent-driven components can.
- `header.indicatorSize` and `header.indicatorColor` configure the expand indicator.
- `content.spacing`, `content.padding`, `content.backgroundColor`, and `content.backgroundTransparency` configure the expanded content area (`content.spacing`/`content.padding` are the tier 2/3 padding overrides; a per-content padding prop is the tier-4 override).
- `animation.duration` controls expand, collapse, and indicator-rotation duration. A duration of `0` disables animation.
- Component props that expose a corresponding style override take precedence over theme defaults.
- `Enum.BorderStrokePosition.Outer` should be used for the main border in order to not be over lapped by the accordion child backgrounds
- If the theme calls for a cornerRadius then the first header should have a `<uicorner>` with `TopLeftRadius` and `TopRightRadius` matching that teme cornerRadius so as not to overlap the main accordion border.

- Each individual theme should have a set of customized accordion colors.  Ensure that the header buttons are distinct and clearly separate the different content sections.

## Animation

- Opening and closing animate the content height and clip overflowing content for the duration of the transition.
- The expand indicator rotates in sync with the content transition.
- Animation uses the library's established tweening utilities and must not change the accordion's final measured size.
- Rapid repeated activation continues from the current visual state rather than producing overlapping animations.

## Story

The main story `<Container>` should have a 75% width and a fixed pixel height.

The story should demonstrate:
- `Accordion.Header` and `Accordion.Content` that utilize the `text` prop and ones that use custom child elements instead.
- Collapsible single-mode behavior.
- A disabled item and content with different heights.

Custom story controls should be limited to `collapsible`, and animation enabled or disabled.

## Loom

- The Loom scene uses a fixed-width `Container` with enough height to show one expanded section without clipping.
- It demonstrates three items, with the first item initially expanded and one item disabled.
