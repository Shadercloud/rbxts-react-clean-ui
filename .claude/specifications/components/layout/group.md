# Group

`Group` lets multiple sibling elements measure their own natural size and agree on a single shared dimension so they can render at a uniform size (for example, matching widths). It is plumbing consumed by other components — [`Container`](./container.md)'s `group` prop, and `Button` (Input category)'s `group` prop — rather than something an end user renders directly for its own sake. It follows the shared conventions in [Components](../index.md).

## Public API

- `Group` accepts only `children` and provides `GroupContext` to its subtree.
- `Group.Element` is the sub-part that opts a piece of content into being measured and reported to the enclosing `Group`. It accepts `enabled`, an optional `padding` (`ResolvedPadding`) to add to the measured size before reporting it, and `children`.

## Behavior

- Each mounted, enabled `Group.Element` renders its children inside an invisible (`BackgroundTransparency={1}`), content-hugging (`AutomaticSize.XY`) frame, and reports that frame's `AbsoluteSize` — plus its `padding`, if given — to the nearest ancestor `GroupContext` under a unique id.
- `Group` tracks every reporting element's last-reported size and exposes the componentwise maximum (`max(X)`, `max(Y)` across all current members) as `context.size`.
- An element that becomes disabled, or unmounts, removes its entry from the map, and `size` is recalculated from the remaining members.
- `Group.Element` is a no-op passthrough (renders `children` directly, without wrapping or reporting) when `enabled` is falsy or there is no ancestor `GroupContext`.
- There is no separate "consumer" sub-part — a component that wants to use the shared size (like `Container`'s `group` prop) reads `size`/`sizes` from `GroupContext` directly itself.

## Theme

Not themeable.
