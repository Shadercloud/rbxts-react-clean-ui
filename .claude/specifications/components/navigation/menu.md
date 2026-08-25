# Menu

`Menu` is a collapsible vertical navigation list with icon-based items. It uses a compound-component API (`Menu.Item`) and follows the shared conventions in [Components](../index.md).

## Public API

- `MenuProps`: `title: string` (required), `collapsed?: boolean` (default `false`), `children`.
- `collapsed` only seeds the component's internal state at mount — `Menu` is uncontrolled with respect to collapse. There is no `onCollapsedChange` (or equivalent) callback, so a consumer cannot observe or drive the collapsed state from outside; the only way to toggle it is the header's built-in button.
- `Menu` forwards a ref to its outer `Frame`.
- `Menu.Item` (`MenuItemProps extends ButtonProps`) additionally requires `title: string`. Only `title`, `icon`, and `Event` from `MenuItemProps` currently affect rendering — see below.

## Collapse behavior

- Each `Menu` instance owns an independent `collapsed` boolean, provided to its subtree through `NavigationContext`. Multiple `Menu`s on screen do not share or coordinate collapse state.
- Clicking the header's `bars`-icon button toggles `collapsed`.
- While expanded: the menu `title` and every item's `title` are visible.
- While collapsed: the menu `title` is omitted and each item's `title` is passed as `undefined` to its underlying `Button`, hiding the label while the item's `icon` remains visible. Because the title is omitted rather than truncated, an item with no `icon` becomes unidentifiable while collapsed.

## Composition

- `Menu.Item` renders a `Button` with `text={collapsed ? undefined : props.title}`, `icon={props.icon}`, `Event={props.Event}`, and `group` always set to `true`.
- Although `MenuItemProps` extends `ButtonProps` (and the public `.mdx` documentation describes `intent` and "all other Button props" as supported), the implementation only forwards `title`, `icon`, and `Event` to the underlying `Button` — other `ButtonProps` fields (e.g. `intent`) accepted by the type are silently dropped rather than applied. Treat this as the current behavior when writing specs/tests/stories against it, and flag it as a likely bug rather than intentional restriction.
- The whole menu is wrapped in a `Group` (shared sizing scope) so the header button and every item `Button` (all passing `group`) size to the widest visible label; collapsing shrinks the shared width down to the icon-only controls.
- Layout: a `VStack` (`sm` spacing) containing the header row (`bars` button + conditional title `Text`, `variant="heading"`) and a `FlexItem mode="Fill"` wrapping a `Scroller` (`height="100%"`) that contains a `VStack` (`sm` spacing, `HorizontalFlex={Enum.UIFlexAlignment.None}`) rendering `children` directly.
- `Menu` has no dedicated `theme.components.menu` entry. All visual styling is inherited from the composed `Button`, `Text`, `Group`, and `Scroller` components and their own theme values.

## Story

A story should demonstrate: toggling collapse and observing the shared `Group` width shrink to icon-only controls, and a menu with more items than its container height (scrolling within the fixed-height parent while the header stays pinned).
