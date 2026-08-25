# Toast

`Toast` displays a temporary, dismissible notification. Toasts are created imperatively through `useToast()` rather than rendered directly by a consumer, and are stacked and positioned by `ToastContainer`. It follows the shared conventions in [Components](../index.md).

## Public API

- `useToast()` (from the toast context) returns a `ToastController`: `show(options)`, `update(id, options)`, `dismiss(id)`, and `dismissAll()`, plus the current `toasts` array.
- `show(options: ToastOptions)` adds a new toast and returns its id. If `options.id` is omitted, an id is generated; if supplied, it is used as-is.
- `ToastOptions` fields: `id?`, `title?`, `description?`, `icon?` (`IconName`), `intent?` (default `"primary"`), `duration?` (default `3`, seconds), `dismissible?` (default `true`), `children?` (replaces the default title/description layout entirely, still rendered inside the same themed surface).
- `update(id, options: Partial<ToastOptions>)` merges the given fields into the matching toast. A non-matching `id` is a no-op.
- `dismiss(id)` and `dismissAll()` remove toasts immediately from the provider's list. Because this unmounts the `Toast` instance directly, it does **not** play the fade-out animation — only a toast dismissed from within itself (auto-timeout or its own close button) fades out first. This distinction is real implementation behavior, not an oversight to fix.
- `ToastContainer` (`ToastContainerProps extends SizeElementProps`) renders the live toast stack and is mounted automatically by `CleanUiProvider` unless its `toasts` prop is set to `false`.
- `Toast` itself takes `ToastOptions` plus a required `onDismiss: () => void` callback; `ToastContainer` supplies `onDismiss` as `() => dismiss(toast.id)` for each rendered toast.

## Stacking and positioning

- `ToastContainer` renders nothing when there are no toasts (returns `undefined`), so it never reserves layout space while empty.
- Its position and anchor come from `SizeHelper.GetPosition`/`GetAnchor` applied to `theme.components.toast.position` (a `PositionElementProps`); if the theme does not configure a position, it defaults to `UDim2.fromOffset(5, 5)` anchored at `(0, 0)` (top-left, 5px inset).
- Its width defaults to `theme.components.toast.width` unless overridden by the container's own `SizeElementProps`; height is automatic.
- Toasts render inside a vertical stack (`VStack`, `xs` spacing) in the order they appear in the `toasts` array (insertion order — newest last). The anchor/position of the container only affects where the whole stack sits on screen; it does not reverse the stacking order, so a newly shown toast always appears visually below previously shown toasts, even when the container is anchored to a bottom corner.

## Content and layout

- The toast surface is a `Box` colored from `ColorHelper.getIntentColors(theme, intent, "default", theme.components.toast.intents)` (background, border, text colors).
- Default content (used whenever `children` is not supplied): a header row with an optional leading `Icon` (`scale="sm"`, tinted to the resolved text color), the `title` as `Text` styled from `theme.components.toast.header.typography`, and — when `dismissible` — a trailing close `Button` (`Button.Icon` with `icon="times"`) that triggers dismissal. A `description` row renders below the header when supplied, using the default body typography.
- Supplying `children` replaces the entire default header/description layout; the surrounding `Box` and fade/status-bar behavior are unaffected.

## Duration and dismissal

- `duration <= 0` or `duration === math.huge` disables the auto-dismiss timer entirely (the toast persists until dismissed manually).
- Otherwise, an internal timer calls the same dismissal path after `duration` seconds elapse.
- Dismissal (via timeout or the close button) is idempotent — a re-entrant guard means a second trigger while already dismissing is ignored.
- If `theme.components.toast.fadeDuration <= 0`, dismissal calls `onDismiss` immediately with no animation.
- Otherwise, the toast's `GroupTransparency` tweens from `0` to `1` (`quadOut`) over `fadeDuration`, and `onDismiss` (which removes the toast from the provider's state) fires only once that fade completes.

## Status bar

- When `theme.components.toast.statusBar` is configured, a thin bar renders at the toast's `Top` or `Bottom` edge (`statusBar.position`) with thickness `statusBar.height`, colored from `ColorHelper.getIntentColors(theme, intent, "default", statusBar.intents)`.
- The bar's width is driven by a linear tween from `1` to `0` over `duration` seconds, visually depleting as the auto-dismiss timer counts down.
- If `duration` is `math.huge` or `<= 0`, the bar's tween goal is never set, so it stays full-width instead of depleting (there is no timeout for it to track).
- Without a configured `statusBar`, no bar renders, but the auto-dismiss timer still runs independently.

## Theme

Toast defaults live under `theme.components.toast`:

- `width` — the container's default width.
- `fadeDuration` — duration of the show/hide `GroupTransparency` tween; `0` makes dismissal instantaneous.
- `position` — a `PositionElementProps` used to place `ToastContainer` on screen.
- `intents` — per-intent background/border/text colors for the default toast surface and (separately) for the status bar via `statusBar.intents`.
- `header.typography` — typography for the title text.
- `body.typography` — declared in the theme shape but not currently read by `Toast`; the description text always uses the default body typography regardless of this value. Treat this as a known dead field rather than intentionally-unthemeable text.
- `statusBar?.position`, `statusBar?.height`, `statusBar?.intents` — see above; omitting `statusBar` disables the progress indicator.
- The status bar's rounded corners reuse `theme.components.box.cornerRadius` rather than a toast-specific radius.

## Animation

- Fade in is implicit (the canvasgroup starts at `groupTransparency = 0`); fade out tweens to `1` over `fadeDuration` with `quadOut` easing.
- The status bar's depletion uses a `linear` tween over `duration`.
- Both animations use the shared `useTween` utility; a `0` duration disables the corresponding effect.

## Story

A story should demonstrate: showing multiple toasts in quick succession to show stacking order, a persistent toast (`duration: math.huge`) later updated via `update()` to a finite duration, and the difference between a toast that dismisses itself (animated fade) versus `dismissAll()` (immediate removal).
