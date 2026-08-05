# Charts

This specification defines behavior and conventions shared by chart components. Component-specific behavior belongs in the corresponding chart specification.

## Layout

- Chart components fill their parent container with `UDim2.fromScale(1, 1)` unless their component specification defines a different sizing model.
- Consumers are responsible for providing a parent with a usable width and height.

## Theming

- Styling shared by multiple chart types belongs under `theme.components.charts`.
- Styling used by only one chart type belongs under `theme.components.charts.<chart>`.
- Styling supplied through component data or props takes precedence over theme defaults.
- `theme.components.charts.colors` is the fallback series palette for chart data without an explicit color.
- Every complete theme provides exactly 10 palette colors that are distinct, suitable for data visualization, and consistent with that theme.
- A chart may repeat the palette by series index when it renders more series than the palette contains.

## Interfaces

- Interfaces shared by multiple chart components belong in `/src/Interfaces/charts.ts` and are exported through the interfaces index.
- Interfaces specific to one chart remain in that component's source file and are exported when they form part of its public API.
- Chart configuration should use Roblox-native values such as `Color3` and `UDim2` where applicable.

## Data and interaction

- Explicit data colors override the shared theme palette.
- Missing optional configuration uses theme or component defaults without requiring consumers to construct a complete configuration object.
- Chart-specific specifications define supported value ranges, empty-data behavior, labels, selection, and pointer interaction.
