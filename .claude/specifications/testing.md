# Testing

Implementation notes for src/Tests — test files carry no comments, so non-obvious rationale lives here. Running tests: see AGENTS.md → 'Running the tests in this repo'.

## Helpers

### `src/Tests/Helpers/layout.ts`

- **`mountInScreenGui` hosts in a `ScreenGui` under `CoreGui`** because the engine only lays out GUI trees it renders. On a detached Frame, `AbsoluteSize` is recomputed lazily (only when read, so its `Changed` signal never fires after a later host resize), and text is never measured (`TextBounds` stays NaN, so a wrapped `AutomaticSize` TextLabel is 0 tall). Width tracking (Grid) and text-driven heights only behave like real UI in a rendered tree.
- **`update` uses `React.createElement` rather than JSX** so that `layout.ts` can stay a plain `.ts` module that both `.test.ts` and `.test.tsx` files can import. It always wraps the tree in `ThemeProvider` with `DefaultTheme`.
- **`resize` waits one extra frame** after the host reports its new `AbsoluteSize`, so scale-based children and wrapped text can settle against the new size.
- **`waitForLayout` polls for 30 frames.** Anything that settles more slowly needs its own loop (see Tooltip under Engine and framework quirks).
- **`waitForDescendant` vs `waitForGuiObject`:** `waitForDescendant` works on any Instance, including rect-less layout objects such as `UIGridLayout`. `waitForGuiObject`'s default predicate is "non-zero `AbsoluteSize`", so an element that is legitimately 0 in one axis needs an explicit predicate. Examples are a 0% ProgressBar fill and ToastContainer's 0px-tall Container.
- **`EDGE_EPSILON = 0.5`:** scale-based sizes come back with float noise (e.g. `right=300.00002` in a 300px parent). `assertContained` allows that much slop on every edge. `intersects` uses strict inequalities plus the epsilon, so siblings that only share an edge don't count as overlapping.
- **How `assertAllDescendantsContained` walks the tree:**
  - Each visible GuiObject is checked against its nearest `ClipsDescendants` ancestor, or against the container if there is no such ancestor.
  - Non-visible subtrees are skipped because their rects are stale.
  - Non-GuiObject children (`UIListLayout`, `UIPadding`, ...) are walked through, since they can still parent GuiObjects.
  - A deliberately oversized child inside a clipping parent still fails the check, because it is measured against that parent. Examples are Pie's `SegmentFill` (twice the wedge's size) and ProgressBar's `Stripe` (one tile wider than `Fill`). Check around them instead: Pie checks wedges only, and ProgressBar's `fillContained` sets `striped={false}`.
- **The `ignore` option** exempts an instance from the check without pruning the walk. Its children are still checked, against the current clipping ancestor. Use it for invisible scroller chrome: a Scroller's `ScrollingFrame` has a transparent scrollbar gutter that extends past the surface it sits on, and `ScrollerContent` is sized to that frame. See `ignoreScrollerChrome` in `Menu.test.tsx`.
- **`assertTextFits` has a fallback for wrapped text.** A `TextWrapped` label reports `TextFits=false` whenever it had to wrap at all, so for wrapped labels the helper compares `TextBounds` against `AbsoluteSize` (with 1px slack) instead.
- **`assertStackedVertically`/`assertStackedHorizontally` loop from 1 and compare `[index - 1]` with `[index]`.** roblox-ts miscompiles an `index + 1 < size()` loop bound into a numeric `for` that runs one step too far.

### Helper tests next to test utilities

- `src/Tests/Helpers/` holds both test utilities (`layout.ts`) and the mirrored tests for `src/Helpers/` (`css.helper.test.ts`, `color.helper.test.ts`). Discovery only matches `**/*.{test,spec}.{ts,tsx}`, so the utilities are never picked up as tests. Keep new utilities free of a `.test`/`.spec` suffix.

## Engine and framework quirks

- **Roblox datatypes don't exist under Lune.** The Lune shim only provides the roblox-ts runtime (`TS.*`), not the Roblox globals, so `Color3`, `ColorSequence`, `NumberSequence`, `Vector2`, `UDim2` etc. are `nil` there. A module-level `Color3.fromRGB(...)` fails the whole module at load (`attempt to index nil with 'fromRGB'`). Any test that builds these values is tagged `@Tag("Studio")` even if it mounts nothing. The css/color helper gradient tests are examples. Only tests over plain numbers, strings and tables can be `@Tag("Lune")`. `--lune` still prints a `failed to load test module ... attempt to index nil with 'fromRGB'` warning for those Studio-tagged files. That is the same expected noise as the `@rbxts/react` "module not found" warnings, and they aren't counted.

- **Real pointer or hover input can't be synthesised.** Components that clone a child and inject handlers are driven through a `forwardRef` stand-in child that captures the injected `Event` table, and the test calls the handlers directly. That is the same code path real input takes.
  - Tooltip: `HoverTarget` calls `MouseEnter`/`MouseLeave`.
  - Draggable: the handle calls `InputBegan` with a plain-table `InputObject` stand-in, the same approach as `Modal.test.tsx`. Moves and releases call `registration.draggable.updateDrag`/`endDrag` directly. Those are the same functions `Draggable.Handle`'s `UserInputService` `InputChanged`/`InputEnded` listeners call, and the test runner cannot fire `UserInputService` signals.
  - Droppable: the test calls `registration.drop` directly, as `Draggable.findDroppable` does.
  - Tabs and Accordion: `TabButton-<value>` and `AccordionHeaderButton-<value>` are `imagebutton`s rendered inside `HoverButton`, so there is no child to inject through. `activateButton` in `src/Tests/Helpers/fiber.ts` (shared by `Tabs.test.tsx` and `Accordion.test.tsx`) walks the root's fiber tree (`root._internalRoot.current`, via `child`/`sibling`) to the host fiber whose `stateNode` is the button and calls `memoizedProps[React.Event.Activated]`. `@rbxts/react`'s `createElement` rewrites `Event={{ Activated }}` into that `React.Event.Activated` key, and the key object is cached per event name, so it is the same handler the engine would call. `VirtualInputManager.SendMouseButtonEvent` is not an option: the test runner lacks the `RobloxScript` capability and the call throws.
- **Driving providers from outside the tree.** A small harness component stores the provider's value in a module-level variable: `ToastHarness`/`useToast`, `dragState.registry` (via `RegistryHarness` in `src/Tests/Helpers/drag.tsx`) in Draggable/Droppable, and `RegistryHarness` in `Modal.test.tsx`.
- **Group needs a `RegistryProvider`.** `Group.Element` takes its id from `RegistryContext.GetNextId`. Without a `RegistryProvider`, every element shares the id `""`, the reported widths collide, and the Group never propagates the widest width. Wrap Group/`group` fixtures in `RegistryProvider`, as `CleanUiProvider` does (Group, Menu).
- **Group width propagation is asynchronous** (a `Change:AbsoluteSize` handler followed by a Group state update). Poll until members agree before measuring (Button `groupAlignsWidths`, Menu `waitForGroupSettled`).
- **Overlay portals.** Select's dropdown, Tooltip's popup and Draggable's preview portal into `OverlayContext.overlay`. Wrap them in `OverlayProvider` and wait for its `"OverlayProvider"` frame before opening; the frame is published through a ref callback plus a state update, so it isn't there on the first frame.
- **Registry registration lags the instance.** It goes through a callback ref → state → effect chain, landing a frame or two after the instance appears (Draggable/Droppable `waitForRegistration`).
- **Animations must settle or be disabled before measuring:**
  - Accordion: `animationDuration={0}` makes the open content reach its final height synchronously and unmounts closed content immediately.
  - Toast: `duration={math.huge}` stops auto-dismiss mid-test.
  - BarChart: see the BarChart section below.
  - ProgressBar: the fill tweens for 0.2s, so the test polls the fill's width.
  - Tooltip: `hide()` clears the popup only after `fadeDuration` (0.25s), which can exceed `waitForLayout`'s 30-frame budget in Studio, so `waitForRemoval` (shared in `layout.ts`) polls for 120 frames by default.
