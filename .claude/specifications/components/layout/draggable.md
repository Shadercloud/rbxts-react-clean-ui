# Draggable

`Draggable` makes a single GUI element movable by pointer or touch, and cooperates with `Droppable` (see [droppable.md](./droppable.md)) to report which drop target is currently underneath it. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

`Draggable` and `Droppable` form a pair: `Draggable` reports the `DroppableRegistration` it is over, and `Droppable` reports the raw dragged `GuiObject`. Both rely on the shared registry provider (`RegistryProvider`, `RegistryContext`) to discover one another, and `Draggable` additionally relies on an `OverlayProvider` to render the element being dragged above the rest of the UI.

## Public API

- `Draggable` accepts a single `children: ReactElement<GuiObjectProps>` — the element that is moved. This element is cloned, not wrapped: `Draggable` does not introduce an extra `Frame` around it.
- `id?: string` is an opaque identifier stored on this draggable's registry entry. It is not read by `Draggable` itself.
- `placeholder?: boolean` (default `true`) keeps a themed placeholder frame in the original layout position/size while dragging, so surrounding layout (e.g. a `VStack`) does not reflow around the now-hidden original.
- `retainPosition?: boolean` (default `false`, i.e. off). When enabled, releasing the drag converts the element's final absolute screen position back into a `Position` offset relative to its original parent and applies it to the underlying instance, so the element stays where it was dropped. Without it, the element snaps back to its original `Position` once dragging ends (because the drag preview is discarded and the original, un-moved instance becomes visible again).
- `onStartDrag?: () => void` fires once when a drag begins.
- `onDragged?: (droppable?: DroppableRegistration) => void` fires on every pointer/touch move during a drag, with the `DroppableRegistration` currently under the pointer (`undefined` if none).
- `onDropped?: (droppable?: DroppableRegistration) => void` fires once when the drag ends (button/touch released), with the `DroppableRegistration` under the pointer at release time.
- `Draggable.Handle` is the sub-component that must wrap the part of the child that starts a drag. `Draggable.Handle` accepts a single child element and requires a `Draggable` ancestor (it reads `DraggableContext` and asserts if missing).
- There is no `disabled` prop; a `Draggable` can always be dragged unless another draggable is currently being dragged (see below).

## Registration

- On mount, `Draggable` registers its root instance in the shared registry (`RegistryContext`) under `DraggableRegistryKey`, keyed by the instance itself, storing `{ guiObject, id, draggable }`. It unregisters on unmount.
- `Droppable` registers similarly under `DroppableRegistryKey` (see droppable.md).
- Both components require a `RegistryProvider` ancestor; without one, registration and lookup silently no-op (no crash), so drag/drop coordination simply does not happen.

## Drag lifecycle

- Dragging starts on `InputBegan` on a `Draggable.Handle`-wrapped element, for `MouseButton1` or `Touch` input only. If that input point is over a descendant `GuiButton` or `TextBox` within the handle, drag start is suppressed so the nested interactive control can complete its own input lifecycle normally.
- Before starting, `Draggable` checks every other draggable registered in the registry; if any of them reports itself as currently dragging, the new drag is rejected outright (no state changes, `onStartDrag` is not called). This enforces that only one `Draggable` can be mid-drag at a time.
- On a successful start: the component records the input's start position, the root's starting absolute position, and starting `Position`; calls `onStartDrag`; and enters the dragging state.
- While dragging, `Draggable.Handle` listens globally for `InputChanged` (mouse movement or touch) and forwards it to update the drag, and for `InputEnded` (`MouseButton1` or `Touch`) to end the drag. These listeners are attached for the lifetime of the handle, not just during an active drag, and become live regardless of which draggable started the drag (a handle can therefore begin updating a different draggable's drag if that draggable is the active one — in practice this is used to have exactly one active drag at a time, per the check above).
- On each update, the component computes the pointer delta from the drag's start position, looks up whatever droppable(s) are at the current pointer position, and calls `onDragged` with the found `DroppableRegistration` (or `undefined`).
- On end, the same drop lookup is performed, `onDropped` is called with the result, dragging state is cleared, and — if `retainPosition` is set — the original instance's `Position` is rewritten to match where the drag preview ended up (accounting for the instance's `AnchorPoint`).

