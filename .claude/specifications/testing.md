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
  - Draggable: the handle calls `InputBegan` with a plain-table `InputObject` stand-in, the same approach as `Modal.test.tsx`.
  - Droppable: the test calls `registration.drop` directly, as `Draggable.findDroppable` does.
- **Driving providers from outside the tree.** A small harness component stores the provider's value in a module-level variable: `ToastHarness`/`useToast`, `latestRegistry` in Draggable/Droppable, and `RegistryHarness` in `Modal.test.tsx`.
- **Group needs a `RegistryProvider`.** `Group.Element` takes its id from `RegistryContext.GetNextId`. Without a `RegistryProvider`, every element shares the id `""`, the reported widths collide, and the Group never propagates the widest width. Wrap Group/`group` fixtures in `RegistryProvider`, as `CleanUiProvider` does (Group, Menu).
- **Group width propagation is asynchronous** (a `Change:AbsoluteSize` handler followed by a Group state update). Poll until members agree before measuring (Button `groupAlignsWidths`, Menu `waitForGroupSettled`).
- **Overlay portals.** Select's dropdown, Tooltip's popup and Draggable's preview portal into `OverlayContext.overlay`. Wrap them in `OverlayProvider` and wait for its `"OverlayProvider"` frame before opening; the frame is published through a ref callback plus a state update, so it isn't there on the first frame.
- **Registry registration lags the instance.** It goes through a callback ref → state → effect chain, landing a frame or two after the instance appears (Draggable/Droppable `waitForRegistration`).
- **Animations must settle or be disabled before measuring:**
  - Accordion: `animationDuration={0}` makes the open content reach its final height synchronously and unmounts closed content immediately.
  - Toast: `duration={math.huge}` stops auto-dismiss mid-test.
  - BarChart: see the BarChart section below.
  - ProgressBar: the fill tweens for 0.2s, so the test polls the fill's width.
  - Tooltip: `hide()` clears the popup only after `fadeDuration` (0.25s), which can exceed `waitForLayout`'s 30-frame budget in Studio, so `waitForRemoval` polls for 120 frames.
- **HStack/VStack render a fragment** (`UIListLayout` plus children) with no instance of their own. Fixtures give them a real parent frame (`"Stack"`) to lay out and measure against.
- **VStack's default `HorizontalFlex=Fill`** stretches children to full width. It masks horizontal centering and Group width, so set it to `None` there (VStack `centerAlignment`, Group fixture). Fieldset relies on the stretch: its `AutomaticSize.XY` Container is content-sized until the Fill flex applies.
- **Duplicate instance names.** `FindFirstChild` only ever returns the first match. When siblings share a name, collect them from the parent's `GetChildren()`, which is declaration order when no `LayoutOrder` is set: Pie `SegmentWedge`s, Menu `MenuItem`s, Table `TableRow`s. Fieldset's two `FlexItem` slots are found through their distinct children instead.
- **Bounding text.** The `Text` component is always an `AutomaticSize.XY` TextLabel with a `(0,0)` Size, so on its own it grows to one line and never wraps.
  - To bound it, use a `UISizeConstraint` child (`Text.test.tsx` `narrowText`).
  - For text whose height must follow its container's width, use a native `textlabel` (Grid `relockOnWidthChange`).
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

## `Toast.test.tsx`

- ToastContainer gives its Container an explicit Size of `(theme width, 0)`, which makes it `AutomaticSize.None`. It is 0px tall by design, with the toast VStack hanging below unclipped, so only its width can be waited on.

## `Pagination.test.tsx`

- The selected item is recognised by `BackgroundTransparency` (0 vs 1), not by colour. The unselected state inherits the base primary background, which is `#FFFFFF` in the default theme, the same as the focus colour.

## `Table.test.tsx`

- Column widths start at 0 and resolve only after every cell has reported its measurement (`TableCellContent`). `waitForColumnsMeasured` waits for all cells to have a real width, then gives rows and sections a couple of frames to settle against `totalWidth`.

## `Scroller.test.tsx`

- `isScrolling` flips in an effect after `AbsoluteCanvasSize` changes. Only then does the content frame shrink to make room for the scrollbar thickness plus spacing, so the tall-content test polls for the narrower width.