- **Asserting that something does *not* happen** (no popup, no drag start) waits a fixed number of frames first with `settleFrames` from `layout.ts`, so a stray state update or effect has time to commit and fail the test. A bare assertion right after the trigger would pass even if the behaviour were wrong.
- **HStack/VStack render a fragment** (`UIListLayout` plus children) with no instance of their own. Fixtures give them a real parent frame (`"Stack"`) to lay out and measure against.
- **VStack's default `HorizontalFlex=Fill`** stretches children to full width. It masks horizontal centering and Group width, so set it to `None` there (VStack `centerAlignment`, Group fixture). Fieldset relies on the stretch: its `AutomaticSize.XY` Container is content-sized until the Fill flex applies.
- **Duplicate instance names.** `FindFirstChild` only ever returns the first match. When siblings share a name, collect them from the parent's `GetChildren()`, which is declaration order when no `LayoutOrder` is set: Pie `SegmentWedge`s, Menu `MenuItem`s, Table `TableRow`s. Fieldset's two `FlexItem` slots are found through their distinct children instead.
- **Bounding text.** The `Text` component is always an `AutomaticSize.XY` TextLabel with a `(0,0)` Size, so on its own it grows to one line and never wraps.
  - To bound it, use a `UISizeConstraint` child (`Text.test.tsx` `narrowText`) or `Text`'s own `maxWidth` prop (`Text.constraint.test.tsx`).
  - For text whose height must follow its container's width, use a native `textlabel` (Grid `relockOnWidthChange`).
- **Float properties are stored as 32-bit floats.** `BackgroundTransparency = 0.4` reads back as `0.4000000059604645` and fails `Assert.equal`. Themed-value tests use binary-exact fractions (`0.25`, `0.5`).
- **Theme-driven tests nest a `ThemeProvider`.** `withMounted` always wraps in `DefaultTheme`; an inner `ThemeProvider` with `extendTheme(DefaultTheme, {...})` overrides it for the subtree (Tabs theming, Input/Select background, Button under `WoodenTheme`).
- **Values coupled to `DefaultTheme`** (`src/Theme/themes/default.theme.ts`). If a default-theme edit breaks these tests, update the constants rather than suspecting the component:
  - Breakpoints: `xs 100 / sm 200 / md 300 / lg 400 / xl 500`, used by Grid, Row and Fieldset.
  - Spacing: `md = 12`, which is Row's `DEFAULT_GAP`, and `xl = 24`. HStack/VStack gaps are half the resolved spacing (`math.ceil(GetPadding / 2)`), giving 6 and 12.
  - Icon: `iconSize.md = 20` (`DEFAULT_SCALE_SIZE`).
  - ProgressBar: `progressBar.height.md = 16` (`DEFAULT_TRACK_HEIGHT`).
  - Where a key is optional (`theme.spacing` is a `ScaleSizeValue`), read it from `DefaultTheme` instead of hardcoding the value (Padding `spacingKeyAllSides`).

## `Grid.test.tsx`

- `waitForFreshLock` waits for a newly created locked `UIGridLayout`, not the old one. That proves the measure/lock cycle actually re-ran.
- `relockOnWidthChange` is a regression test. The invalidation effect used to depend only on `[cols, gap, childCount]`. `cols` is a plain number here, so the only thing that changes is the Grid's own measured width, and that alone must unlock, re-measure and re-lock. Widening back to the original width used to leave every cell stuck at the tallest height ever measured; the height must return exactly to the first lock's value.
- A `childCount` change on its own (same cols, gap and width) must also invalidate the lock.
- The cell-size `@Each` row `[5, "sm", 8, 0.2, -7]` expects the offset floored from -6.4 to -7. Flooring stops per-cell pixel rounding from summing wider than the container and wrapping early (`Grid.tsx` `cellWidthOffset`).
- With `width` unset, the Grid must still fill its parent. Before `width` existed, the root frame was hardcoded to `UDim2.fromScale(1, 1)`.

## Gradient (`Gradient.test.tsx`, `css.helper.test.ts`, `color.helper.test.ts`)

