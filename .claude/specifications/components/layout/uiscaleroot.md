# UiScaleRoot

`UiScaleRoot` scales a whole UI tree by one factor (typically `1`, `1.25` or `1.5`) and tells every library component below it what that factor is, so measurements and breakpoints stay in **design pixels** (screen pixels / scale). It follows the shared conventions in [Components](../index.md).

## Public API

- `UiScaleRoot` props: `scale: number` (required, must be `> 0`), `ZIndex` (`ZIndexElementProps`, forwarded to the root frame), `name` (instance name, default `"UiScaleRoot"`), `children`. It forwards a ref to its root `Frame`.
- `useUiScale(): number` — the effective scale: the product of every `UiScaleRoot` above the caller, or `1` with none.
- `useDesignViewportSize(): Vector2` — `Workspace.CurrentCamera.ViewportSize / useUiScale()`. It re-renders on a viewport resize, when the effective scale changes, and when `Workspace.CurrentCamera` is replaced. It returns `Vector2.zero` while there has never been a camera, and keeps the last size while `CurrentCamera` is nil.
- `toDesignPixels(value, scale)` / `toScreenPixels(value, scale)` — pure conversions, `value / scale` and `value * scale`. Overloaded so a `number` returns a `number` and a `Vector2` returns a `Vector2`.
- `UiScaleContext` (exported): `React.Context<number>`, default `1`. It holds the effective scale, not the root's own `scale`.
- No `theme.components` entry.

## Layout

- Renders one transparent frame (`BackgroundTransparency` 1, `BorderSizePixel` 0, default `Position`/`AnchorPoint`, not `Active`) sized `UDim2.fromScale(1 / scale, 1 / scale)`, containing a `UIScale` named `UiScale` with `Scale = scale`, then `children`. After scaling the frame exactly fills its parent; children lay out in design pixels.
- Intended placement is directly under the `ScreenGui`, wrapping `CleanUiProvider` (so the overlay and the `ToastContainer` are inside the root as well). Anything rendered outside the root, including a `ToastContainer` placed outside it, is not scaled.
- Nothing else is rendered. With `ZIndexBehavior.Sibling`, children keep their relative `ZIndex` order inside the frame, and the frame itself takes part in sibling ordering against whatever else sits in the `ScreenGui` through its `ZIndex` prop (engine default `1`). With `ZIndexBehavior.Global` the frame's `ZIndex` doesn't affect its descendants.
- Nested roots multiply: an inner `UiScaleRoot scale={1.2}` inside an outer `scale={1.25}` publishes `1.5`. Physically the two `UIScale`s compose the same way.
- With no root, or `scale={1}`, every library component behaves exactly as before: every conversion divides or multiplies by `1`, and no extra overlay wrapper is rendered.

## Scale-correct components

Roblox reports `AbsoluteSize`, `AbsolutePosition`, `AbsoluteContentSize`, `AbsoluteCanvasSize`/`AbsoluteWindowSize`, `ViewportSize`, input positions and the GUI inset in screen pixels, after `UIScale`. Every library component that writes such a value back into an offset `Size`/`Position`/padding, or compares it against a design-pixel constant (a breakpoint, a theme size), converts it with `toDesignPixels` using `useUiScale()`. Screen-to-screen comparisons (hit tests of an input position against an `AbsolutePosition`) stay in screen pixels. Each affected component's spec says what it converts.

- Breakpoints (`BreakpointProvider`, `useBreakpoint`'s viewport fallback, `Row`, `Grid`, `Fieldset`) resolve against design-pixel widths, so a panel under `scale={1.5}` doesn't pick a roomier layout.
- Overlay content (`Tooltip`, `Select`'s dropdown, `Modal`, `Draggable`'s drag preview) renders at the portalling component's effective scale even when the `OverlayProvider` sits outside the root (or under a different scale); see Implementation notes.

## Story

- A full-screen demo with a scale control (`1`, `1.25`, `1.5`) wrapping `CleanUiProvider`. Show a readout of `useUiScale()`, `useDesignViewportSize()` and `useBreakpoint()`, plus a `Grid`/`Row` whose column count follows the design width (screen width / scale), so for a fixed window a larger scale resolves a narrower breakpoint with fewer columns, never a roomier one, a `Tooltip`, a `Select` and a `Modal` that stay aligned with their triggers at every scale.

## Implementation notes

- **Portals.** `OverlayProvider` publishes the effective scale at its own position as `OverlayContextValue.scale`. Portalling components wrap their portal content in `OverlayScaleFrame` (`src/Components/Layout/UiScaleRoot.frame.tsx`, not exported from the package), which computes `useUiScale() / (overlay.scale ?? 1)`. When that ratio is `1` it renders its children directly (no instance), so a tree whose overlay is inside the root, or with no root, is unchanged. Otherwise it renders a full-overlay `UiScaleFrame` named `UiScaleOverlay` with that ratio, so the content renders at the portalling component's scale. In both cases one content unit is `useUiScale()` screen pixels, so callers convert overlay-relative screen measurements with `toDesignPixels(..., useUiScale())` and never need the overlay's own scale. Context survives portals, so `useUiScale()` inside portalled content still reads the portalling component's scale.
- `OverlayScaleFrame` takes a `ZIndex` and the call site passes the content's own sibling `ZIndex` (`Modal`'s backdrop `ZIndex`, `Draggable`'s `100001`). Under `ZIndexBehavior.Sibling` the wrapper, not the content, is then the overlay's child, and without that every wrapped modal would tie at `ZIndex` 1 and lose its stack order.
- `UiScaleFrame` is shared by the root and the overlay wrapper. The overlay wrapper must not use `UiScaleRoot`, because `UiScaleRoot` multiplies the context: inside the portal the context already holds the portalling component's effective scale.
- Where a measurement is held in state (`Row`, `Grid`, `Fieldset` widths, `FieldInnerShadow`'s height, `Select`'s content height, `Card`'s overlay rects, `Draggable`'s size and position, `Tooltip`'s rects), the state keeps the raw screen value and the conversion happens at render. Under a root, a `fromScale(1, ...)` child's screen `AbsoluteSize` doesn't change when only the scale changes (the root is `1/scale` wide, then scaled back up), so no `Change.AbsoluteSize` fires, and a value converted only in the handler would go stale. Effects that read measurements imperatively (`BreakpointProvider`, `Text` shrink, `Scroller` thumb) list the scale as a dependency for the same reason.
- `UITextSizeConstraint` `MinTextSize`/`MaxTextSize` are the opposite case: they clamp the text size rendered after the root's `UIScale`, so they are screen pixels and are multiplied by `useUiScale()` (`PinTextSize`, the `ignorePreferredTextSize` pin, `Text`'s `minTextSize`/`maxTextSize`). See [typography/pintextsize.md](../typography/pintextsize.md#implementation-notes).
- `toDesignPixels`/`toScreenPixels` live in `src/Helpers/uiscale.helper.ts`, which has no imports so it can be required under Lune. The hooks and context live in `src/Contexts/uiscale.context.ts`, like `useBreakpoint` next to `BreakpointContext`.
- A `scale` of `0` or below is not guarded and produces an infinite or negative frame size.