## Drop-target detection

- Drop-target lookup finds every visible `GuiObject` descendant of the drag root's highest ancestor `Frame` whose absolute bounds contain the pointer position, ordered from highest to lowest `ZIndex`, and checks each one against the droppable registry.
- Every matching registered droppable at that position has its `drop(instance)` callback invoked (i.e. `onDrop` fires on every overlapping droppable under the pointer, not only the top-most one) — see the note under droppable.md. The `DroppableRegistration` reported back to `Draggable`'s `onDragged`/`onDropped` is whichever matching registration was checked last (the lowest-`ZIndex` match among the overlapping droppables), not necessarily the top-most one.
- If no registered droppable is under the pointer, both callbacks receive `undefined`.

## Rendering and layout

- While not dragging, `Draggable` renders only the cloned child (with `Visible={true}` implicitly, since `Visible={!dragging}` is `true` when not dragging) in its original position in the tree — no extra wrapper.
- While dragging:
  - The original child is rendered with `Visible={false}` but stays mounted in place (so layout siblings around it are unaffected only if `placeholder` compensates for its space).
  - If `placeholder` is enabled, a themed placeholder `Frame` is rendered in the original child's place, matching its starting `Position`, `AnchorPoint`, `Size`, `LayoutOrder`, and `ZIndex`, so list/flex layouts don't collapse the gap.
  - A drag preview — a second clone of the child — is rendered through `createPortal` into the nearest `OverlayProvider`'s overlay `Frame`, positioned in overlay-local coordinates (screen position minus the overlay's absolute position), sized to the original's captured size, anchored at `Vector2.zero`, always `Visible`, and given a very high `ZIndex` (`100001`) so it renders above ordinary content. If no `OverlayProvider` is present, the preview is not rendered (no crash, but the element becomes invisible while dragging since the original is hidden).
- The `ref` passed to `Draggable` itself (`React.forwardRef<Frame, ...>`) is currently not attached to any rendered instance — `Draggable` has no wrapping frame, so a caller-supplied ref is not populated. Treat this as a known limitation rather than intended API surface.

## Theme

Draggable-specific theme values live under `theme.components.draggable.placeholder`:

- `backgroundColor` and `backgroundTransparency` style the placeholder's fill.
- `borderColor` and `borderThickness` style an inner (`Enum.BorderStrokePosition.Inner`) stroke around the placeholder.
- `cornerRadius` rounds the placeholder's corners via the shared `Corners` decorator.

The placeholder's `BackgroundTransparency` is hard-coded to `0.3` at the call site, which currently overrides the theme's `backgroundTransparency` value for the placeholder frame itself (the theme value is still applied first as a prop and then immediately overwritten) — note this discrepancy rather than treating the theme value as authoritative for that one property.

There is no configurable animation: the drag preview follows the pointer directly with no tween.

## Story

The story should demonstrate:
- Two or more `Draggable` elements that can be picked up by their `Draggable.Handle` and moved.
- At least one `Droppable` target that visibly reacts (e.g. via `DroppableContext` in a custom child) when a dragged element is hovering over it, and one interaction where a drop is accepted (e.g. moves an item from one list to another) as well as one where the drop is rejected (dropped outside any `Droppable`, snapping back).
- A `retainPosition` example (free-floating drag with no drop target, such as a draggable window) alongside a list-reordering-style example that uses `placeholder` to hold the gap.
- The one-drag-at-a-time rule: attempting to start a second drag while one is in progress should have no visible effect.

## Loom

- The Loom scene should show at least one drag-between-two-drop-zones interaction (e.g. moving an item from a source list into a target zone) using `placeholder`, since this is the primary use case.