- These are regression tests for the colourless-gradient crash and the out-of-order-stops crash. `Gradient` used to cast its partial `value` to a full `CssBackgroundGradient`, so `{ rotation: 45 }` or `{ colors: [] }` reached `buildColorSequence` and threw. `ColorSequence` also throws on non-ascending keypoint times.
- `colorlessValueEmitsNothing` proves the mount didn't throw by waiting for the `Target` frame. There is no error boundary, so a throw inside `Gradient` unmounts the whole tree and `Target` never appears.
- The shared-stop `@Each` rows guard the index tie-break in `buildColorSequence`'s sort, which exists because Luau's `table.sort` isn't stable. The five-colour row (`[0, 0.8, 0.4, 0.4, 1]`) makes the sort move the tied pair past another keypoint, not just leave already-ordered entries alone. The "tied with the first/last" rows check that an interior stop of exactly `0`/`1` sorts after/before the forced endpoint.
- `color.helper.test.ts` passes `getIntentColors` a minimal theme stub cast to `ThemeTemplate`: only `colors.intents.primary`/`danger` with a `default` scheme. `getIntentColors` reads nothing else from the theme, and the stub keeps the merge assertions independent of `DefaultTheme`'s colours. If `getIntentColors` starts reading more of the theme, extend the stub.
- The `stops` cases lock down the gradient merge rule in [shared-modules.md](../architecture/shared-modules.md#srchelperscolorhelperts). If the rule is changed deliberately, update the tests and the doc together.
  - `colorsResetStops`: a layer that sets `colors` drops the earlier `stops`, so the merged `stops` is `undefined` and the colours are spaced evenly. Stops tuned for a different colour list would be misplaced.
  - `ownStopsKept`: a layer that sets both `colors` and `stops` keeps its own `stops`.
  - `stopsRepositionColors`: a layer that sets `stops` without `colors` moves the inherited colours.
  - `colorsKeepRotation`: the reset only covers `stops`. Earlier `rotation`/`transparency`/`offset` are still inherited.
  - `undefinedStopsIgnored`: an explicit `stops: undefined` counts as unset, because a `nil` field doesn't exist in the Luau table, so the spread never overwrites the inherited `stops`.

## BreakpointProvider (`BreakpointProvider.test.tsx`, `breakpoint.context.test.tsx`)

- Consumers are module-level harnesses (`BreakpointHarness`, `ValueHarness`) that record `useBreakpoint`, `useBreakpointValue` and a render counter, the same pattern as `ToastHarness`.
- The provider publishes `"xs"` before its first measurement, so the `xs` rows pass even before measuring. They wait for the provider frame to reach the host width and settle a couple of frames first. The other rows are what prove the measurement.
- `rerendersOnCrossing` counts the harness's renders. The harness is a stable child element of the provider, so it only re-renders when the context value changes. Two resizes inside `sm` must add no renders, and crossing into `md` must add exactly one.
- The viewport-fallback test can't resize the camera (`ViewportSize` is read-only). It builds a theme whose `md` threshold is exactly the current viewport width, inside a 100px host that would resolve to `sm` against those thresholds. So `"md"` can only come from the viewport, and never from the initial `"xs"` fallback.

## `BarChart.test.tsx`

- `VALUES = [10, 30, 20]`: `niceStep(30, 5)` is 10, so `chartMax` is exactly 30 and the tallest bar fills the whole `BarsContainer` height.
- Bars grow in over `theme.components.charts.bar.tweenTime` (0.5s by default). `waitForBarsToSettle` polls until the max bar fills the container, rather than trusting a fixed wait. It stays local because it's specific to this component's animation.

## `Pie.test.tsx`

- Values 25/25/50 put each slice entirely inside the Top or Bottom half. A slice that crosses the half boundary is split into two wedges, so these values give exactly one `SegmentWedge` per value.

## `Card.test.tsx`

- The long-header tests are regressions for the header overflowing the card. Card.Header's text is an `AutomaticSize.XY` TextLabel that grows to its full single-line width unless something constrains it.
  - `LONG_TITLE` avoids convenient wrap points near the end of each run.
  - `longHeaderContained` checks that the default `(1,1)`-scale Card keeps to the host width.
  - `longHeaderFixedWidth` pins the width (`AutomaticSize.Y` only), so any overflow has to show up as a descendant escaping the Card rect.
- Width-only sizing resolves to `AutomaticSize.Y` (`SizeHelper.GetAutoSize`), so `growsWithContent` expects the height to grow while the width stays fixed.

## `Menu.test.tsx`

- `storyFixture` mirrors `Stories/Navigation/Menu.tsx` (an auto-width Box that fills the host's height) inside a `RegistryProvider`, the way `createStory`/`CleanUiProvider` renders it.
- `MenuHeader` and every `MenuItem` belong to the same Group, and the Menu hugs the header. The Menu only reaches its final width once the Group has propagated the widest item's width, so `waitForGroupSettled` waits for that before measuring. It polls by hand so that a timeout message reports the widths at timeout, not at frame 0.

## `Tabs.test.tsx`

- `controlledClickOnlyReports` waits a few frames after the click before asserting the panel is unchanged, so a stray uncontrolled state update would have time to commit and fail the test.
- The root `VStack` layout of `Tabs` is found directly under the host (`tabsGap`) because `Tabs`, `ThemeProvider` and `VStack` render no instance of their own.
- `listFillShares` compares title widths rather than exact pixels: with `HorizontalFlex = Fill` and `AutomaticSize.Y` the titles split the list's inner width, which depends on the list padding tokens.

- `bodyLayoutOrder`/`bodyLayoutOrderDefault` read `TabsBody.LayoutOrder` directly. The default case expects `0` because an unset `LayoutOrder` prop leaves the engine default.
- The icon tests use `iconTabsFixture`, a controlled `Tabs` (so the selection is exactly the `value` passed, with no mount-order claim) with five titles: text only (`text`), icon and text (`both`, `pair`), icon with no `text` (`icon`) and icon with `text=""` (`empty`). It runs under `stateTheme(0)` so the focus and default text colours differ. The icon colour is the `ImageColor3` of the `TabTitleIcon` ImageLabel (`Icon`'s `color` prop). The colour tests assume `theme.components.tabs.button.iconColor` is unset: when a theme sets it, the icon uses that colour in every state instead of the title text colour.

## `Accordion.test.tsx`

- `optionsAccordion` puts a `Counter` in item one's content: a local-state `textlabel` (`CounterText`) whose setter is published on the module-level `counterState`, the same harness pattern as `ToastHarness`. `keepMountedKeepsState` increments it, closes and reopens the item through the controlled `value`, and expects the same `CounterText` instance still reading `1`. `defaultResetsState` is its control: without `keepMounted` the content unmounts and the counter restarts at `0`, which proves the first test is sensitive to remounting.
- A collapsed `keepMounted` clip is checked through `Visible=false` and its `Size` (zero Y scale and offset), not `AbsoluteSize`: the clip is invisible, and invisible rects are stale.
- `waitForClipMatchingContent` compares the clip's height with its `Content` frame's height (1px slack) and polls for a caller-chosen number of frames, because `reopenWhileClosing` animates for 0.5s, which is longer than `waitForLayout`'s 30-frame budget.
- `reopenWhileClosing` is a regression test. The height goal used to come only from `Content`'s `AbsoluteSize` change handler. Reopening mid-close doesn't resize `Content` (only the clip shrinks), so no change fired and the clip finished tweening to 0 while open. It closes, waits one frame, asserts the clip is still mounted (still animating), reopens, and waits for the clip to reach the content height again.
- `autoSizeGrows` records the closed root height, opens item two by clicking its header, and waits until the root has grown by at least the opened clip's height (1px slack). The host is 400px tall so the opened accordion must still be shorter than it.
- Multiple-mode fixtures pass `multiple={true}` literally so the `AccordionMultipleProps` overload narrows `defaultValue`/`onValueChange` to `string[]`.

## `FadeGroup.test.tsx`

- Transparency and tint values are binary-exact (`0.25`, `0.5`, `0.75`, `Color3(0.5, 0.25, 0.75)`) because the properties are stored as 32-bit floats.
- `bindingDrivesTransparency` creates its binding inside the test so no binding state leaks between runs.
- Every fixture includes a sized `Inner` frame: an `AutomaticSize.XY` group with only layout objects would be 0x0, and `waitForGuiObject`'s default predicate waits for a non-zero size.

## `Button.test.tsx` padding

- The root `UIPadding` comes from `<Padding {...props} />`, which is keyed by `props.name`, so a named Button's `UIPadding` shares the Button's name. `rootPadding` finds it by class among the root's direct children (`FindFirstChildWhichIsA`) instead of by name.
- `defaultPaddingFromTheme` reads `DefaultTheme.spacing[DefaultTheme.default.spacing]` rather than hardcoding 12.
- `paddingKeepsOrder` asserts the icon's `LayoutOrder` is `1` and the label's is `2`, as `Button.tsx` passes them. The horizontal stacking check alone wouldn't catch a lost `LayoutOrder`, because an unset icon order (`0`) still sorts before the label's `2`.

## `color.helper.test.ts` secondary intent

- `secondaryFallsBack` uses the `themeWith` stub, which has no `secondary` entry in `colors.intents`, so the fallback is proven against a theme lacking it. The shipped themes all define `secondary` now, so they can't show the fallback.

## `Toast.test.tsx`

- ToastContainer gives its Container an explicit Size of `(theme width, 0)`, which makes it `AutomaticSize.None`. It is 0px tall by design, with the toast VStack hanging below unclipped, so only its width can be waited on.

## `Pagination.test.tsx`

- The selected item is recognised by `BackgroundTransparency` (0 vs 1), not by colour. The unselected state inherits the base primary background, which is `#FFFFFF` in the default theme, the same as the focus colour.

## `Table.test.tsx`

- Column widths start at 0 and resolve only after every cell has reported its measurement (`TableCellContent`). `waitForColumnsMeasured` waits for all cells to have a real width, then gives rows and sections a couple of frames to settle against `totalWidth`.

## Draggable/Droppable (`Draggable.test.tsx`, `Droppable.test.tsx`, `src/Tests/Helpers/drag.tsx`)

- `drag.tsx` holds the shared drag plumbing: the `DragHandle` forwardRef stand-in that captures the injected `Event` table, `RegistryHarness`, the plain-table `pointerInput`, and the registration waits. State lives on the exported `dragState` object because importers can't reassign an exported `let`. `dragState.handleEvents` is overwritten once the drag preview renders its own `DragHandle`, so read it before the drag starts (`pressHandle` does).
- `nativeHandleMounts`/`nativeHandleStartsDrag` wrap a native `<frame>` in `Draggable.Handle`. `@rbxts/react` only translates `Event={{...}}` into `React.Event.*` keys inside its own `createElement`, and `React.cloneElement` skips that step. A raw `Event` table that reaches a host element is assigned as `instance.Event = {...}` (react-roblox `setRobloxInstanceProperty`), which throws and unmounts the whole root. That's why the first test only waits for the frame to exist. The second test finds the handler the same way as Tabs' `activateButton`: it walks the fibers to the frame's host fiber and reads `memoizedProps[React.Event.InputBegan]`.
- `dropFiresOnceOnRelease` moves over the target three times before releasing. `onDrop` has to stay at 0 until release and then reach exactly 1.
- The overlap tests declare the higher-`ZIndex` target first, so declaration order can't make it win by accident. `laterSiblingReported` uses equal `ZIndex`, where the later sibling draws on top.
- `siblingTreeDrop` portals the `Droppable` into a `SiblingRoot` Frame that the test creates, either next to `Host` in the same ScreenGui or in a second ScreenGui. The portal keeps it under the same `RegistryProvider`. The portal target has to exist before it renders, so the test mounts an empty tree first and then calls `update`. In `finally` it renders the empty tree again before destroying `SiblingRoot`, because unmounting into a destroyed (Parent-locked) instance throws.
- New drag helpers in `drag.tsx`: `pressHandle` takes an optional `UserInputType` (default `MouseButton1`) for the `inputTypes` tests; `moveTo` calls `updateDrag` with a `MouseMovement` input and waits a frame; `overlapPoint` returns the centre of two targets' intersection (and fails if they don't overlap), so cross-ScreenGui and nested fixtures don't hardcode absolute points that shift with the ScreenGui inset; `waitForGlobalDraggable`/`waitForGlobalDroppable` read `GlobalRegistry` for fixtures with no `RegistryProvider`.
- `unlistedInputIgnored` covers both halves of the `inputTypes` filter: `MouseButton2` against the default list, and `MouseButton1` against a right-only list. `@Each` rows can't hold a `nil` (a Luau array stops at the first `nil`), so the row carries a label that `inputTypesFor` maps to `undefined` or the list.
- `releaseMustMatch` releases with the wrong button first. `endDrag` is what `Draggable.Handle`'s global `InputEnded` listener calls for every release, so a left-button release reaching it mid right-button drag is exactly the real-input case.
- `enterLeaveSequence`/`enterFollowsTopmost` log `enter:`/`leave:`/`drop:` per target into one array and compare the joined string, so order, pairing and duplicates are all checked at once. The pointer in the gap (`hostPoint(200, 210)`) is inside the host but over no target; the hidden original `DragItem` is not a target.
- `leaveOnUnmount` swaps the fixture for one with `false` in the Draggable's slot, so the Droppables keep their child index and stay mounted (the test asserts the same `LeftZone` instance) while only the Draggable unmounts.
- `noProviderDrop` has no `RegistryProvider` (and so no `RegistryHarness`); registrations are awaited through `GlobalRegistry`. The `separateRoot` row mounts the Droppable with its own `ReactRoblox.createRoot` on an `OtherRoot` Frame in the same ScreenGui, unmounted and destroyed in `finally`.
- `ineligibleTargetSkipped` stacks a `FrontZone` (in a `FrontWrapper` with `ZIndex` 2) over a `BackZone` (`ZIndex` 1). The `visible` row is the control proving the front target wins when eligible. In the `clipped` row the wrapper is 40x40 with `ClipsDescendants`, and the pointer (the back zone's centre) is outside the wrapper but inside the front zone's own rect. Hidden zones are awaited with `waitForDescendant(..., () => true)` because `waitForGuiObject` waits for a non-zero size.
- `displayOrderWins`/`disabledGuiSkipped` portal an `OtherZone` into a second ScreenGui created by `withSecondGui` (same `finally` order as `siblingTreeDrop`). The local target has `ZIndex` 50 so only DisplayOrder can make the other one win. `disabledGuiSkipped` disables the second ScreenGui only after both targets registered and the overlap point was measured: a ScreenGui that starts disabled may never lay its content out, which would make the row pass for the wrong reason.
- `zIndexBehavior` (Droppable) and `zIndexBehaviorOrder` (`gui.helper.test.ts`) use the same shape: `Shallow` (`ZIndex` 5) declared before `LowParent` (`ZIndex` 1) holding `Deep` (`ZIndex` 10). Sibling compares the diverging branches (5 vs 1, so the earlier-declared `Shallow` wins, which tree order alone wouldn't give); Global compares own `ZIndex` (10 vs 5). The Droppable test flips `ZIndexBehavior` on the mount's ScreenGui, which `withMounted` destroys afterwards.
- `gui.helper.test.ts` tests `GuiHelper.isRenderedAbove` on detached instances under a throwaway `Folder`: it reads only the tree, `ZIndex`, `ZIndexBehavior` and `DisplayOrder`, never absolute rects, so no ScreenGui host is needed. It's `@Tag("Studio")` because it creates Instances. `assertAbove` checks both directions so a helper that returns `true` for everything fails.
- `renderOverlayContent` asserts no `DragItem` anywhere under the overlay, proving the custom content replaces the clone rather than sitting next to it.
- `dragClosesTooltip` opens the original's Tooltip through its captured `MouseEnter`, starts a drag, and waits for the popup to be removed. After the drop it waits 10 frames and expects no popup: suppression clears the remembered hover, because the hidden original never gets a `MouseLeave`.
- `openTooltipSuppressed` uses `open={true}`, so the preview's clone would show a popup immediately if the preview weren't suppressed. That makes it a deterministic check of preview inertness, unlike hover-driven `previewSkipsTooltip`. The popup must come back after the drop because `open` still says so.
- `previewSkipsTooltip`: `TooltipTarget` merges the forwarded ref (Tooltip needs it for its target rect; without it `show()` never opens a popup) with a ref callback that records the injected `Event` table per instance. The test can then fire `MouseEnter` on the preview's clone specifically, which is what the engine does when the cursor sits over the preview. The test asserts the preview's `TooltipTarget` and its injected `MouseEnter` exist before firing, so it can't pass vacuously.

## `Tooltip.test.tsx`

- `disabledKeepsInstance` compares the `HoverTarget` instance by reference across `disabled` false → true → false (`mounted.update` re-renders the same element types, so only a Tooltip-caused remount could change it), then hovers to prove the handlers still work.
- `controlledOpen` waits 20 frames after `MouseLeave` before checking the popup is still there, longer than the 0.25s fade, so an uncontrolled `hide()` would have removed it.
- `nativeChildMounts`/`nativeChildShows` wrap a native `<frame>`. As with `Draggable.Handle`, the mount test only waits for the frame to exist (a raw `Event` table on a host element throws and unmounts the root). `nativeChildShows` reads `memoizedProps[React.Event.MouseEnter]` from the frame's host fiber via `findHostFiber` in `fiber.ts`.
- The edge tests (`rightEdgeFlips`, `topEdgeFlips`, `leftEdgeShifts`, `autoRightEdge`) mount `edgeApp`, a native `EdgeTarget` frame under `open={true}`, so no hover plumbing is needed. The popup is placed only after its content has been measured (a frame or more after it appears, and it is transparent until then), so `waitForPlacedPopup` polls up to 60 frames for `GroupTransparency < 1` and the expected side, then the test asserts with full rects. It does not fail on its own, so a timeout shows up as the assertion message with the last rects.
- They run in Edit mode, where `GuiService.TopbarInset` and `GetGuiInset()` are zero, so they can't exercise the topbar band. `Tooltip.placement.test.ts` covers it through `getTooltipSafeArea`.
- `Tooltip.placement.test.ts` is `@Tag("Lune")`: `computeTooltipLayout` takes plain tables, so no Roblox datatypes are needed. Its expected numbers assume `pointerSize = 10` (padding `floor(10 * sqrt(2) / 2) = 7`), a corner radius of 8 and a 400x300 overlay with an 8px margin.

## Tooltip interaction (`Tooltip.interactive.*.test.tsx`, `src/Tests/Helpers/tooltip.tsx`)

- **Why these are six small classes.** They used to be one `TooltipInteractiveValidation` class (25 methods, ~27.6s alone). The live-sync run has a whole-run limit (`lunit.studio.liveSync.timeoutSeconds`, default 30s): once it passes, the runner cancels whatever class is still running. The cancelled class never reaches `withMounted`'s `finally`, so its React trees stay mounted and keep calling into the closed environment, which floods Studio's Output with `isolation: run has ended` until Studio restarts. The class is now split by behaviour: `hover` (`TooltipHoverValidation`), `pin` (`TooltipPinValidation`), `longpress` (`TooltipLongPressValidation`), `nesting` (`TooltipNestingValidation`), `cover` (`TooltipCoverValidation`) and `controlled` (`TooltipControlledValidation`). Keep each one a few seconds long; put a new interaction test in the matching file, or a new file, rather than growing one class. Splitting only shortens each class. If the whole unfiltered Studio run takes more than 30s, the class running at the limit is still cancelled, so raise the setting for long suites.
- **The stall at `ReplicatedStorage.rbxts_include.Promise:1629`** is `Promise.prototype:awaitStatus`'s `coroutine.yield()`. Lunit's `TestClassRunner` runs a test with no `@Timeout` through `TS.await(invoke())` and parks there until the test returns, so that location only says "a test was still running", not which wait was stuck. No wait in these tests is unbounded: `waitForShown` has a time deadline (2s by default), `waitForRemoval` and `waitForGuiObject` are frame-bounded, and `assertStaysShown`, `fadesBy` and `task.wait(n)` are fixed. The class simply ran past the whole-run limit.
- **No `@Timeout` on these tests.** Lunit's `@Timeout` wraps the test in `Promise.try(invoke):timeout(...)` and reports any non-resolved status as `Test exceeded timeout of Nms`, so a normal assertion failure would lose its message. The bounded helpers fail fast with the real message instead. `lunit.studio.testTimeoutSeconds` (default 120s) is the per-test backstop.
- **`FAST_THEME`** (`tooltip.tsx`) is `DefaultTheme` with `fadeDuration 0.05`, `closeDelay 0.1` and `longPressDelay 0.2` (`FAST_TOOLTIP`). `tipApp`, `coverApp` and `nestedApp` always wrap their tree in a `ThemeProvider`, so `mounted.update` with the same helper never changes the element types and never remounts. `tipApp` takes the theme as its second argument, `FAST_THEME` by default.
  - Tests that check the default timings pass `DefaultTheme`: `closeAfterDelay` (no fade before 60% of the default `closeDelay`) and `controlledCloseImmediate` (fades before 60% of it). A 60% window of the fast 0.1s `closeDelay` is only about 4 frames, too short to tell anything apart.
  - `themeCloseDelay` extends `FAST_THEME` with `closeDelay: 1`, so the fade after it is short and the 0.6s hold is still "well past the default delay".
  - `closeDelay` is 0.1s rather than lower because `crossToPopup` fires `MouseLeave` on the trigger and then `MouseEnter` on the popup one frame apart (`fireHostEvent` waits a frame), and the popup hover has to cancel the pending close before it fires. A Studio frame hitch longer than `closeDelay` would close the popup in between.
  - Long-press tests read `FAST_TOOLTIP.longPressDelay` instead of the theme default, so "before" and "after" are still half of the active delay.
- **`HOLD_SECONDS = 0.3`** is the "still open" window for tests that only need to outlast a close (`crossToPopup`, `pressPins`, `hoveredUnpinOpen`, `childHoldsParent`). It is twice `closeDelay + fadeDuration` under `FAST_THEME`, so a popup that wrongly closed would already have faded out.
- **Estimated time per class**, summing fixed waits plus about 6 frames per mount, popup fade-in and removal at 60fps: hover about 4.3s, pin about 2.9s, longpress about 4.4s, nesting about 1.9s, cover about 3.3s, controlled about 1.9s. The old class took about 1.5x its summed waits in Studio, so allow for that.
- `mousePressPins` would also pass if a mouse press started a long press instead of pinning: the finger is never lifted, so a long-pressed popup would also appear (after `longPressDelay`, inside `waitForShown`'s deadline) and stay open.

## `Scroller.test.tsx`

- `isScrolling` flips in an effect after `AbsoluteCanvasSize` changes. Only then does the content frame shrink to make room for the scrollbar thickness plus spacing, so the tall-content test polls for the narrower width.

## Input/Select theme options (`Input.test.tsx`, `Select.test.tsx`)

- Hover and focus are driven through `fireHostEvent` in `src/Tests/Helpers/fiber.ts`, the generic form of `activateButton`: it looks up `React.Event[eventName]` in the host fiber's `memoizedProps` and calls the handler with the instance plus any extra arguments, then waits a frame. Input hover fires `MouseEnter`/`MouseLeave` on the root `Input` ImageLabel; Select hover fires them on `SelectButton`. Input focus fires `Focused`/`FocusLost` on the `TextBox` rather than calling `CaptureFocus`, so the state tests don't depend on real keyboard focus. Select focus is the dropdown being open, opened with `activateButton` on `SelectButton`.
- `CaptureFocus`/`IsFocused` do work in the Studio test runner. `disabledReleasesFocus` and `disabledIgnoresLabel` rely on that and check real focus. `disabledIgnoresLabel` re-enables the Input and expects `labelActivated` to focus it, which proves the first half isn't passing just because focus never works.
- `STATE_THEME` (both files) gives each state a distinct border colour, and hover/disabled a distinct `backgroundTransparency`, while focus sets only `borderColor` and `borderThickness`. Hovered plus focused must then show the base transparency (`0.5`), not hover's `0.75`: that is the check that state overrides don't cascade into each other. Hover and disabled set no `borderThickness`, so the base `1` proves per-key fallback.
- In Input `statePriority`, `mounted.update` with `disabled` calls `ReleaseFocus` on a `TextBox` that was never really focused (focus came from firing `Focused`), so no `FocusLost` fires and the internal focused state stays `true`. That is why re-enabling goes straight back to the focus look.
- `waitForMeasuredBand` (Input) and the keypoint poll in Select `innerShadowBand` wait until the `Fade` gradient's middle keypoint equals `size / band height`. `FieldInnerShadow` hides the band until its `AbsoluteSize` has been measured and recomputes the keypoint from a state update, so the first frames can show a stale or hidden band.
- The zero-shadow and caret `@Each` rows carry string labels (`"string"`/`"table"`, `"caret"`/`"select"`/`"none"`) mapped to values by `zeroShadow`/`caretColorTheme`/`expectedCaretColor`, keeping the rows plain data.
- `select` is reserved by roblox-ts as an identifier ("reserved for compiler internal usage"), so the theme helper parameter is named `overrides` in both files.
- Select caret-cap slot heights are derived, not hard-coded: `capInset` in `Select.test.tsx` repeats `SelectCaretCap`'s `inset` (field padding from `SpacingHelper.GetResolvedPadding(theme, {})` minus twice the base `select.borderThickness`), and the expected slot height is `max(0, size + top + bottom - capInset)`. With `DefaultTheme` that inset is 22, so a 20px default cap gets a 0px slot: `caretDefaults` waits on `Cap` (non-zero) and reads the slot as its parent, because `waitForGuiObject` on `SelectCaretCap` would time out.
- `caretCapNoGrow` checks "the cap doesn't grow the field" as root height = field padding (`fieldPaddingY`) + `SelectedText`'s `AbsoluteSize.Y`, polled with `waitForLayout`. It doesn't compare against an uncapped Select (its bare 20px icon can be taller than the text line) or a mounted `Input` (different typography/padding theme keys).
- Select's `boxShadow`/`dropDown` assertions read the `UIShadow` properties, not pixels. Whether the dropdown's shadow survives its `ClipsDescendants` frame, and how the shadow reads against the fill, can only be judged visually in the story.

## Controlled Input sync (`Input.controlled.test.tsx`)

- Unlike the theme-state tests, these use real focus (`CaptureFocus`/`ReleaseFocus`, polled with `IsFocused`), because the guard under test is "don't write `props.value` into `Text` while the box is focused". `focus` waits two more frames after `IsFocused` so the `Focused` handler's state update has rendered before typing starts.
- `focusedKeepsTyping` has two `@Each` rows. `defer` is the reported case: `"2"` then `"24"` set in the same frame, with the parent echoing `onChange` through `task.defer`. Under deferred signal behaviour both `Text` change events may read `"24"`, so this row alone may not reproduce the stale overwrite. `delay` makes the race deterministic: a frame passes between keystrokes and the parent applies each echo after `ECHO_DELAY` (0.1s), so the stale `"2"` re-render always lands while `"24"` is in the box. Without the guard that render writes `"2"` back, its `Change.Text` echoes `"2"` again, and the box ends on `"2"`. The test then blurs and expects `"24"`, which checks that FocusLost syncs to the latest `value`.
- `blurShowsFormatted` starts at `value="4.00"` with an `onChange` echo, types `"4"` (so `value` becomes `"4"`), and sets `"4.00"` again from `Event.FocusLost`. It checks the sync that follows the blur, not the initial render.

## HoverButton events and Tooltip wrapping (`HoverButton.event.test.tsx`, `Tooltip.hoverbutton.test.tsx`)

- Tooltip clones a non-host child with a merged `Event` prop and a `ref` (`ElementHelper.cloneWithEvents`), so a bare `HoverButton` needs both its top-level `Event` prop and ref forwarding. Without the ref, Tooltip's `targetRef` stays unset and `show()` never opens a popup. `opensOnHover` covers both, and `forwardsRef` checks the ref on its own.
- Hover is fired with `fireHostEvent` on the `ImageButton`. The handler stored in its fiber is HoverButton's own `MouseEnter`/`MouseLeave` wrapper, which has to call Tooltip's injected handler. `opensOnHover` calls `assertNoPopup` before hovering so it can't pass on a popup that was already open.
- `runsBothHandlers` fires `MouseEnter` from the default state, where the state set and the default set are the same, so the expected log has exactly one `default:` entry.

## Border, padding and radius props (`Container.test.tsx`, `HoverButton.test.tsx`, `Corners.test.tsx`, `Button.test.tsx`, `Box.test.tsx`, `Card.test.tsx`, `size.helper.test.ts`)

- The `UIStroke`/`UIPadding`/`UICorner` lookups use `FindFirstChildWhichIsA` on the component's own root, so they only see direct children. A decorator that landed on a nested element, or on Container's `ContainerCenterWrapper`, does not count. `centeredDecoratorsOnInner` checks the wrapper has none of the three and the inner `Container` has all of them.
- Radius token rows read `DefaultTheme.radius[token]` instead of hardcoding 4/8/12. `tokenFollowsTheme` overrides `radius.lg` to 20 under a nested `ThemeProvider`, so the value can only come from the active theme. `zeroTokenEmitsNothing` sets `radius.sm` to 0 to prove a token that resolves to zero follows the same no-`UICorner` rule as a literal 0.
- `HoverButton` `hoverBorderColor` fires `MouseEnter`/`MouseLeave` on the root `ImageButton` with `fireHostEvent`, the same path as the Input/Select hover tests. The hover set carries only `borderColor`, so the unchanged `Thickness` is the per-field fallback check.
- `BoxProps` (and so `Card.Body`'s props) doesn't declare `padding`, so `paddingNotDoubled` and `sectionPaddingNotDoubled` pass it through an object cast `as BoxProps` and spread it, which is how a consumer spreading `PaddingProps` reaches the component. Box's own `UIPadding` and Container's would both be named `Padding`, so the tests count `UIPadding` children via `GetChildren()` instead of looking one up by name.
- `size.helper.test.ts` is `@Tag("Lune")`: `SizeHelper.resolveRadius` returns plain numbers and strings, and the module only type-imports `ThemeTemplate`, so it loads without Roblox datatypes. It uses a theme stub with only `radius` set, with values (3/7/11) that differ from `DefaultTheme`'s. `toRadius` builds a `UDim`, so it is covered by the Studio `Corners`/`Container` tests instead.

## Min and max size (`size.helper.constraint.test.ts`, `*.constraint.test.tsx`)

- `size.helper.constraint.test.ts` (`SizeConstraintResolution`) is `@Tag("Studio")` even though it mounts nothing: `SizeHelper.GetSizeConstraint` builds `Vector2`s, which don't exist under Lune (see Engine and framework quirks). It lives in its own file because `size.helper.test.ts` is the Lune-tagged `RadiusTokenResolution` class, and a file holds one class.
- The per-component constraint classes (`Container`, `Card`, `ProgressBar`, `Modal`) are separate `*.constraint.test.tsx` files so each class stays small and fast. Scroller's constraint tests are in `Scroller.constraint.test.tsx` (`ScrollerSizeConstraint`, plain theme), `Scroller.test.tsx` (`wrapperClamped`) and `Scroller.theme.test.tsx` (`decoratedConstraint`, themed). Any min/max prop gives the wrapper tree, so all of them check the wrapper Frame holds the constraint and the inner `ScrollingFrame` has none.
- `sizeConstraintsOf`/`soleSizeConstraint` in `layout.ts` only look at direct children, so a constraint on the wrong instance (a centre wrapper, the content frame) doesn't count. `soleSizeConstraint` also checks the name is `SizeConstraint` and that there is exactly one, because Roblox honours only one.
- **The engine does not clamp `AutomaticSize` growth with `MaxSize`.** A native `Frame` with `AutomaticSize.XY`, a `UISizeConstraint` `MaxSize` of 80x30 and a 120x80 child frame still lays out at 120x80. `MinSize` does raise an auto-sized element. So the auto-size tests (`centeredConstraintOnInner`, `autoSizeRaised`) use minimums, and `maxWidth` is only checked against explicit or `%` sizes. `components/index.md` ("Min and max size") documents this limit.
- The ProgressBar header wrapper and its track are both named `ProgressBar` (`name ?? "ProgressBar"`). The tests take the wrapper as the first match under the host and the track as the first match under the wrapper, and assert their classes (`Frame` and `ImageLabel`).
- Card fixtures with an overlay header still need a `Card.Body`: with no flow children the box is 0px tall and `waitForGuiObject`'s default predicate never passes.
- `ModalSizeConstraint` mounts through `withMounted` with `RegistryProvider` > `OverlayProvider` > `ModalProvider`, rather than the `createTestRoot` harness in `Modal.test.tsx`, so the overlay is laid out under a `ScreenGui` and `AbsoluteSize` is real.

## Scroller callbacks, theme and size limits (`Scroller.test.tsx`, `Scroller.callbacks.test.tsx`, `Scroller.theme.test.tsx`, `Scroller.constraint.test.tsx`)

- `stableGutterNarrows` expects the content width to be `AbsoluteWindowSize.X - 12 - GetPadding(DefaultTheme, undefined)`. The window is already narrowed by the `Always` inset, and the content frame's `(1, -thickness - spacing)` size is taken from the canvas width, which matches the window. `stableGutterSteady` captures the short-content width and expects it unchanged once the content overflows.
- The callback tests drive scrolling by writing `CanvasPosition` from the test, which fires the same `GetPropertyChangedSignal("CanvasPosition")` connection real scrolling does. `scrollTo` waits two frames so the signal and the near-end check have run before asserting.
- `firesOnMountShort` asserts at least one call, not exactly one. The near-end check runs when the effect mounts, possibly before the canvas has been measured (height 0, which counts as "at the end"). When `AbsoluteCanvasSize` then grows to the content height, the canvas-growth re-arm can fire a second time. That matches the spec ("if the canvas grows but the end is still within the threshold, it fires again").
- `rearmsOnGrowth` grows the content by 5px while parked at the end, so the end stays inside the 20px threshold. A second call then comes only from the canvas-growth re-arm, not from scrolling away (that is `rearmsScrollingAway`).
- **A `UISizeConstraint` directly under a `ScrollingFrame` with `AutomaticCanvasSize` also caps the automatic canvas.** With `maxHeight={200}` the canvas was clamped to the 200px window and the Scroller stopped scrolling. `ScrollerSizeConstraint` (`Scroller.constraint.test.tsx`) is the regression guard: plain theme, a 600px child, `maxHeightScrolls` (`height` and `maxHeight` 200) and `minHeightScrolls` (`height` 120 raised by `minHeight` 200). Both expect a 200px window, `AbsoluteCanvasSize.Y` above `AbsoluteWindowSize.Y`, no `UISizeConstraint` anywhere under the `ScrollingFrame` (checked over `GetDescendants`, not just direct children) and a narrowed `ScrollerContent`. The 400px-tall host keeps the host from limiting the window, so the 200px height can only come from the props.
- `wrapperClamped` (formerly `windowClamped`) used to call `soleSizeConstraint` on whatever `waitForGuiObject(host, "Scroller")` returned and cast it to `ScrollingFrame`. Once min/max props forced the wrapper tree, that was the wrapper `Frame`, so the test passed for the wrong reason. It now asserts the root is a `Frame` and looks up the inner `ScrollingFrame` by name.
- The theme tests nest a `ThemeProvider` with `extendTheme(DefaultTheme, { components: { scroller } })`. `ScrollerTrack` and `ScrollerThumb` exist even while hidden, so they are found with `waitForDescendant(..., () => true)` and checked through `Visible` after a few `settleFrames`.

## `Pagination.test.tsx` cursor mode

- `cursorNextNeedsFlag` `@Each` rows carry a `"unset"`/`"false"`/`"true"` label mapped by `hasNextPageFor`, because a row can't hold `nil`.
- `cursorEmitsFloored` mounts with `withMounted` (not the `Folder` helper) because `activateButton` needs a `MountedElement`. Activating the disabled Prev goes through the real handler, which ignores it, so `[2]` proves both that Prev emitted nothing and that page `1.7` is floored to `1` before Next adds one.

## Text decorations (`Text.outline.test.tsx`, `Text.constraint.test.tsx`, `Text.shrink.test.tsx`)

- Split into three classes (outline, size limits, shrink) so each stays a few seconds long.
- `plainHasNoChildren`/`spacedHasNoDecorations` (`TextOutline`) are the "no new props, no new instances" guard: the plain label has no children at all, and the letter-spaced frame holds only its `UIListLayout` plus one bare `TextLabel` per character.
- Outline colours are binary-exact (`Color3(0.25, 0.5, 0.75)`) and compared with `===`, which is `==` on the `Color3` userdata and so compares by value. Thicknesses are integers and transparencies `0.25`/`0.5`, since the properties are 32-bit floats.
- Theme outline cases nest a `ThemeProvider` with `extendTheme(DefaultTheme, { typography: { body: { outline } } })`; `Text` with no `variant` reads `body`.
- `scaledCapped` first waits for the uncapped `TextScaled` label to exceed 48px in its 300x200 box, then caps it with `maxTextSize={24}` on the same instance. The uncapped half proves the cap is what keeps the text small. The capped check allows `TextBounds.Y` up to 1.5x the size, because line height and font metrics put `TextBounds.Y` a little above `TextSize`.
- `textSizeDefaults` rows carry a `"min"`/`"max"` label mapped by `boundsFor` to a one-key props object, because a row can't hold `nil`.
- `shrinkMinScale`'s scale comes back as a 32-bit float from `UIScale.Scale`, so the shrink tests compare with `SCALE_EPSILON = 0.01` (or `0.001` for "exactly 1", matching the component's own write threshold).
- The shrink fixture is a fixed-size native `Slot` frame. The text's visual width is `AbsoluteSize.X` of the `Text` root, which already includes its `ShrinkScale`. The text is `TextWrap={false}` so the plain-label row stays one line.
- Plain text scales smoothly, so `assertWidthNear` checks its width lands within `[target - 2, target + 1]`. Letter-spaced text can't: the engine floors each character's effective text size to whole pixels, so width is a step function of scale (18px body, `letterSpacing` 2, 60px target: scale 0.33285 renders 54.65px, 0.33402 already ~64.7px). `assertLargestFit` therefore checks `width <= target + 1` and then proves the fit is maximal: it mounts a separate `Probe` frame whose `UIScale` is the chosen `ShrinkScale` plus `PROBE_STEP` (0.005, above the component's 0.001 search precision) around an unshrunk spaced `Text`, and waits for that width to exceed the target. It waits `settleFrames(3)` first so it reads the settled scale, not one mid-search. Used by the spaced `shrinksIntoSlot` row, `respectsSlotPadding` and `shrinksIntoMaxWidth`.
- `respectsSlotPadding` uses an 80px slot with 10px `UIPadding` each side, so the target width is 60px.
- `ShrinkScale` is found with `waitForDescendant(..., () => true)` because a `UIScale` has no rect.
- `quietUnmount` (`TextShrinkToFit`) guards the `IsDescendantOf(game)` check in `Text`'s shrink `update` (see the Text spec's "Shrink unmount guard" note). `stackedShrinkApp` puts `VStack` inside a native `Stack` frame on purpose: `VStack` is a fragment, and on unmount react-roblox detaches the top-level `Stack`, so its `UIListLayout` stays above the text in the detached tree. That is the shape that storms. With the text as a direct child of the host, the detached text has no list layout above it and the bug would not show. The test mounts with `mountInScreenGui`, not `withMounted`, because the unmount itself is the action under test. It connects `LogService.MessageOut` only after the shrink settles, calls `mounted.unmount()`, waits `settleFrames(2)` so any deferred warnings arrive, and counts messages containing "re-entrancy". With the guard removed both rows log 97 warnings each.
- `spacedRefIsFrame`/`plainRefIsLabel` (`TextMountValidation`) cover the forwarded ref on both roots. The letter-spaced one fails if `setFrame` stops calling `ElementHelper.assignRef`. `ref.current` is widened to `Instance` before `IsA`, because the public ref type is `TextLabel` while the letter-spaced instance is a `Frame`.

## Gamepad selection (`gamepad.helper.test.ts`, `GamepadSelectionGuard.test.tsx`, `Modal.selection.test.tsx`, `Modal.selection.close.test.tsx`, `src/Tests/Helpers/selection.ts`, `src/Tests/Helpers/modal.tsx`)

- **The last input type can't be faked.** `GamepadHelper.isGamepadActive` reads `UserInputService:GetLastInputType()` directly and `useGamepadSelection` listens to the real `LastInputTypeChanged`; there's no injectable seam, and the runner can't fire `UserInputService` signals. So the hook, guard and Modal tests only cover the non-gamepad branches under whatever the runner's real last input type is, plus `selectionMode="always"` (input-independent). The gamepad branches (selecting on enable with a gamepad active, selecting on a switch to gamepad, `canTakeSelection`/topmost arbitration, clearing on a switch away from gamepad, restore on close with a gamepad) are not covered.
- **`selectionUnavailable` gates every selection test** through one `@Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)`. It is true outside Roblox, when the last input type is a gamepad, or when the probe fails. The probe (cached per module load) parents a selectable `Frame` in a `ScreenGui` under `CoreGui`, assigns `GuiService.SelectedObject` inside a `pcall`, and checks it stuck. `SelectedObject` is documented to reject objects outside a `PlayerGui`, and the tests run in Edit mode with `mountInScreenGui`'s `CoreGui` host, so if the engine rejects it every selection test skips instead of passing vacuously or failing. The probe cannot yield (Skip conditions are evaluated while the module is required), so it does not wait a frame for layout.
- Only one `@Skip` per method: each `@Skip` overwrites the method's `disabled` metadata, so a later `@Skip(false, ...)` would cancel an earlier true one. Combine conditions in one function instead.
- `withSelectionReset` clears `SelectedObject` before and after each test, so a test never inherits or leaks a selection (or a selection outline in the open Studio). It wraps `withMounted`, so the reset runs after the unmount, which matters for Modal's restore-on-close.
- `selectObject` asserts the assignment stuck before the behaviour under test, so a test can't pass because the engine refused the selection. "Doesn't clear" checks use `assertSelectionStays` (5 `settleFrames`) for the same reason as other negative checks.
- Another enabled `GamepadSelectionGuard` anywhere in the Studio session (for example a story under `CleanUiProvider` open in UI Labs) is place-wide and would clear selections, failing the "left alone" tests. Close such previews before running.
- `unmountDisconnects` mounts the guard and a separate `Outside` tree, unmounts the guard, then selects in the other tree. The `guardedMounted` flag keeps the `finally` from unmounting twice.
- Modal fixtures (`modalSelectionApp` in `modal.tsx`) mount closed first, wait for the `OverlayProvider` frame and the `Outside` frame, then open with `mounted.update`. Opening on the first render is a separate case (`alwaysSelectsMountedOpen`): the `OverlayProvider` publishes its frame through a ref callback plus a state update, so the panel doesn't exist yet when Modal's selection effect first runs, and the effect only re-runs when `enabled` changes.
- `guardBeatsAlways` only checks the end state (nothing selected). It doesn't try to observe the panel being selected for a frame; `alwaysSelectsPanel` is the control proving the modal does select.
- Closing waits for `ModalBackdrop` to be removed (`waitForRemoval`, 120 frames) after the default 0.2s fade; the restore/clear then runs in the hook's cleanup, so `waitForSelection` polls a further 30 frames.
- `gamepad.helper.test.ts` is `@Tag("Studio")` even though it mounts nothing: `isGamepadInputType` takes `Enum.UserInputType` and `isSelectionWithin` needs Instances, neither of which exists under Lune.

## Checkbox and Switch controlled contract (`Checkbox.test.tsx`, `Checkbox.label.test.tsx`, `Switch.test.tsx`)

- These replaced the old fire-on-mount / seed-only assertions (`seedsFromChecked`, `defaultsUnchecked`, the `[false, true]` label sequence, `uncontrolledIgnoresProp`). `onChange` now only fires from a user toggle, so every mount test settles a few frames (`settleFrames`) before asserting `[]`: a reintroduced effect-based `onChange` would commit in that window and fail.
- Box and track clicks go through `activateButton` (fiber `Activated` handler). The controlled-click tests settle three frames after the click before checking that the visual has *not* changed, then `mounted.update` the new `checked` prop and check that it has, without another `onChange`.
- Checkbox state is read from `CheckboxIcon.Image` (empty while unchecked, because `'icon-unchecked'` has no default).
- Switch state is read from the `Thumb` frame's `Position.X.Offset`. `SNAP_THEME` sets `switch.animation.duration` to `0` so the tween snaps; the expected offsets (`THUMB_OFF_X = inset`, `THUMB_ON_X = width - inset - (height - 2 * inset)`) are derived from the theme with `SizeHelper.toUDim` exactly as `Switch.tsx` does, so a theme edit doesn't break them. The `silentMount` rows carry `"on"`/`"off"`/`"unset"` labels because an `@Each` row can't hold `nil`.
- The Switch tests used to mount into a detached `Folder`; they now use `withMounted`, which `fireHostEvent`/`activateButton` need anyway.
- `Checkbox.label.test.tsx` checks the label gap twice: the root `UIListLayout.Padding` and the measured distance from `CheckboxBox`'s right edge to `CheckboxLabel`'s left edge. The unthemed gap is computed with `SpacingHelper.GetPadding(DefaultTheme, undefined, checkbox.spacing)` like the component, and the unthemed label colour is `colors.intents.primary.default.textColor` (`Text`'s fallback). Label typography is checked through `FontSize`, since `TypographyStyle.size` is an `Enum.FontSize`.

## Press-down activation (`Button.press.test.tsx`, `HoverButton.press.test.tsx`, `src/Tests/Helpers/press.ts`)

- `press.ts` `withPress` builds a plain-table `InputObject` stand-in (`UserInputType`, `UserInputState`, `GetPropertyChangedSignal`) backed by a `BindableEvent`, the same shape as `touchPress` in `tooltip.tsx`, but for `MouseButton1` as well as `Touch`. `usePressRelease` connects to `input.GetPropertyChangedSignal("UserInputState")`, so `finish(state)` sets the field and fires the event. The event is destroyed in `withPress`'s `finally`. A plain table without `GetPropertyChangedSignal` would throw in the press-down handler whenever `onRelease` is set.
- `InputBegan` and the "later native `Activated`" are both fired with `fireHostEvent`. The swallow check passes the same pointer input to `Activated`; a gamepad `ButtonA` input (`gamepadInput`) is the non-pointer source that must pass through.
- `upUnchanged` proves the default event table is untouched by checking that the host fiber has no `React.Event.InputBegan` handler at all (`hostHandler`), not just that nothing fired.
- `unmountDropsRelease` swaps the Button for an empty frame with `mounted.update` before finishing the press; `disabledMidHold` re-renders the same Button with `disabled` before finishing it.
- `@Each` rows for the release state carry `"End"`/`"Cancel"` labels mapped by `releaseState`.

## Badge props and clickable badges (`Badge.props.test.tsx`, `Badge.click.test.tsx`)

- Kept separate from `Badge.test.tsx` (`BadgeMountValidation`) so each class stays short.
- Hover and press are driven with `fireHostEvent` on `BadgeButton` (`MouseEnter`, `MouseButton1Down`, `MouseButton1Up`, `MouseLeave`); `onClick` through `activateButton`.
- Shaded colours are compared with a 1.5/255 per-channel tolerance (`assertColorNear`), since `Color3` properties are stored as 32-bit floats and the lerp result isn't binary-exact. The expected colour is computed from the theme's own `hoverDarken`/`pressDarken` and the resting colour from `ColorHelper.getIntentColors` with `badge.intents`, so a theme retune doesn't break the test. `darkLightens` separately checks that DarkTheme's negative values make the hovered badge brighter.
- `removingClickResets` settles two frames after dropping `onClick`, so the reset effect has committed before `onClick` is re-added.

## Sizing (`Button.sizing.test.tsx`, `Select.width.test.tsx`, `Increment.test.tsx` width, `FlexItem.test.tsx` direction/layout)

- `fillSharesEqually` uses three different label lengths so equal widths can only come from `fill`'s zero base width, not from content. It polls until all three agree, because flex distribution lands a frame or more after mount.
- Select and Increment widths are polled with a predicate on `AbsoluteSize.X` (host 400px wide), not read straight after mount.
- `layoutFalseDefersToChild` asserts there is exactly one `UIListLayout` on the FlexItem (the VStack's): two layouts on one frame lay out unpredictably, which is why `layout={false}` exists.

## Estimated time per class (this batch)

At about 6 frames per mount plus each `fireHostEvent`/`activateButton`/`settleFrames` frame, at 60fps: `CheckboxMountValidation` ~1.5s, `CheckboxLabelValidation` ~0.8s, `SwitchMountValidation` ~2s, `ButtonPressDownValidation` ~1.5s, `HoverButtonPressDownValidation` ~1s, `ButtonSizingValidation` ~0.6s, `SelectWidthValidation` ~0.3s, `IncrementMountValidation` ~0.5s, `FlexItemMountValidation` ~0.8s, `BadgePropsValidation` ~0.6s, `BadgeClickValidation` ~1.2s. Each wait is frame-bounded (`waitForLayout`'s 30 frames at most).
