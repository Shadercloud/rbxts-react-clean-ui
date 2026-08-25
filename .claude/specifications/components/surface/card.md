# Card

`Card` groups related content behind a bordered `Box` surface, with optional `Header`, `Body`, and `Footer` sub-parts that share a common `intent`. It follows the shared conventions in [Components](../index.md).

## Public API

- `CardProps extends BoxProps, IntentElementProps`. `Card` forwards a ref to the underlying `Frame`.
- Sub-parts: `Card.Header` (`CardHeaderProps extends IntentElementProps`, `children`), `Card.Body` (`CardBodyProps extends BoxProps`), `Card.Footer` (`CardFooterProps extends IntentElementProps, BoxProps`). None of these sub-part prop interfaces are exported.
- `Card.Header`/`Card.Footer`/`Card.Body` are ordinary composed children — `Card` does not walk `children` looking for specific marker types; a consumer places them directly as JSX children and they render in place (unlike `Accordion`'s item-extraction pattern).

## Intent inheritance

- `Card` provides a `CardContext` (`{ intent?: Intent }`) to its subtree with its own `intent` prop.
- `Card.Header` and `Card.Footer` each resolve their intent as `props.intent ?? card.intent ?? "primary"` — an `intent` set directly on the header/footer overrides the card-level intent for that section only.
- `Card.Body` has no intent concept; it renders plain padded content.
- The outer `Box`'s border color always comes from the *header's* resolved intent (`ColorHelper.getIntentColors(theme, props.intent ?? "primary", "default", theme.components.card.header.intents)`), even when the card has no `Card.Header` child — there is no separate top-level card border color.

## Composition

- `Card` always renders a `Box` with `spacing="None"` and `center={undefined}` forced (any `center` prop passed to `Card` is not applied to the inner `Box`), wrapping a `VStack` (`spacing="None"`) of `children`.
- `center={true}` on `Card` (only when `Position`/`AnchorPoint` are not also supplied) instead wraps the `Box` in an outer full-size `Container` with a horizontally/vertically centering `uilistlayout` — centering is implemented at the wrapper level, not by `Box` itself.
- `Card.Header` renders a `Container` with background/border from its resolved intent, padding from `theme.components.card.header.spacing`, and only its top corners rounded (`theme.components.card.cornerRadius`).
- `Card.Footer` mirrors `Card.Header` but rounds only its bottom corners and uses `theme.components.card.footer.spacing`/`footer.intents`.
- `Card.Body` wraps its content in a `FlexItem` so it grows to fill remaining vertical space in the card, with padding from `theme.components.card.header.spacing` (there is no distinct `body.spacing` theme field — the body reuses the header's spacing value).
- `Card.Header` and `Card.Footer` both hard-code their border stroke `Thickness` to `1`, ignoring `theme.components.card.borderThickness` — that theme field is declared but not read by either sub-part.

## Theme

Card defaults live under `theme.components.card`:

- `cornerRadius` — corner radius applied to the header's top corners and the footer's bottom corners.
- `borderThickness` — declared but unused (see above); header/footer borders are always `1` pixel thick.
- `header.spacing` / `header.intents` — header (and, incidentally, body) padding, and per-intent header colors.
- `footer.spacing` / `footer.intents` — footer padding and per-intent footer colors.

## Story

A story should demonstrate a card with header, body, and footer using the card-level `intent`, plus a header (or footer) whose own `intent` overrides the card-level one.
