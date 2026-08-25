# Fieldset

`Fieldset` pairs a label with a control (an input, select, checkbox, etc.) in a responsive horizontal row that can wrap to a vertical stack at narrow widths. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

This is `src/Components/Layout/Fieldset.tsx`, exported from the package root.

## Public API

- `Fieldset` accepts `disabled?: boolean` (default `false`), `checkbox?: boolean` (default `false`), `wrap?: Breakpoint` (default `"lg"`), and the shared `breakpoints` override from `BreakPointElementProps`.
- The component exposes `Fieldset.Label` and `Fieldset.Control` child components, both requiring a `Fieldset` ancestor (each asserts if used outside one).
- `Fieldset.Label` and `Fieldset.Control` both accept only `children: React.ReactNode` — neither takes styling props of its own.
- `Fieldset` renders its `children` directly; consumers place `Fieldset.Label` and `Fieldset.Control` (in either order) inside it. Order in JSX controls visual order — the `checkbox` variant is typically authored with `Fieldset.Control` before `Fieldset.Label` so the checkbox appears before its text.

## Label / control coordination

- `Fieldset.Label` renders its children inside an invisible, auto-sized `ImageButton` that fires a shared `labelActivated` `BindableEvent` (created and owned by the parent `Fieldset`, one per `Fieldset` instance) when activated. Clicking/activating the label does not change any state inside `Fieldset` itself.
- `Fieldset` provides `FieldsetContext` (`disabled`, `checkbox`, `labelActivated`) to its subtree. Compatible controls placed inside `Fieldset.Control` — currently `Checkbox`, `Input`, and `Select` — read this context directly (not through `Fieldset.Control` itself) and connect to `labelActivated` so that activating the label also activates/toggles the control (e.g. clicking a checkbox's label toggles the checkbox; clicking a select's label opens it). This is how "click the label to activate the control" behavior is implemented — `Fieldset` itself has no knowledge of which control is present.
- `disabled` is exposed on `FieldsetContext` but, as of this implementation, no consumer (`Fieldset.Label`, `Fieldset.Control`, `Checkbox`, `Input`, or `Select`) reads it — setting `disabled` has no observable effect today. Treat it as a documented no-op rather than inferring visual/behavioral disabling that isn't implemented.
- `checkbox` changes only the flex sizing of `Fieldset.Control` (see Layout below); it does not change `Fieldset.Label`'s behavior or force any particular child order.

## Layout

- `Fieldset` renders a `Container` (tracking its own `AbsoluteSize.X` for breakpoint calculation) wrapping an `HStack` with vertical-centered alignment and `HorizontalFlex={Enum.UIFlexAlignment.Fill}`, containing the `Fieldset.Label`/`Fieldset.Control` children directly.
- `Fieldset.Label` is a fixed-size flex item (`GrowRatio`/`ShrinkRatio` both `0`) — it never grows or shrinks to fill space.
- `Fieldset.Control` grows and shrinks to fill remaining space (`GrowRatio`/`ShrinkRatio` both `1`) in the default (non-`checkbox`) mode. In `checkbox` mode, it behaves like the label — fixed-size (`GrowRatio`/`ShrinkRatio` both `0`) — since a checkbox control should size to its own content rather than stretch.
- Whether the row wraps to a vertical stack is computed from the `Fieldset`'s own measured width against `breakpoints` (`props.breakpoints` or the theme default) and the `wrap` prop: the row wraps at breakpoints at-or-below `wrap` (default `"lg"`) and stays on one line above it. In practice this means the label/control stack vertically at narrow widths and sit side-by-side once the `Fieldset` is wide enough to cross past the `wrap` breakpoint.
- `Fieldset` has no dedicated background, border, or padding of its own; it relies on its parent for those.

## Theme

`Fieldset` reads no `theme.components.fieldset` entry — it has no dedicated themeable visuals. It only reads `theme.breakpoints` as the default for the `breakpoints` prop.

## Story

The story should demonstrate:
- A standard label + text `Input` pairing and a label + `Select` pairing, both showing the label click activating/opening the control.
- A `checkbox`-mode `Fieldset` (`Control` before `Label`) showing that clicking the label toggles the checkbox.
- Resizing the containing width across the `wrap` breakpoint to show the row switching between inline and stacked layouts (e.g. via a numeric width control on the story, similar to other layout stories).

## Loom

- A short form-like scene with two or three `Fieldset` rows (a text input, a select, and a checkbox) at a width that keeps them inline, since this is the common usage shown in the existing `dragdrop`/`Fieldset` example scenes elsewhere in the package.
