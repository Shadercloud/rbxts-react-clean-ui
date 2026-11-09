# Changelog

## 2.0.3

### Fixes

- **Controlled `Input` no longer loses keystrokes.** In controlled mode the box's `Text` was rewritten to `value` on every commit, so a render worked out before the next keystroke could put "2" back after the user had typed "24". While the box has focus, `value` is no longer written into it; `onChange` still fires on every keystroke. A changed `value` is applied when focus is lost, or straight away while the box isn't focused, so a parent that reformats on blur still sees its value appear. Uncontrolled mode gets the same guard.
- **`Tooltip` works on a bare `HoverButton`.** `HoverButton` ignored a top-level `Event` prop, so the hover handlers `Tooltip` adds were dropped and the tooltip never opened. `HoverButton` now accepts an optional `Event`, which runs after the matching `default.Event` (or state set) handler, and forwards `ref`. Wrapping the button in a `Container` is no longer needed. Buttons that only use `default.Event` behave as before.

## 2.0.2

### Fixes

- **`Slider` keeps its height when only `width` is set.** The default size only applied when both `width` and `height` were unset, so `<Slider width="100%" />` was 0px tall and its track and handles collapsed (in Roblox and in the docs' Loom previews). Each axis now falls back on its own: width to 100%, height to the theme height. A Slider given only `height` is now full width instead of 0px wide.

## 2.0.1

### Fixes

- **Components render in the Loom browser preview again.** Browser React passes a missing forwarded ref as `null`, which `Text`, `Scroller` and `BreakpointProvider` didn't guard against, so any scene containing them crashed with "Cannot set properties of null". Refs now go through a null-safe `ElementHelper.assignRef`.
- **Loom runtime gaps.** `Select` no longer requires `Enum.ItemLineAlignment`, `Text`'s shrink-to-fit uses `FindFirstChildOfClass`, and `Tooltip` treats a missing `GuiService.TopbarInset` as no topbar. Behaviour in Roblox is unchanged.
- **`Table` sizes to its columns in Loom.** Column-width reports from `AbsoluteSize` changes are now deferred, so an auto-width table no longer collapses to zero width in the preview.

### Known issues

- The Loom preview of `Text`'s `maxWidth` wrapping, `outline` and `shrinkToFit` (the Text page's "Fitting text" demo) doesn't match Roblox, because Loom doesn't yet support those engine features ([astra-void/loom#43](https://github.com/astra-void/loom/issues/43)). They work in Roblox.

## 2.0.0

### Behaviour changes (check before upgrading)

- **Theme corner radii can now be tokens.** Every `cornerRadius` theme key (and the `CssCornerRadius` fields) is now `CssRadius` (`CssSize | "sm" | "md" | "lg"`) instead of `CssSize`. Code that only *sets* radius values is unaffected. Code that *reads* one and passes it to `SizeHelper.toUDim` no longer type-checks; use `SizeHelper.toRadius(theme, value)`, which resolves tokens from `theme.radius`.
- **Modal only takes the selection for gamepad players.** A modal used to set `GuiService.SelectedObject` on every open, so mouse, keyboard and touch players saw Roblox's selection outline. It now selects `initialFocus` (or its panel) only while the last input is a gamepad, and follows input switches while open: switching to a gamepad selects into the topmost modal, and switching away clears a selection inside it. On close, the previous selection is restored for gamepad players and cleared otherwise. Pass `selectionMode="always"` for the old behaviour.
- **`Checkbox` and `Switch` are controlled when `checked` is passed.** `checked` used to only seed the initial state, and `onChange` fired once on mount with that value. Now a passed `checked` controls the value: the control shows the prop, and a click or `Fieldset.Label` activation calls `onChange(!checked)` without changing internal state, so a `checked` without an `onChange` that feeds it back is frozen. `onChange` never fires on mount or when the prop changes. For the old seed-only behaviour, use the new `defaultChecked`.

### Additions

- **`Checkbox` label and `Switch` `LayoutOrder`.** `Checkbox` takes an optional `label` (clicking it toggles), styled by the new optional theme key `checkbox.label?: { typography?, textColor?, gap? }`. `Switch` takes `LayoutOrder`.
- **Styleable, clickable `Badge`.** Per-instance `BackgroundColor3`, `BackgroundTransparency`, `textColor`, `iconColor` (falls back to the text colour), `borderColor`, `borderThickness`, `borderTransparency`, `borderPosition` and `padding`, all falling back to the theme intent as before. `onClick` turns the badge into a clickable pill with hover and press shading from the new theme keys `badge.hoverDarken` and `badge.pressDarken` (Default and Sandstone darken by 0.08 / 0.16; Dark lightens by 0.1 / 0.2), or from the `hoverStyle` / `pressStyle` props (`BadgeStateStyle`).
- **`FlexItem` direction and optional layout.** `direction?: "horizontal" | "vertical"` sets its list layout's direction, and `layout={false}` drops the layout so a child `VStack` or `HStack` can own it, e.g. a filling column `<FlexItem layout={false}><VStack>…</VStack></FlexItem>`. `ItemLineAlignment?: Enum.ItemLineAlignment` sets where the item sits within its line in a wrapping list layout.
- **Press-down activation.** `Button` and `HoverButton` take `pressOn?: "down" | "up"` (default `"up"`). With `"down"`, a mouse or touch press fires `Event.Activated` on press-down instead of release, and `onRelease?: (button, input) => void` fires when that press ends, even if the pointer was dragged off, for on-screen controls like sprint. Gamepad and keyboard activation is unchanged and gets no `onRelease`.
- **`Button` `fill` and `width`; `width` on `Select` and `Increment`.** `Button` takes `width` and `fill` (grow to share a row equally, as a direct child of a list layout). `Select` and `Increment` now honour `width` instead of always filling their parent; unset, they fill it as before.

- **`GamepadSelectionGuard` and `useGamepadSelection`.** `<GamepadSelectionGuard>` (place-wide, renders no instances) clears any selection set while the last input isn't a gamepad. It also blocks Roblox's keyboard UI-navigation toggle, so leave it out (or pass `enabled={false}`) in games that use keyboard navigation. `useGamepadSelection(target?, options?)` is the shared hook behind it and Modal, with `enabled`, `scope`, `mode`, `restoreOnRelease`, `clearOnSelectionChange` and `canTakeSelection` options. `GamepadHelper` exposes `isGamepadInputType`, `isGamepadActive`, `trySetSelectedObject` and `isSelectionWithin`.

- **Sunk-field theming for `Input` and `Select`.** New optional theme keys on `theme.components.input` and `.select`, for fields that look cut into the panel behind them. Unset, both components draw exactly as before.
  - `boxShadow?: CssShadow | CssBoxShadow`: an outer shadow. The table form carries its own colour, so a 0px-blur 1px-down light lip can be drawn.
  - `innerShadow?: { color: Color3; transparency: number; size: number }`: a dark band inside the border along the top edge, fading out `size` px down, clipped to the corners and drawn under the text.
  - `states?: { hover?, focus?, disabled? }`: each overrides `borderColor`, `borderThickness`, `backgroundColor`, `backgroundTransparency` and `backgroundGradient`. Priority is disabled, then focus, then hover. Input is in focus while its TextBox is focused; Select while its list is open.
  - Select only, `caret?: { size?, backgroundColor?, backgroundTransparency?, backgroundGradient?, borderColor?, borderThickness?, cornerRadius?, iconColor?, margin? }`: a box behind the caret icon. `margin` may be negative.
  - Select only, `dropDown?: { cornerRadius?, borderColor?, borderThickness?, boxShadow?, gap? }`: the list's own corners, border, shadow and gap below the field. Each falls back to the field's value; `gap` defaults to 0.
- **`disabled` prop on `Input` and `Select`.** Input's TextBox can't be edited or focused (and drops focus); Select's list can't be opened (and closes if open). Both use `states.disabled`, and ignore a paired `Fieldset.Label`.
- **`Container` border, padding and corner radius.** New optional props `borderThickness`, `borderColor`, `borderTransparency`, `borderPosition` (`"inner" | "outer"`, default `"inner"`), `padding` (`CssPadding`) and `cornerRadius` (`CssRadius`), replacing hand-written `uistroke`/`Padding`/`Corners` children. Nothing extra is drawn when they're unset.
- **`HoverButton` border props.** The same four border props, set top-level or per state (`default`/`hover`/`focus`; the state value wins).
- **Radius tokens.** `Corners.radius` and every radius prop and theme key accept `"sm"`, `"md"` and `"lg"`, mapped to `theme.radius`. New `SizeHelper.resolveRadius` and `SizeHelper.toRadius`.
- **Interactive, pinned and long-press tooltips.** New opt-in `Tooltip` props, all ignored when `open` is set. Unset, tooltips behave as before.
  - `interactive?: boolean`: the pointer can move from the trigger onto the popup, which stays open while the pointer is over either and closes `theme.components.tooltip.closeDelay` seconds (default 0.15) after it leaves both.
  - `pinOnPress?: boolean`: a click or tap on the trigger pins the tooltip open until the trigger or the popup is pressed again.
  - Interactive and `pinOnPress` popups are `Active`, so they block clicks to whatever is behind them.
  - `longPress?: boolean`: on touch, holding for `theme.components.tooltip.longPressDelay` seconds (default 0.5) shows the tooltip until the finger lifts.
  - A tooltip opened inside an interactive or pinned tooltip keeps its parent open, and a trigger covered by an open interactive popup doesn't open its own tooltip.
- **Min and max sizes.** `SizeElementProps` gains `minWidth`, `maxWidth`, `minHeight` and `maxHeight` (`CssPixelSize`: `number | "${number}" | "${number}px"`), so "fills the page, capped at its desktop width" is `width="100%" maxWidth={1200}`. Any of them draws one `UISizeConstraint` (named `SizeConstraint`) on the element the size props size: Container's inner element (not the `center` wrapper), and through it Box, FlexItem, Card, ProgressBar, Table and Toast, plus FadeGroup, Scroller (the window, not the canvas; a Scroller with any of these props is wrapped in a `Frame` named `Scroller` that carries the constraint, so give it a size), Slider and Modal (which stays centred and draggable). An unset min is 0 and an unset max is unlimited; nothing is drawn when all four are unset. The max limits cap sizes set with `Size`, `width`/`height` or `%`, but not growth from `AutomaticSize` (a Roblox `UISizeConstraint` limit); the min limits apply to both. Tooltip popups don't honour size props yet.
- **Scroller gutter, callbacks and ref.** `Scroller` now forwards a ref to its `ScrollingFrame` (and `ScrollerProps` is exported). New optional props:
  - `stableGutter?: boolean`: always reserve the scrollbar's gutter, so content doesn't shift sideways when the bar appears.
  - `onScroll?: (canvasPosition: Vector2, scroller: ScrollingFrame) => void`.
  - `onNearEnd?: () => void` with `nearEndThreshold?: number` (pixels, default 0), for infinite and cursor-paged lists. It fires once per approach to the end and re-arms when the canvas grows or the user scrolls away. It also fires on mount when the content doesn't fill the window, so guard against loading twice.
- **Scroller track and thumb theming.** New optional `theme.components.scroller` keys `trackColor`, `trackTransparency`, `thumbBorderThickness` and `thumbBorderColor`. Roblox's scrollbar has no track and its thumb can't be outlined, so when any of these are set the Scroller draws its own track and thumb in a wrapper frame over the (hidden, still draggable) native thumb. A Scroller styled this way needs an explicit or parent-relative size.
- **Text wrapping, outline, shrink to fit and text size cap.** New optional `Text` props. Unset, Text renders the same tree as before.
  - `minWidth`, `maxWidth`, `minHeight`, `maxHeight`: the shared size limits. `maxWidth` alone gives an auto-sized label that wraps once it reaches that width.
  - `outline?: TypographyOutline | boolean` (`{ color?, thickness?, transparency? }`): a contextual `UIStroke` around the text, for words read over the 3D world. `true` uses the theme style's outline or black, 1px; `false` turns off a theme outline. New theme key `TypographyStyle.outline`.
  - `shrinkToFit?: boolean` and `shrinkMinScale?: number`: scale the text down (never up) to fit `maxWidth` or the parent's inner width, for letter-spaced text that can't wrap.
  - `minTextSize?` and `maxTextSize?`: cap `TextScaled` text through a `UITextSizeConstraint`.
- **Pagination without a page count.** `totalPages` is now optional. Without it, Pagination shows only Prev and Next, and Next is enabled while the new `hasNextPage?: boolean` is true.

## 1.7.0

### Additions

- **`Tabs.Title` icons.** New optional `icon?: IconName` draws an icon before the title text, or on its own when `text` is omitted or empty, for icon-only tab rows. The icon takes the title text colour in every state. `iconScale?: ScaleSize` overrides its size (default `theme.default.scale`, the scale the title typography uses). Titles without an icon render exactly as before.
- **`theme.components.tabs.button.iconColor`** (optional `Color3`): one fixed colour for tab title icons in every state. Unset, the icon follows the title text colour.

## 1.6.1

### Fixes

- Theme fonts whose enum name differs from their family (Fantasy, Garamond, Bodoni, Antique, ...) now render correctly instead of falling back to Builder Sans.

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
