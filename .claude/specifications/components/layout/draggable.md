# Draggable

`Draggable` makes a single GUI element movable by pointer, touch or any other configured input, and cooperates with `Droppable` (see [droppable.md](./droppable.md)) to report which drop target is underneath it. It follows the shared conventions in [Components](../index.md) and the layout-wide notes in [Layout](./index.md).

`Draggable` and `Droppable` form a pair: `Draggable` reports the `DroppableRegistration` it is over, and `Droppable` receives the raw dragged `GuiObject`. They find each other through a module-level shared registry, so no provider is needed for drag/drop to work. `Draggable` additionally relies on an `OverlayProvider` to render the element being dragged above the rest of the UI.

## Public API

- `DraggableProps` (exported):
  - `children: ReactElement<GuiObjectProps>` — the element that is moved. It is cloned, not wrapped: `Draggable` does not introduce an extra `Frame` around it.
  - `id?: string` — opaque identifier stored on this draggable's registry entry and passed as `DragEventInfo.id` to every callback (including `Droppable`'s).
  - `inputTypes?: Enum.UserInputType[]` (default `[MouseButton1, Touch]`) — which inputs start a drag from a `Draggable.Handle`.
  - `placeholder?: boolean` (default `true`) — keeps a themed placeholder frame in the original layout position/size while dragging, so surrounding layout (e.g. a `VStack`) does not reflow around the now-hidden original.
  - `retainPosition?: boolean` (default `false`). When enabled, releasing the drag converts the element's final absolute screen position back into a `Position` offset relative to its original parent and applies it to the underlying instance, so the element stays where it was dropped. Without it, the element snaps back to its original `Position` once dragging ends.
  - `renderOverlay?: () => React.ReactNode` — custom drag preview. When set, the preview is a transparent `Frame` named `DragOverlay` at the dragged element's captured size and current position, containing whatever `renderOverlay()` returns (size content against it with scale). When unset, the preview is a clone of `children` (see Rendering).
  - `onStartDrag?: (info: DragEventInfo) => void` — fires once when a drag begins.
  - `onDragged?: (droppable: DroppableRegistration | undefined, info: DragEventInfo) => void` — fires on every move during a drag with the topmost `Droppable` under the pointer.
  - `onDropped?: (droppable: DroppableRegistration | undefined, info: DragEventInfo) => void` — fires once on release with the topmost `Droppable` under the pointer at release time.
  - Callbacks written for the old signatures (`(droppable?) => void`, `() => void`) still type-check; `info` is an extra trailing argument.
- `DragEventInfo` (exported from Contexts): `{ inputType: Enum.UserInputType; input: InputObject; position: Vector2; id?: string }`. `inputType` is the input that *started* the drag; `input`/`position` are the event that triggered the callback; `id` is the `Draggable`'s `id`.
- `Draggable.Handle` wraps the part of the child that starts a drag. It takes a single child element — a native element (`<frame>`, `<imagebutton>`, ...) or a component that forwards `Event` to an instance — and requires a `Draggable` ancestor (asserts otherwise). It sets `Active = true` on the child and adds an `InputBegan` handler; a handler the child already has still runs first.
- There is no `disabled` prop; a `Draggable` can always be dragged unless another draggable is mid-drag.

## Registration

- On mount, `Draggable` registers its root instance under `DraggableRegistryKey` with `{ guiObject, id, draggable }` in the shared registry (`GlobalRegistry`), and also in the nearest `RegistryProvider`'s registry if there is one. It unregisters from both on unmount.
- A `Draggable` rendered inside another `Draggable`'s drag preview does not register.

## Drag lifecycle

- A drag starts on `InputBegan` on the handle when the input's `UserInputType` is in `inputTypes`. If the press point is over a visible descendant `GuiButton` or `TextBox` of the handle, the drag is not started so that control keeps its own input.
- Only one `Draggable` may be mid-drag at a time, across every mounted `Draggable` (including other React roots). A start while another drag is active is ignored (no state change, no `onStartDrag`).
- While dragging, the handle listens globally for `InputChanged` (`MouseMovement` or `Touch`) to move the preview, and for `InputEnded`. The drag ends only when the ended input has the same `UserInputType` (and `KeyCode`) as the one that started it; other releases are ignored.
- On each move: the preview follows the pointer delta, the topmost droppable under the pointer is looked up, enter/leave notifications are sent if it changed (see below), and `onDragged` fires.
- On release, in order: the topmost droppable at the release point gets `drop` (its `onDrop`) exactly once; the droppable that was last hovered (if any) gets `dragLeave`; `onDropped` fires; then `retainPosition` is applied and the dragging state is cleared.

## Drop-target detection

- Candidates are every registered `Droppable` whose instance contains the pointer, is `Visible` with every `GuiObject` ancestor `Visible`, is not clipped away at that point by an ancestor with `ClipsDescendants` (or a `CanvasGroup`), and sits under an enabled `LayerCollector` that is not a `SurfaceGui`/`BillboardGui`. Droppables are found wherever they are mounted: sibling trees, other `ScreenGui`s, `CoreGui`, other React roots.
- Among the candidates, the one drawn on top wins: higher `ScreenGui.DisplayOrder` first; within one `LayerCollector`, `ZIndexBehavior.Sibling` compares the diverging ancestors' `ZIndex` then sibling order (later sibling on top, descendants above ancestors), and `ZIndexBehavior.Global` compares the objects' own `ZIndex` then tree order.
- Only the winner is notified or reported. No droppable under the pointer → callbacks receive `undefined` and nobody gets `drop`.
- Enter/leave: `dragEnter` fires on a droppable when it becomes the winner during a move, and `dragLeave` when it stops being the winner (another target wins, the pointer leaves, the drag is released, or the `Draggable` unmounts mid-drag). Every enter is followed by exactly one leave. A target that only becomes the winner at the release point gets `drop` without an enter.

