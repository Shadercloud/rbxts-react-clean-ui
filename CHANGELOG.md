# Changelog

## 1.6.0

### Behaviour changes (check before upgrading)

- **Tooltips stay on screen.** A tooltip now measures itself before it appears and keeps itself inside the overlay, clear of the Roblox topbar. `placement` (`Top`, `Bottom`, `Left`, `Right`, default `Top`) is now the *preferred* side: if the popup doesn't fit there but fits on the opposite side, it opens on the opposite side; if it fits on neither, it takes the side with more room. It then shifts along the edge to stay inside, and the pointer moves the other way so it still points at the middle of the trigger, staying clear of the rounded corners. `Center` never flips. A tooltip that used to open off-screen or under the topbar's core buttons now opens somewhere else.
- **The topbar band is excluded.** The band's bottom is `GuiService.TopbarInset.Max.Y`, converted into the overlay's ScreenGui space, so it works with `IgnoreGuiInset` on or off, and it follows `TopbarInset` changes.
- **No flash on show.** The popup stays fully transparent until it has been measured once, and the fade-in starts from there.

### Additions

- **`placement="Auto"`.** Picks the best side for where the trigger is. A side where the popup fits beats one where it doesn't; among those, the one needing the least sideways shift wins (so the popup stays centred on the trigger), then the one with the most room. Ties go to Top, Bottom, Right, Left. If no side fits, the side with the most room wins.
- **`theme.components.tooltip.edgeMargin`** (number, px, default `8`): the minimum gap between a tooltip and the overlay's edges and the topbar.

### Fixes

- A `Left` / `Right` tooltip's pointer is now centred on the content when the theme's `boxShadow` is uneven. It used to sit a couple of pixels off.

## 1.5.0

### Additions

- **`Button` `modal` prop.** New `modal?: boolean` (default `false`) sets the native `GuiButton.Modal` on the Button's `ImageButton`, freeing the mouse cursor in first-person / shift-lock while the button is visible. Unrelated to the library's `Modal` component. ([#2](https://github.com/Shadercloud/rbxts-react-clean-ui/issues/2))
- **`HoverButton` forwards `Modal`.** It was previously dropped when set in `default` / `hover` / `focus`.

## 1.4.0

### Behaviour changes (bug fixes, check before upgrading)

- **Droppable `onDrop` fires once, on release.** It used to fire on every drag move, and on every overlapping target. It now fires once, when the pointer is released over the target, and only on the winning target. For hover feedback, use the new `onDragEnter` / `onDragLeave`.
- **The topmost drop target wins.** Where targets overlap, the one drawn on top now wins, taking into account ZIndex, `ZIndexBehavior` (Global and Sibling), sibling and ancestor order, and `DisplayOrder` across ScreenGuis. It used to be the target with the lowest ZIndex. `onDragged` / `onDropped` report that same target.

### Fixes and additions

1. **`Draggable.Handle` wraps native elements.** `<frame>`, `<imagebutton>` and so on now work as handles. Before, a native child got a literal `Event` prop, the mount threw, and the whole root unmounted. The child's own `InputBegan` still runs. `Tooltip` had the same bug when wrapping a native element, and it is fixed too.
2. **Choose which inputs start a drag.** New `Draggable` prop `inputTypes?: Enum.UserInputType[]`, which defaults to `[MouseButton1, Touch]`. A drag ends when the same input type is released. Every drag callback now receives a `DragEventInfo` (`{ inputType, input, position, id? }`), so you can treat a right-drag differently: `Droppable.onDrop(draggedObject, info)`, `Draggable.onStartDrag(info)`, `onDragged(droppable, info)`, `onDropped(droppable, info)`.
3. **`onDrop` fires once, on release** (see above). New `Droppable` props `onDragEnter` / `onDragLeave` (`(draggedObject, info) => void`) fire on the winning target only.
4. **The topmost drop target wins** (see above). Targets that are hidden, clipped away at the pointer, or inside a disabled ScreenGui are ignored.
5. **Droppables are found wherever they are mounted:** sibling trees, separate ScreenGuis, separate React roots. They register in a shared module-level registry, so you no longer need a full-screen wrapper frame or a provider.
6. **The drag preview is inert.** Tooltips, handles, droppables and nested draggables inside the preview are disabled, and tooltips inside the item being dragged close during the drag. New `Draggable` prop `renderOverlay?: () => ReactNode` renders a custom preview instead of cloning the item.
7. **Accordion opt-in sizing and modes.** New props, all default `false`:
   - `autoSize`: the height follows the content.
   - `multiple`: several items can be open at once. `value` and `defaultValue` become `string[]`; the type is `AccordionMultipleProps`.
   - `keepMounted`: closed content stays mounted and hidden, so its state survives.

   Also fixed: reopening a section while it was still closing left it at height 0.
8. **Tooltip `disabled` and controlled `open`.** `disabled` wins over `open`. The child element tree is identical in every state, so it is safe to toggle under a `Draggable.Handle` mid-drag.
9. **New `FadeGroup` component.** A `CanvasGroup`-backed container that fades or tints its whole subtree through `GroupTransparency` / `GroupColor3`. It takes the same size and position props as `Container`.
10. **`Tabs.Body` accepts `LayoutOrder`, and `Button` has `padding?: CssPadding` in its types.** `padding` already worked at runtime. Also fixed: a Button's icon, spinning or not, now gets its `LayoutOrder` (1), and `LayoutOrder` on `Button.Icon` is no longer ignored.

### Other

- `Text` now applies `Size` and `AutomaticSize` when passed. Before, it always used `0,0` with `AutomaticSize.XY` and ignored both props. If you already pass either one to `Text`, check that layout.
- The Wooden theme defines `draggable.placeholder` colours.

### Tooling

- Added `eslint.config.js`. ESLint 9 no longer reads `.eslintrc.json`, so `npm run lint` had stopped working.
