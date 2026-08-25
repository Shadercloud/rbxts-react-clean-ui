# Select

`Select` is a dropdown that lets a user choose one of several `Select.Option` children. It follows the shared conventions in [Components](../index.md) and [Input](./index.md).

## Public API

- `SelectProps` composes `ScalableElementProps`, `SpacedElementProps`, and `React.InstanceProps<Frame>` (it renders through `Container`, so it accepts native `Frame` properties, not `TextBox` properties), plus `selected?: number`, `'max-height'?: CssSize`, and `onChange?: (selected: number, value?: string) => void`.
- `Select.Option` accepts `text?: string`, `children?: React.ReactNode`, `Event?: React.InstanceEvent<ImageButton>`, and `BackgroundColor3?: Color3`. `index` and `value` are assigned/consumed internally; `index` must not be set by a consumer (`Select` assigns it based on child position).
- Only direct `Select.Option` children are recognized — `Select` assigns each child's `index` by iterating `props.children` directly, so options nested inside another element do not receive a valid `index` and their `Select.Option` internals will assert.
- `selected` only seeds the initial selected index (`React.useState(props.selected ?? 0)`); after mount, the component manages the selected index internally and does not resync to a later change of the `selected` prop.
- If there is no option at the current selected index and no option at index `0` either, the closed control displays `"No Options"`.

## Behavior

- Clicking the closed control, or an already-open dropdown's control, toggles the dropdown open/closed (`activateSelect`). Opening measures the control's `AbsoluteSize`/`AbsolutePosition` relative to the overlay to position the dropdown directly below the control.
- Selecting a `Select.Option` calls `context.setSelected(index, value)` — which calls `onChange(index, value)` and updates the selected index — then closes the dropdown.
- Per the [Input](./index.md) convention, activating a paired `Fieldset.Label` also calls `activateSelect`, toggling the dropdown.
- The dropdown is rendered via `ReactRoblox.createPortal` into `OverlayContext.overlay`. If the dropdown is opened while no overlay is available (`overlay.overlay === undefined`), the component `warn`s but still attempts to render nothing extra (the portal is skipped for that render).
- The dropdown's content height is tracked via the inner `VStack`'s `AbsoluteContentSize`; the dropdown's rendered height is `math.min(contentHeight, resolvedMaxHeight)`, where `resolvedMaxHeight` comes from `'max-height'` if supplied (via `SizeHelper.toUDim(...).Offset`) or otherwise `theme.components.select.maxDropDownHeight`. The dropdown is wrapped in a `Scroller`, so content taller than the max height scrolls.
- Each `Select.Option`'s background/text color reflects three states: `focus` when it is the currently selected option, `hover` when the pointer is over it, otherwise `default` — resolved via `ColorHelper.getIntentColors(theme, "primary", state, theme.components.select.intents)`. Intent is hardcoded to `"primary"`; `Select`/`Select.Option` do not expose an `intent` prop.
- An option can override its own base background via `BackgroundColor3`, but the component ultimately still recomputes the state-driven `BackgroundColor3` from the theme on the rendered `imagebutton`, so a caller-supplied `BackgroundColor3` on `Select.Option` is accepted as a prop but not actually applied to the rendered background (the option's declared `BackgroundColor3` prop is otherwise unused in the render).

## Theme

`theme.components.select` supplies:

- `borderColor`, `borderThickness` (`Inner` stroke on the control, `Outer` stroke on the dropdown), `cornerRadius` for both the control and the dropdown.
- `dropDownBackgroundColor`.
- `typography`, resolved via `TypographyHelper.getTypography`.
- `intents` for the `default`/`hover`/`focus` (selected) option colors.
- `maxDropDownHeight`, the fallback for `'max-height'`.

## Story

Worth demonstrating: default (uncontrolled) selection, a controlled selection that reads back through `onChange`, options with custom `children` in addition to `text`, and enough options to trigger the scrollable/max-height dropdown behavior. Requires wrapping the story in an `OverlayProvider` for the dropdown to render.
