# Pagination

`Pagination` renders a controlled page selector with a smart default layout and compound subparts for custom composition. It follows the shared conventions in [Components](../index.md) and [Layout](./index.md).

## Public API

- `Pagination` requires `page`, `totalPages`, and `onPageChange`, accepts `siblingCount?: number` (default `1`), and optionally accepts `children`.
- It exposes `Pagination.Prev`, `Pagination.Next`, `Pagination.Item`, `Pagination.Ellipsis`, and `Pagination.List`.
- `Pagination.Item` requires `value: number`, accepts the shared padding props, and accepts an optional `layoutOrder?: number` forwarded to the underlying button's `LayoutOrder`.
- `Pagination.List` optionally accepts explicit children. `Prev` and `Next` accept no props. `Ellipsis` accepts an optional `layoutOrder?: number`, forwarded the same way.

## Composition

- The root computes the visible page window once and shares the controlled page, normalized page count, computed items, navigation bounds, and clamped page-change function through context.
- With no root children, the component renders `Prev`, `List`, and `Next` in that order. When children are supplied, they fully replace this default composition while retaining context access.
- With no explicit children, `Pagination.List` renders the computed page items, assigning each one's `layoutOrder` from its index in the computed window (rather than its page value or key), so items entering/leaving the window as the page changes stay in the correct left-to-right visual order regardless of Roblox instance creation/parenting order. With children, it renders those children unchanged.
- Compound subparts must be descendants of a `Pagination` root.

## Page window and interaction

- The visible window always includes the first and last pages, includes up to `siblingCount` pages on either side of the current page, and represents each omitted contiguous range with one ellipsis.
- When every page fits within the boundary-and-sibling window (`totalPages <= siblingCount * 2 + 5`), every page is rendered without ellipses.
- Once windowing is active, the total rendered item count (numbered items plus ellipses) is constant at exactly `siblingCount * 2 + 5` regardless of the current page, so the rendered bar's width never changes as the user navigates. Near the start or end of the range, where only one ellipsis is needed, the run of consecutive numbers on that side extends to make up the difference instead of shrinking the total count; the middle case (both ellipses shown) is unaffected.
- `totalPages` and `siblingCount` are floored and cannot be negative. The effective page and emitted changes are clamped to the valid range. A non-positive page count renders no numbered items and disables both navigation controls.
- Items use the focus state when selected. Activating an item emits its value. Prev and Next emit the adjacent page and are non-interactive at their bounds.

## Layout and theme

- The root is an auto-sized themed `Container` with an inner border, corner radius, and padding, and nothing else — it imposes no layout of its own, so a custom `children` tree fully controls its own layout (direction, spacing, alignment) rather than being nested inside a layout the root provides.
- The default (no-children) composition provides its own non-wrapping horizontal layout wrapping `Prev`, `List`, and `Next`. `Pagination.List` creates a separate auto-sized container for its own non-wrapping horizontal layout.
- Defaults live under `theme.components.pagination`: root background, border, corner radius, spacing, and padding style the outer control; `item` supplies border thickness, corner radius, padding, typography, shadow, and primary intent colors (including a `disabled` variant) shared by page and navigation buttons.
- Controls use `HoverButton`; default, hover, selected/focus, and disabled visuals resolve through `ColorHelper`. Prev/Next use the disabled variant when at their respective bounds. Navigation chevrons render inside `Container` wrappers.

## Animation

- Page and hover-state changes are instantaneous.