## Rendering and layout

- While not dragging, `Draggable` renders only the cloned child in its original position, with no wrapper.
- While dragging:
  - The original child stays mounted with `Visible = false`.
  - If `placeholder` is enabled, a themed placeholder `Frame` named `DraggablePlaceholder` is rendered in the original's place with its starting `Position`, `AnchorPoint`, size, `LayoutOrder` and `ZIndex`.
  - A preview is portalled into the nearest `OverlayProvider`'s overlay frame, positioned in overlay-local coordinates, sized to the original's captured size, anchored at `(0, 0)`, `Visible`, with `ZIndex = 100001`. Without `renderOverlay` it is a second clone of `children`. Without an `OverlayProvider` there is no preview (no crash).
  - Everything in the preview is inert: `Draggable.Handle`s start nothing, `Droppable`s and nested `Draggable`s don't register, and `Tooltip`s never open.
  - Tooltips inside the original (hidden) child are closed for the duration of the drag.
- The `ref` passed to `Draggable` itself is not attached to any instance (known limitation, tracked in ISSUES.md).

## Theme

Draggable-specific theme values live under `theme.components.draggable.placeholder`:

- `backgroundColor` and `backgroundTransparency` style the placeholder's fill.
- `borderColor` and `borderThickness` style an inner (`Enum.BorderStrokePosition.Inner`) stroke around the placeholder.
- `cornerRadius` rounds the placeholder's corners via the shared `Corners` decorator.

The call site passes `BackgroundTransparency={0.3}`, but `Placeholder` spreads its props before applying the theme's `backgroundTransparency`, so the theme value is what renders and the `0.3` is dead (see ISSUES.md).

There is no configurable animation: the preview follows the pointer directly.

## Story

The story should demonstrate:
- Two or more `Draggable` elements picked up by their `Draggable.Handle` and moved, including one whose handle is a native element.
- `Droppable` targets that highlight through `onDragEnter`/`onDragLeave`, one accepted drop (item moves between lists) and one rejected drop (released outside any `Droppable`, snapping back).
- Two overlapping `Droppable`s where only the one drawn on top receives the drop.
- A `retainPosition` example (a draggable window) alongside a list-reordering example that uses `placeholder`.
- A `renderOverlay` example (e.g. a small icon as the preview) and an item with a `Tooltip` that stays closed while dragged.
- An `inputTypes` example (e.g. right-button drag) that shows `info.inputType` on drop.

## Loom

- The Loom scene should show at least one drag-between-two-drop-zones interaction using `placeholder`, since this is the primary use case.

## Implementation notes

- `Draggable.Handle` injects its handler through `ElementHelper.cloneWithEvents`. `@rbxts/react` only translates `Event={{...}}` into `React.Event.*` keys inside its own `createElement`; `React.cloneElement` skips that, so a raw `Event` table on a native child becomes `instance.Event = {...}`, which throws and unmounts the whole root. Native children get `React.Event.InputBegan` keys (and the child's existing handler is read from that key, since `props.Event` is always `undefined` there); component children get a merged `Event` table.
- Droppables are looked up from `GlobalRegistry`, not the context registry, so targets in another React root or outside any `RegistryProvider` are found. Registration also goes into the context registry so `registry.get(instance, DroppableRegistryKey)` keeps working for consumers and tests.
- `findDroppable` picks the winner with a linear scan over `GuiHelper.isRenderedAbove` instead of sorting, because Luau's `table.sort` isn't stable and the old descending-`ZIndex` sort kept the *last* match (the lowest `ZIndex`). It also called `drop` on every overlapping match on every move, which is why `onDrop` used to fire while hovering.
- Hover identity is compared by `guiObject`, not registration object, because a `Droppable` recreates its registration when `id` changes.
- The drag-end filter compares `UserInputType` and `KeyCode` only, not `InputObject` identity; with several fingers down, any touch release ends a touch drag.
- `DragStateContext` (`{ preview, dragging }`) is how nested components learn they are inside the preview or inside a dragged original. `dragging` is OR-ed with the parent value so tooltips inside a dragged window's nested items also close. The preview gets the constant `PREVIEW_DRAG_STATE`.
- `contextValue.isDragging` is initialised from `dragInformationRef` so a mid-drag re-render (new inline callback props → new context value → new registration) doesn't reset it and let a second drag start.
- The unmount cleanup sends the pending `dragLeave` with `DragInformation.root`, captured in `beginDrag`, not `rootRef.current`. The Luau reconciler detaches a deleted host component's object ref in the mutation phase, before passive effect cleanups run, so `rootRef.current` is already `nil` there.
- `isInteractiveDescendantAtInput` scans only the handle's own descendants; the old version searched the whole highest `Frame` ancestor.
- Under a [UiScaleRoot](./uiscaleroot.md), the drag's `overlaySize` and `overlayPosition` stay in screen pixels in state and are converted with `toDesignPixels(..., useUiScale())` at render for the placeholder size and the preview's overlay-relative position and size. `retainPosition` converts the final top-left and anchor offset the same way before writing `root.Position`.
- The preview portal is wrapped in `OverlayScaleFrame` with `ZIndex={100001}` (the preview's own `ZIndex`), see the portal notes in `layout/uiscaleroot.md`.
- Drop-target hit-testing and `DragEventInfo.position` stay in screen pixels: they compare input positions with `AbsolutePosition`s only.
