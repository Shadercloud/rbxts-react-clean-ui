# BreakpointProvider

`BreakpointProvider` answers "how wide is the page?" for any descendant: it measures its own width, resolves the active breakpoint, and publishes it through `BreakpointContext`. The `useBreakpoint` and `useBreakpointValue` hooks read it, falling back to the viewport when no provider is mounted above them. It follows the shared conventions in [Components](../index.md).

## Public API

- `BreakpointProvider` props: `breakpoints` (`BreakPointElementProps`, overriding `theme.breakpoints`), `name` (instance name, default `"BreakpointProvider"`), `LayoutOrder`, `children`. It forwards a ref to its root `Frame`.
- `BreakpointContext` (exported): `BreakpointContextValue | undefined`, where the value is `{ width: number, breakpoint: Breakpoint }`. `undefined` means no provider is mounted above.
- `useBreakpoint(): Breakpoint` — the nearest provider's `breakpoint`. With no provider, the breakpoint of `Workspace.CurrentCamera.ViewportSize.X` against `theme.breakpoints`.
- `useBreakpointValue<T>(value: ResponsiveValue<T> | undefined): T | undefined` — resolves `value` for `useBreakpoint()`'s result. A plain `T` is returned as-is; a `{ xs?, sm?, md?, lg?, xl? }` object returns the current breakpoint's entry, falling back down the scale (`xl` → `lg` → … → `xs`), and `undefined` when nothing at or below the current breakpoint is set.
- No `theme.components` entry: layout-only, like `Row`/`Grid`.

## Layout

- Renders a transparent frame (`BackgroundTransparency` 1) sized `UDim2.fromScale(1, 1)` with no `AutomaticSize`, wrapping `children`. It therefore measures whatever container it is placed in (e.g. a fixed 390x844 story frame), not the viewport.
- The breakpoint is `BreakpointHelper.getBreakpoint(AbsoluteSize.X, breakpoints ?? theme.breakpoints)`.

## Update behaviour

- The context value changes only when the resolved breakpoint changes. Resizing within one breakpoint does not re-render the provider or any consumer.
- `width` in the context is the provider's width **at the moment the breakpoint last changed** (or at the first measurement), not a live width. Consumers needing a live pixel width should measure themselves.
- Before the first measurement the provider publishes `{ width: 0, breakpoint: <breakpoint for width 0> }` (normally `"xs"`), then updates once it has been measured on mount.
- Changing `breakpoints` re-resolves against the last measured width, and updates the context only if the breakpoint differs.
- Without a provider, `useBreakpoint` re-renders its component only when the viewport's breakpoint changes. It follows `Workspace.CurrentCamera` being replaced, keeps its last breakpoint while `CurrentCamera` is nil (`"xs"` if it was nil from the start), and disconnects everything on unmount or when a provider appears above it.
- `Row`, `Grid` and `Fieldset` keep measuring themselves and don't read `BreakpointContext`.

## Story

- A fixed-size frame (e.g. 390x844 inside a larger window) containing a `BreakpointProvider`, with a consumer that shows `useBreakpoint()` and a `useBreakpointValue` result (e.g. a column count or label per breakpoint). Controls for the frame width and optionally custom `breakpoints`, so resizing across a threshold visibly switches the value.

## Implementation notes

- `BreakpointProvider` keeps the published value in state but compares against `valueRef` (plus `widthRef` for the last width) inside `resolve`, and only calls `setValue` on a breakpoint change. That keeps the per-pixel `Change.AbsoluteSize` handler from scheduling renders.
- The mount/`breakpoints` effect reads `frameRef.current.AbsoluteSize.X` directly, since `Change.AbsoluteSize` alone may not fire if the frame already has its final size when the handler is connected. The internal callback ref `setFrame` forwards the instance to the caller's `ref` (function or object).
- Don't name locals `next` here: roblox-ts rejects it as a reserved identifier (`resolve` uses `resolved`).
- `useBreakpoint` always calls its hooks (context, theme, state, effect) and gates the viewport subscription inside the effect on `context === undefined`, so a provider mounting/unmounting above it doesn't break the hook order. The effect depends on the boolean `context === undefined`, not the context object, so provider breakpoint changes don't reconnect the camera signals.
- `useBreakpointValue` resolves via `SizeHelper.resolveResponsiveValue` rather than `BreakpointHelper.getValue` directly: the same fallback-down-the-scale order, but it also accepts the plain-`T` arm of the existing `ResponsiveValue<T>` type.
- The hooks live in `src/Contexts/breakpoint.context.ts` next to `BreakpointContext` (like `useToast`/`useModalStack`); only the provider component is in `src/Components/Layout/`.
