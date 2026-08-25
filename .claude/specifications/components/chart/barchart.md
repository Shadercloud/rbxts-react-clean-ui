# Bar Chart

`BarChart` compares categories using vertical stacked bars. It follows the shared requirements in [Charts](./index.md) and the general conventions in [Components](../index.md).

## Public API

- The component accepts one required `data: BarChartData` prop.
- `BarChartData` contains required `labels` and `datasets` arrays and optional `xAxis` and `yAxis` configuration.
- Bar-chart-specific interfaces remain in `BarChart.tsx` and are exported as part of the component API.

## Categories and datasets

- Each entry in `data.labels` creates one category and one vertical bar.
- The value at a dataset index corresponds to the category label at the same index.
- Multiple datasets are rendered as stacked segments within each category.
- A missing dataset value is treated as `0`.
- The yAxis origin defaults to `0` unless there are negative values, then it will be calculate the chart minimum.
- `BarChartDataset.color` overrides the shared chart palette for every segment in that dataset.
- Without a dataset color, the dataset uses `theme.components.charts.colors[datasetIndex % colors.size()]`.
- `BarChartData.colors` should accept an array of `Color3` which would override the default theme palette.
- Spacing between bars should be configurable via the theme using the `spacing` system used elsewhere.  It should also allow a specific `gap: number` value that would override spacing to be passed via the `data.xAxis` prop.

### Stacking

- `datasets` are stacked ontop of each other by default.  Datasets can be unstacked using a `data.stacked === false` prop.
- In unstacked configuration the bars will be sorted in a Z-Index order such that the tallest bars are behind and shorter bars are in front.
- Unstacked configuration the bars will have a default transparency of `0.5`, this should be configurable within the theme and props.
- When unstacked the bars should not actually overlap eachother, just have the appearance and values that they are occupying the same space.  Such that the Tooltip should only apply to the visible sections of each bar.
- In the case where `unstacked` bars are the exact same value then only 1 bar would be visible.

## Labels and tooltips

- `data.labels` supplies the labels displayed along the x-axis.
- Hovering a bar segment displays a centered tooltip in the form `<label>: <value>`.
- `BarChartDataset.labels[index]`, when present, replaces `data.labels[index]` in that dataset segment's tooltip.
- Dataset tooltip labels do not replace the x-axis category labels.
- Tooltips can be set as separate (the default) or combined such that values from the bars with the same dataset index are placed within the same tooltip. `data.tooltips.combined` will be a boolean value (with `false` as default)

## Axes

- Both axes are enabled by default.
- Setting `data.xAxis` or `data.yAxis` to `false` hides that axis and releases the layout space reserved for it.
- `BarChartAxis.size` controls the pixel space reserved for an axis and its labels.
- Axis line configuration supports `color`, `transparency`, and `thickness`.
- Tick configuration supports `tickColor`, `tickTransparency`, `tickThickness`, and `tickSize`.
- Values supplied in `data.xAxis` or `data.yAxis` override the corresponding theme defaults.
- X-axis labels and ticks are distributed evenly across the category slots.
- Both axes should allow a configurable spacing between the axis line and the chart.

## Y-axis scale and grid lines

- The chart maximum is based on the largest sum of non-negative dataset values for any category.
- `yAxis.ticks` is the target number of automatically calculated intervals and defaults to `5`.
- Automatic intervals use a readable step from the sequence `1`, `2`, `5`, or `10`, scaled to the appropriate power of ten.
- The calculated maximum is rounded upward to a whole interval so every stacked bar fits within the plot.
- `yAxis.ticks <= 0` disables automatic grid-line generation.
- `yAxis.gridLines.values` replaces automatic grid positions with exact numeric values.
- When explicit grid values exceed the data maximum, the largest explicit value expands the chart maximum.
- Grid-line styling supports `color`, `transparency`, and `thickness`.
- Y-axis ticks and numeric labels are rendered at the same positions as grid lines.
- Grid lines and their y-axis labels are not rendered when the y-axis is disabled.

## Theme

Bar-chart defaults live under `theme.components.charts.bar`:

- `axis.color`, `axis.transparency`, and `axis.thickness` style both axis lines.
- `xAxis.size`, `xAxis.tickColor`, `xAxis.tickTransparency`, `xAxis.tickThickness`, and `xAxis.tickSize` configure x-axis layout and ticks.
- `yAxis.size`, `yAxis.tickColor`, `yAxis.tickTransparency`, `yAxis.tickThickness`, and `yAxis.tickSize` configure y-axis layout and ticks.
- `gridLines.color`, `gridLines.transparency`, and `gridLines.thickness` style y-axis grid lines.
- Bar borders color should be theme configurable.
- The top left and top right corner radius on the tallest or top most bars should be configurable via the theme.  Use the `<uicorner>` component with the `TopLeftRadius` and `TopRightRadius` props such that only the top left and right corners are rounded.
- In `unstacked` mode only the tallest bar would have a corner radius.
- The border color and thickness for the bars should be configurable via the theme.

The precedence order is component data configuration, the relevant bar-chart theme setting, and then the shared bar axis setting where an axis-line fallback is required.

## Animation

- Utilized @rbxts/ripple and useTween to create an onload animation such that bars will grow into position.
- Tween time should be configurable in the theme, if set to 0 then tweening is disabled.

## Layout and rendering

- The chart fills its parent according to the shared chart layout specification.
- Axis sizes reduce the available plotting area rather than changing the component's outer size.
- Bars are distributed evenly across category slots with fixed horizontal padding.
- Each segment height is its value divided by the chart maximum.

## Story

The story demo should have:
- `Stacked` toggle checkbox to demonstrate the stacked/unstacked data format.
- A select drop down to demo:
    - Default Colors pulled from theme
    - An array of custom colors overriding theme palette
    - A unique specific random color assigned to each value in the dataset.
- A toggle check to demonstrate tooltip being separate or combined.
- Do not demonstrate negative values in the `Story` or `Loom` files.