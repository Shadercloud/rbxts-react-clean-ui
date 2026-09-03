# Select

`Select` is a dropdown that lets a user choose one of several `Select.Option` children. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `SelectProps` composes `ScalableElementProps`, `SpacedElementProps`, and `React.InstanceProps<ImageLabel>` (it renders through `Container`, so it accepts native `ImageLabel` properties, not `TextBox` properties), plus `selected?: number`, `'max-height'?: CssSize`, `backgroundImage?: CssBackgroundImage`, `backgroundGradient?: CssBackgroundGradient`, `onChange?: (selected: number, value?: string) => void`, `searchable?: boolean`, and `searchPlaceholder?: string` (defaults to `"Search"`).
- `Select.Option` accepts `text?: string`, `children?: React.ReactNode`, `Event?: React.InstanceEvent<ImageButton>`, and `BackgroundColor3?: Color3`. `index` and `value` are assigned/consumed internally; `index` must not be set by a consumer (`Select` assigns it based on child position).
- `Select.OptGroup` accepts `label: string` and `children?: React.ReactNode` (expected to be `Select.Option` elements). It renders nothing itself — like `Accordion.Item`/`Header`/`Content`, it's a structural marker that `Select` walks to build its own render tree — and only groups one level deep: a `Select.OptGroup` nested inside another `Select.OptGroup` is ignored, along with any non-`Select.Option` children of a group.
- `Select.Option` is recognized both as a direct child of `Select` and as a child of a `Select.OptGroup` that is itself a direct child of `Select`; an option nested any deeper (or inside any other element) does not receive a valid `index` and its `Select.Option` internals will assert (`"Select.Option must be a direct child of Select or Select.OptGroup"`). Index assignment is a single sequential counter across the whole `children` tree (ungrouped options and every group's options interleave in document order), so index order matches the order options are declared regardless of grouping.
- A `React.Fragment` (`<>...</>`) wrapping `Select.Option`/`Select.OptGroup` elements — anywhere in `Select`'s children, or inside a `Select.OptGroup`'s children — is transparently unwrapped/recursed into rather than treated as an opaque child; this lets a consumer conditionally compose an option/group list (e.g. a ternary returning different `<>...</>` fragments) without breaking indexing or triggering the "must be a direct child" assertion. A `Fragment` itself is not counted as a group, option, or passthrough node.
- `selected` only seeds the initial selected index (`React.useState(props.selected ?? 0)`); after mount, the component manages the selected index internally and does not resync to a later change of the `selected` prop.
- If there is no option at the current selected index and no option at index `0` either, the closed control displays `"No Options"`.

## Behavior

- Clicking the closed control, or an already-open dropdown's control, toggles the dropdown open/closed (`activateSelect`). Opening measures the control's `AbsoluteSize`/`AbsolutePosition` relative to the overlay to position the dropdown directly below the control.
- Selecting a `Select.Option` calls `context.setSelected(index, value)` — which calls `onChange(index, value)` and updates the selected index — then closes the dropdown.
- Per the [Input](./index.md) convention, activating a paired `Fieldset.Label` also calls `activateSelect`, toggling the dropdown.
- The dropdown is rendered via `ReactRoblox.createPortal` into `OverlayContext.overlay`. If the dropdown is opened while no overlay is available (`overlay.overlay === undefined`), the component `warn`s but still attempts to render nothing extra (the portal is skipped for that render).
- The dropdown's content height is tracked via the inner `VStack`'s `AbsoluteContentSize` (the option list only — the search row, when present, sits above it and isn't counted); the dropdown's rendered height is `math.min(contentHeight, resolvedMaxHeight)`, where `resolvedMaxHeight` comes from `'max-height'` if supplied (via `SizeHelper.toUDim(...).Offset`) or otherwise `theme.components.select.maxDropDownHeight`. The dropdown's option list is wrapped in a `Scroller`, so content taller than the max height scrolls; the search row (if present) stays fixed above the scrollable area.
- Each `Select.Option`'s background/text color reflects three states: `focus` when it is the currently selected option, `hover` when the pointer is over it, otherwise `default` — resolved via `ColorHelper.getIntentColors(theme, "primary", state, theme.components.select.intents)`. Intent is hardcoded to `"primary"`; `Select`/`Select.Option` do not expose an `intent` prop.
- An option can override its own base background via `BackgroundColor3`, but the component ultimately still recomputes the state-driven `BackgroundColor3` from the theme on the rendered `imagebutton`, so a caller-supplied `BackgroundColor3` on `Select.Option` is accepted as a prop but not actually applied to the rendered background (the option's declared `BackgroundColor3` prop is otherwise unused in the render).

### Search (`searchable`)

- When `searchable` is `true`, a search row renders above the option list inside the open dropdown, built from an `Input` with `icon="search"` (`controlled`, so its displayed text always tracks the query state) inset by `theme.components.select.search.spacing`/`padding`. The search box otherwise looks and themes exactly like any other `Input` — see [Input](./input.md) — there is no separate bottom-divider row. The search query resets to empty every time the dropdown closes, so reopening always starts unfiltered.
- Filtering matches an option's `text` against the query case-insensitively via a literal (non-pattern) substring search; an option with no `text` (a `children`-only option) always matches and is never filtered out. An empty query matches everything.
- A `Select.OptGroup` is hidden entirely if none of its options match the current query; an ungrouped `Select.Option` is hidden individually if it doesn't match. If the query is non-empty and nothing at all matches, the option list is replaced with a `"No Results"` message (styled with the same typography as the closed control's label) instead of an empty scroll area.
- Grouping and search compose: filtering narrows the options inside a visible group without otherwise changing group order or `Select.OptGroup` recognition rules above.

## Theme

`theme.components.select` supplies:

- `borderColor`, `borderThickness` (`Inner` stroke on the control, `Outer` stroke on the dropdown), `cornerRadius` for both the control and the dropdown.
- `dropDownBackgroundColor`.
- `typography`, resolved via `TypographyHelper.getTypography`.
- Optional `backgroundImage`, overridden per instance by the matching `SelectProps.backgroundImage`, renders directly on the root `Container` using the shared `CssBackgroundImage` shape and resolution behavior.
- Optional `backgroundGradient`, overridden per instance by the matching `SelectProps.backgroundGradient`, renders on the root `Container` using the shared `CssBackgroundGradient` shape and resolution behavior (see [Box](../surface/box.md#backgroundgradient)).
- `intents` for the `default`/`hover`/`focus` (selected) option colors.
- `maxDropDownHeight`, the fallback for `'max-height'`.
- `optGroup.textColor` (required) plus optional `typography`, `backgroundColor`, `backgroundTransparency` (defaults to `1`, i.e. invisible, when unset), `spacing`, and `padding` (the latter two resolved via `SpacingHelper.GetResolvedPadding`) for a `Select.OptGroup` header row.
- `search.spacing`/`padding` (resolved via `SpacingHelper.GetResolvedPadding`) — the outer margin around the search row's `Input` box within the dropdown. The search row's icon color, text typography, and placeholder typography now come from `theme.components.input` (via the `Input` it renders), not from `theme.components.select.search` — see [Input](./input.md).

## Story

Worth demonstrating: default (uncontrolled) selection, a controlled selection that reads back through `onChange`, options with custom `children` in addition to `text`, enough options to trigger the scrollable/max-height dropdown behavior, `searchable` filtering, and `Select.OptGroup` sectioning (including a mix of grouped and ungrouped options, and searching within groups). Requires wrapping the story in an `OverlayProvider` for the dropdown to render.
