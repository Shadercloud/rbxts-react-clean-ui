# HoverButton

`HoverButton` is a low-level primitive that renders a single `ImageButton` whose props are swapped based on hover/selected state. It underlies interactive controls elsewhere in the library (e.g. `Accordion` headers, `Tabs` triggers) rather than being a themed, ready-to-use control itself — it has no entry under `theme.components`.

## Public API

- `HoverButtonProps`: `default: React.InstanceProps<ImageButton>` (required), `hover?: React.InstanceProps<ImageButton>`, `focus?: React.InstanceProps<ImageButton>`, `isSelected?: boolean`, `children?: React.ReactNode`.
- The rendered `ImageButton`'s props are computed as `{ ...default, ...stateProps }`, where `stateProps` is `focus` when `isSelected` is `true`, `hover` while the pointer is hovering (and not selected), and otherwise `undefined` (so only `default` applies).
- Only a fixed, explicit list of `ImageButton` properties is forwarded (layout, background/border, image, selection, and a few others) — properties on `React.InstanceProps<ImageButton>` outside that list are not passed through even if present on `default`/`hover`/`focus`.
- `Event` handlers are merged as `{ ...default.Event, ...stateProps?.Event }`, then `MouseEnter`/`MouseLeave` are always overridden internally to track hover; the internal handler still invokes the resolved state's `MouseEnter`/`MouseLeave` (and additionally the `default` state's, if different from the resolved state's) after updating hover.
- `HoverButtonContext` (`{ hover: boolean; isSelected: boolean }`) is provided to `children`, letting nested content react to the same hover/selected state without re-deriving it.

## Behavior

- Hover state (`hovering`) is local `React.useState`, toggled by the underlying `ImageButton`'s `MouseEnter`/`MouseLeave`.
- `isSelected` takes precedence over hover: while `isSelected` is `true`, the component always reports/renders the `focus` state regardless of pointer position.
- There is no `disabled` state — a consumer wanting a disabled visual must fold that into its own `default`/`hover`/`focus` prop sets.
