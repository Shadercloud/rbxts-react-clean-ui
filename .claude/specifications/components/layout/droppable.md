# Droppable

`Droppable` marks a GUI element as a valid drop target for `Draggable` (see [draggable.md](./draggable.md)). It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

`Droppable` is the passive half of the drag-and-drop pair: it does not initiate or track any drag state of its own. It exists to register a `GuiObject` in the shared registry so a `Draggable` can find it by position and to expose which `GuiObject` was dropped on it.

## Public API

- `Droppable` accepts a single `children: ReactElement<GuiObjectProps>` — the element that defines the drop area's bounds. This element is cloned, not wrapped: `Droppable` does not introduce an extra `Frame` around it.
- `id?: string` is an opaque identifier stored on this droppable's registry entry and surfaced to `Draggable`'s `onDragged`/`onDropped` callbacks as `DroppableRegistration.id`, so a draggable can distinguish which target it is over/was dropped on.
- `onDrop?: (draggedObject: GuiObject) => void` fires with the dragged `GuiObject` instance whenever a `Draggable` reports this droppable as being under the pointer — both while dragging (on every pointer move) and at drop time. There is no separate "drag entered" / "drag left" callback; a consumer wanting hover-only feedback must track drag position itself (see below).
- There is no `disabled` prop and no visual/theme surface of its own — a `Droppable` renders exactly its child, with no added decoration. Any hover/active styling is the consumer's responsibility.

## Registration

- On mount, `Droppable` registers its (cloned) child's underlying `GuiObject` in the shared registry under `DroppableRegistryKey` via `useRegistryRegistration`, storing `{ guiObject, id, drop }`. It unregisters on unmount or whenever `id`/`onDrop` changes (the registration is recreated when either dependency changes).
- Requires a `RegistryProvider` ancestor (shared with `Draggable`); without one, registration silently no-ops.
- `Droppable` provides `DroppableContext` to its subtree with `{ registration }` — the same registration object stored in the registry. This lets a custom child (or a component nested inside the `Droppable`, such as a hover-highlight wrapper) read its own registration and compare it against a `DroppableRegistration` obtained elsewhere (e.g. from a `Draggable`'s `onDragged` callback) to determine whether *this specific* droppable is the one currently hovered — this is the supported pattern for hover-only visual feedback, since `onDrop` alone does not distinguish hover from drop.

## Drop detection semantics

- `onDrop` is invoked by whichever `Draggable` currently has the pointer over this droppable's bounds. Detection is bounds-based (`Draggable` scans all visible descendants of the drag root's outermost `Frame` for ones whose absolute rectangle contains the pointer position), not `Droppable`-initiated.
- If multiple registered `Droppable`s overlap at the pointer position, **all** of them receive `onDrop` for that same pointer position/frame, not just the top-most one by `ZIndex`. Only the `DroppableRegistration` reported back to the dragging `Draggable`'s own `onDragged`/`onDropped` is limited to a single registration (the one processed last, which is the lowest-`ZIndex` match, not necessarily the top-most). Design drop zones to avoid overlap if this ambiguity matters — treat this as a documented quirk of the current implementation rather than a per-`Droppable` topmost-wins guarantee.
- `onDrop` fires purely based on pointer position; it does not filter by which `Draggable` is being dragged, its `id`, or any accept/reject predicate. Accepting or rejecting a specific dragged item is the consumer's responsibility inside `onDrop` (e.g. by inspecting the dragged `GuiObject` or, from the `Draggable` side, the `DroppableRegistration.id`).

## Layout

- `Droppable` does not affect its child's size or position; it is purely a registration/context wrapper.

## Theme

`Droppable` has no dedicated theme entry — it renders no additional visuals.

## Story

Since `Draggable` and `Droppable` are usually demonstrated together, the `Droppable`-specific behavior worth covering in a shared drag/drop story is:
- A `Droppable` that highlights only while a drag is hovering over it specifically (using `DroppableContext` to compare against the currently-hovered registration from `Draggable.onDragged`), demonstrating hover feedback is a consumer responsibility rather than built in.
- A rejected drop: dragging an item and releasing it somewhere with no `Droppable` underneath, showing `onDrop`/`onDropped` are simply not called.
- Two overlapping or adjacent `Droppable`s with distinct `id`s so a consumer can show routing behavior (e.g. one accepts the item, one deletes it) based on `id`.

## Loom

- Reuse the same Loom scene as `Draggable` (see draggable.md) — `Droppable` has no independent scene of its own, since it only makes sense demonstrated alongside a `Draggable`.
