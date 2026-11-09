# HoverButton

`HoverButton` is a low-level primitive that renders a single `ImageButton` whose props are swapped based on hover/selected state. It underlies interactive controls elsewhere in the library (e.g. `Accordion` headers, `Tabs` triggers) rather than being a themed, ready-to-use control itself — it has no entry under `theme.components`.

## Public API

- `HoverButtonProps`: `default` (required), `hover?` and `focus?`, each `React.InstanceProps<ImageButton> & BorderElementProps`, `isSelected?: boolean`, `children?: React.ReactNode`.
- The rendered `ImageButton`'s props are computed as `{ ...default, ...stateProps }`, where `stateProps` is `focus` when `isSelected` is `true`, `hover` while the pointer is hovering (and not selected), and otherwise `undefined` (so only `default` applies).
- Only a fixed, explicit list of `ImageButton` properties is forwarded (layout, background/border, image, selection, `Modal`, and a few others) — properties on `React.InstanceProps<ImageButton>` outside that list are not passed through even if present on `default`/`hover`/`focus`.
- `Event` handlers are merged as `{ ...default.Event, ...stateProps?.Event }`, then `MouseEnter`/`MouseLeave` are always overridden internally to track hover; the internal handler still invokes the resolved state's `MouseEnter`/`MouseLeave` (and additionally the `default` state's, if different from the resolved state's) after updating hover.
- `Event?: React.InstanceEvent<ImageButton>` (top-level, optional) — extra handlers that run in addition to the state sets'. For each event, the state-set handler resolved above runs first, then the top-level one; this applies to `MouseEnter`/`MouseLeave` (after the hover update and the state/`default` handlers) and, under `pressOn="down"`, to the hand-driven `Activated`/`InputBegan` too (the merged handler is what press-down calls). Unset = exactly the previous event table. This is what lets `Tooltip` (and anything else using `ElementHelper.cloneWithEvents`) hook a bare `HoverButton`.
- `ref` is forwarded to the rendered `ImageButton`.
- Border: `borderThickness?: number`, `borderColor?: Color3`, `borderTransparency?: number`, `borderPosition?: "inner" | "outer"` (the shared `BorderElementProps`, same meaning as on [`Container`](../layout/container.md#border-padding-and-corners)). They can be set on `HoverButton` itself and/or inside `default`/`hover`/`focus`. Each field resolves from the merged state set first (so a `hover` set can change just `borderColor`), then the top-level prop. A `UIStroke` named `Stroke` is rendered as the button's first child only when the resolved `borderThickness` is greater than `0`; with no border props anywhere, no stroke is rendered, as before. `borderPosition` defaults to `"inner"`. The border fields are never forwarded to the `ImageButton` itself.
- `pressOn?: "down" | "up"` (default `"up"`) and `onRelease?: (button: ImageButton, input: InputObject) => void` behave as on [`Button`](./button.md#press-down-activation), with the resolved `Activated`/`InputBegan` being the merged state set's (`hover`/`focus` handler if present, else `default`'s). Unset = the event table is built exactly as before. Since there is no `disabled`, press-down is blocked instead while the merged `Active` is `false`.
- `HoverButtonContext` (`{ hover: boolean; isSelected: boolean }`) is provided to `children`, letting nested content react to the same hover/selected state without re-deriving it.

## Behavior

- Hover state (`hovering`) is local `React.useState`, toggled by the underlying `ImageButton`'s `MouseEnter`/`MouseLeave`.
- `isSelected` takes precedence over hover: while `isSelected` is `true`, the component always reports/renders the `focus` state regardless of pointer position.
- There is no `disabled` state — a consumer wanting a disabled visual must fold that into its own `default`/`hover`/`focus` prop sets.

## Implementation notes

- The rendered props are built by spreading `default` and the active state's prop set into a new object. Don't switch to object rest destructuring (`const { isSelected, ...rest } = props`): object spread is fine in roblox-ts, but rest destructuring is not supported.
- Existing callers (`Accordion`, `Tabs`, ...) draw their own `<uistroke>` child and don't set the border props, so they get no second stroke. Don't move one onto the border props without removing its hand-written stroke.
- `HoverButton` is a `React.forwardRef` so a `ref` reaches the `ImageButton` (`Tooltip` positions from it). A plain function component drops `ref`.
- Top-level `Event` is folded in by the local `mergeEvents` before `activated`/`inputBegan` are read, so press-down calls a top-level `Activated`/`InputBegan` in the same order as the normal path. Don't read `activated`/`inputBegan` from the state sets alone. `MouseEnter`/`MouseLeave` call `topEvents` explicitly because the internal handlers replace the merged ones.
- Press-down uses the same `Button.press.ts` helpers as `Button`; see Button's implementation notes for why release is read from the `InputObject`'s `UserInputState` and why `Activated` skips pointer inputs in `"down"` mode. The `Active === false` gate is a deliberate choice: `InputBegan` fires on an inactive button, so without it an `Active={false}` `HoverButton` would still press-down.
