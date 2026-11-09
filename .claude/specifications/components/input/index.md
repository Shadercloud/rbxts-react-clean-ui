# Input

This specification defines behavior shared by components in `src/Components/Input/`. Component-specific behavior belongs in the corresponding spec file. These components also follow the general conventions in [Components](../index.md).

## Fieldset label activation

- `Checkbox`, `Input`, `Select`, and `Switch` each read the `FieldsetContext` exported by `src/Components/Layout/Fieldset.tsx` (via `../Layout`) and, when present, subscribe to its `labelActivated` `BindableEvent`.
- Activating a `Fieldset.Label` (clicking/tapping it) fires `labelActivated`, and each subscribed control responds as if it had been activated directly:
  - `Checkbox` toggles: it calls `onChange` with the opposite of its current value, and also flips its internal state when uncontrolled (see [Checkbox](./checkbox.md#public-api)).
  - `Input` captures keyboard focus on its underlying `TextBox`.
  - `Select` opens (or toggles) its dropdown as though its own button were activated.
  - `Switch` toggles the same way as `Checkbox` (ignored while `disabled`).
- `Button` and `Slider` do not participate in this convention; they ignore `FieldsetContext` entirely.
- This lets a single `Fieldset.Label` act as a click target for whichever control lives in the paired `Fieldset.Control`, without the control needing to know it's paired with a label.
