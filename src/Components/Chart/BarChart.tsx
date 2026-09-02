import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext } from "../../Contexts";
import { SizeHelper, SpacingHelper } from "../../Helpers";
import { Container, HStack, VStack } from "../Layout";
import { Tooltip } from "../Interaction";
import { Text } from "../Typography";

export interface BarChartLineStyle {
    color?: Color3;
    transparency?: number;
    thickness?: number;
}

export interface BarChartAxis extends BarChartLineStyle {
    size?: number;
    spacing?: number;
    tickColor?: Color3;
    tickTransparency?: number;
    tickThickness?: number;
    tickSize?: number;
}

export interface BarChartXAxis extends BarChartAxis {
    gap?: number;
}

export interface BarChartGridLines extends BarChartLineStyle {
    values?: number[];
}

export interface BarChartYAxis extends BarChartAxis {
    ticks?: number;
    gridLines?: BarChartGridLines;
}

export interface BarChartTooltips {
    combined?: boolean;
}

export interface BarChartDataset {
    values: number[];
    labels?: string[];
    color?: Color3;
    colors?: Color3[];
}

export interface BarChartData {
    labels: string[];
    datasets: BarChartDataset[];
    colors?: Color3[];
    stacked?: boolean;
    unstackedTransparency?: number;
    tooltips?: BarChartTooltips;
    xAxis?: BarChartXAxis | false;
    yAxis?: BarChartYAxis | false;
}

export interface BarChartProps {
    data: BarChartData;
    name?: string;
}

function niceStep(max: number, targetTicks = 5): number {
    if (max <= 0 || targetTicks <= 0) return 0;
    const rawStep = max / targetTicks;
    const magnitude = math.pow(10, math.floor(math.log10(rawStep)));
    const residual = rawStep / magnitude;

    let niceResidual: number;
    if (residual <= 1) niceResidual = 1;
    else if (residual <= 2) niceResidual = 2;
    else if (residual <= 5) niceResidual = 5;
    else niceResidual = 10;

    return niceResidual * magnitude;
}

export function BarChart(props: BarChartProps) {
    const theme = React.useContext(CleanThemeContext);
    const barTheme = theme.components.charts.bar;
    const xAxis = props.data.xAxis === false ? undefined : props.data.xAxis;
    const yAxis = props.data.yAxis === false ? undefined : props.data.yAxis;
    const showXAxis = props.data.xAxis !== false;
    const showYAxis = props.data.yAxis !== false;
    const stacked = props.data.stacked !== false;
    const combinedTooltips = props.data.tooltips?.combined === true;

    const positiveSums = props.data.labels.map((_, index) =>
        props.data.datasets.reduce((sum, dataset) => sum + math.max(dataset.values[index] ?? 0, 0), 0),
    );
    const negativeSums = props.data.labels.map((_, index) =>
        props.data.datasets.reduce((sum, dataset) => sum + math.min(dataset.values[index] ?? 0, 0), 0),
    );
    const positiveExtents = stacked ? positiveSums : props.data.labels.map((_, index) =>
        props.data.datasets.reduce((currentMax, dataset) => math.max(currentMax, dataset.values[index] ?? 0), 0),
    );
    const negativeExtents = stacked ? negativeSums : props.data.labels.map((_, index) =>
        props.data.datasets.reduce((currentMin, dataset) => math.min(currentMin, dataset.values[index] ?? 0), 0),
    );
    const max = positiveExtents.reduce((currentMax, value) => math.max(currentMax, value), 0);
    const min = negativeExtents.reduce((currentMin, value) => math.min(currentMin, value), 0);
    const specifiedGridValues = yAxis?.gridLines?.values;
    const specifiedMax = specifiedGridValues?.reduce((currentMax, value) => math.max(currentMax, value), 0) ?? 0;
    const specifiedMin = specifiedGridValues?.reduce((currentMin, value) => math.min(currentMin, value), 0) ?? 0;
    const step = niceStep(max - min, yAxis?.ticks);
    const chartMax = math.max(step > 0 ? math.ceil(max / step) * step : max, specifiedMax);
    const chartMin = math.min(step > 0 ? math.floor(min / step) * step : min, specifiedMin);
    const chartRange = chartMax - chartMin;
    const gridValues: number[] = [];

    if (specifiedGridValues !== undefined) {
        specifiedGridValues.forEach(value => gridValues.push(value));
    } else if (step > 0) {
        for (let value = chartMin; value <= chartMax; value += step) gridValues.push(value);
    }

    const xAxisSize = showXAxis ? xAxis?.size ?? barTheme.xAxis.size : 0;
    const yAxisSize = showYAxis ? yAxis?.size ?? barTheme.yAxis.size : 0;
    const barSpacing = new UDim(0, xAxis?.gap ?? SpacingHelper.GetPadding(theme, undefined, barTheme.spacing));
    const xAxisSpacing = xAxis?.spacing ?? barTheme.xAxis.spacing;
    const yAxisSpacing = yAxis?.spacing ?? barTheme.yAxis.spacing;
    const unstackedTransparency = props.data.unstackedTransparency ?? barTheme.unstackedTransparency;
    const xLine = xAxis ?? {};
    const yLine = yAxis ?? {};
    const gridStyle = yAxis?.gridLines;

    const getLineColor = (style: BarChartLineStyle, fallback: BarChartLineStyle) =>
        style.color ?? fallback.color ?? barTheme.axis.color;
    const getLineTransparency = (style: BarChartLineStyle, fallback: BarChartLineStyle) =>
        style.transparency ?? fallback.transparency ?? barTheme.axis.transparency;
    const getLineThickness = (style: BarChartLineStyle, fallback: BarChartLineStyle) =>
        style.thickness ?? fallback.thickness ?? barTheme.axis.thickness;
    const getYPosition = (value: number) => (chartMax - value) / chartRange;
    const getBarColor = (dataset: BarChartDataset, datasetIndex: number, valueIndex: number) => {
        if (dataset.color !== undefined) return dataset.color;
        if (dataset.colors !== undefined && dataset.colors[valueIndex] !== undefined) return dataset.colors[valueIndex];
        if (props.data.colors !== undefined && props.data.colors.size() > 0) {
            return props.data.colors[datasetIndex % props.data.colors.size()];
        }
        return theme.components.charts.colors[datasetIndex % theme.components.charts.colors.size()];
    };
    const getCombinedTooltip = (index: number) => props.data.datasets.map(dataset => {
        const value = dataset.values[index] ?? 0;
        return `${dataset.labels?.[index] ?? props.data.labels[index]}: ${value}`;
    }).join("\n");
    const barCornerRadius = SizeHelper.toUDim(barTheme.cornerRadius);
    const [animationProgress, animationTween] = useTween(barTheme.tweenTime > 0 ? 0 : 1, {
        duration: barTheme.tweenTime,
        easing: "quadOut",
    });

    React.useEffect(() => {
        if (barTheme.tweenTime > 0) animationTween.setGoal(1);
    }, [animationTween, barTheme.tweenTime]);

    return <Container name={props.name ?? "BarChart"} Size={UDim2.fromScale(1, 1)}>
        <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill} spacing="None">
            {showYAxis && <Container name="YAxisContainer" Size={new UDim2(0, yAxisSize, 1, -xAxisSize)}>
                <frame
                    key="YAxisLine"
                    Size={new UDim2(0, getLineThickness(yLine, barTheme.axis), 1, 0)}
                    Position={new UDim2(1, -yAxisSpacing, 0, 0)}
                    AnchorPoint={new Vector2(1, 0)}
                    BorderSizePixel={0}
                    BackgroundColor3={getLineColor(yLine, barTheme.axis)}
                    BackgroundTransparency={getLineTransparency(yLine, barTheme.axis)}
                />
            </Container>}
            <Container name="PlotArea" Size={new UDim2(1, -yAxisSize, 1, 0)}>
                <VStack spacing="None">
                    <Container name="ChartArea" Size={new UDim2(1, 0, 1, -xAxisSize)}>
                        {showYAxis && chartRange > 0 && gridValues.map(value => <frame
                            key={`GridLine-${value}`}
                            Size={new UDim2(1, 0, 0, getLineThickness(gridStyle ?? {}, barTheme.gridLines))}
                            Position={new UDim2(0, 0, getYPosition(value), 0)}
                            BorderSizePixel={0}
                            BackgroundColor3={getLineColor(gridStyle ?? {}, barTheme.gridLines)}
                            BackgroundTransparency={getLineTransparency(gridStyle ?? {}, barTheme.gridLines)}
                        >
                            <frame
                                key="Tick"
                                Size={new UDim2(0, yAxis?.tickSize ?? barTheme.yAxis.tickSize, 0, yAxis?.tickThickness ?? barTheme.yAxis.tickThickness)}
                                Position={new UDim2(0, -yAxisSpacing, 0, 0)}
                                AnchorPoint={new Vector2(1, 0)}
                                BorderSizePixel={0}
                                BackgroundColor3={yAxis?.tickColor ?? barTheme.yAxis.tickColor}
                                BackgroundTransparency={yAxis?.tickTransparency ?? barTheme.yAxis.tickTransparency}
                            />
                            <Text name="GridLineLabel" text={`${value}`} TextWrap={false} AnchorPoint={new Vector2(1, 0.5)} Position={new UDim2(0, -15 - yAxisSpacing, 0, 0)} />
                        </frame>)}
                        {chartRange > 0 && <Container name="BarsContainer" Size={UDim2.fromScale(1, 1)}>
                            <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill} valign="Bottom" Padding={barSpacing}>
                                {props.data.labels.map((label, index) => <Container key={`BarGroup-${index}`} name={`BarGroup-${index}`} Size={UDim2.fromScale(0, 1)}>
                                    {stacked ? <Container name="StackedBar" Size={UDim2.fromScale(1, 1)}>
                                        {props.data.datasets.map((dataset, datasetIndex) => {
                                            const value = dataset.values[index] ?? 0;
                                            const tooltipLabel = dataset.labels?.[index] ?? label;
                                            const start = props.data.datasets.reduce((sum, previousDataset, previousIndex) => {
                                                if (previousIndex >= datasetIndex) return sum;
                                                const previousValue = previousDataset.values[index] ?? 0;
                                                return (value >= 0) === (previousValue >= 0) ? sum + previousValue : sum;
                                            }, 0);
                                            const segmentEnd = start + value;
                                            const top = math.max(start, segmentEnd);
                                            const isTopSegment = value > 0
                                                ? !props.data.datasets.some((otherDataset, otherIndex) =>
                                                    otherIndex > datasetIndex && (otherDataset.values[index] ?? 0) > 0,
                                                )
                                                : positiveSums[index] <= 0 && value < 0 && !props.data.datasets.some((otherDataset, otherIndex) =>
                                                    otherIndex < datasetIndex && (otherDataset.values[index] ?? 0) < 0,
                                                );
                                            const segment = <Container
                                                    key={`Segment-${datasetIndex}`}
                                                    name={`Segment-${datasetIndex}`}
                                                    Size={animationProgress.map(progress => UDim2.fromScale(1, math.abs(value) / chartRange * progress))}
                                                    Position={animationProgress.map(progress => UDim2.fromScale(0, getYPosition(top * progress)))}
                                                    BackgroundTransparency={0}
                                                    BackgroundColor3={getBarColor(dataset, datasetIndex, index)}
                                                >
                                                    <uistroke
                                                        key="Stroke"
                                                        Color={barTheme.borderColor}
                                                        Thickness={barTheme.borderThickness}
                                                        ApplyStrokeMode={Enum.ApplyStrokeMode.Border}
                                                    />
                                                    {isTopSegment && <uicorner
                                                        key="Corners"
                                                        TopLeftRadius={barCornerRadius}
                                                        TopRightRadius={barCornerRadius}
                                                        BottomLeftRadius={new UDim(0, 0)}
                                                        BottomRightRadius={new UDim(0, 0)}
                                                    />}
                                                </Container>;
                                            return combinedTooltips
                                                ? segment
                                                : <Tooltip content={`${tooltipLabel}: ${value}`} placement="Center">{segment}</Tooltip>;
                                        })}
                                        {combinedTooltips && <Tooltip content={getCombinedTooltip(index)} placement="Center">
                                            <Container
                                                name="CombinedTooltipTarget"
                                                Size={animationProgress.map(progress => UDim2.fromScale(
                                                    1,
                                                    (positiveExtents[index] - negativeExtents[index]) / chartRange * progress,
                                                ))}
                                                Position={animationProgress.map(progress => UDim2.fromScale(
                                                    0,
                                                    getYPosition(positiveExtents[index] * progress),
                                                ))}
                                                BackgroundTransparency={1}
                                            />
                                        </Tooltip>}
                                    </Container> : <Container name="UnstackedBar" Size={UDim2.fromScale(1, 1)}>
                                        {props.data.datasets.map((dataset, datasetIndex) => {
                                            const value = dataset.values[index] ?? 0;
                                            const tooltipLabel = dataset.labels?.[index] ?? label;
                                            const magnitude = math.abs(value);
                                            const hasLaterEqualValue = props.data.datasets.some((otherDataset, otherIndex) =>
                                                otherIndex > datasetIndex && (otherDataset.values[index] ?? 0) === value,
                                            );
                                            if (magnitude === 0 || hasLaterEqualValue) return undefined;

                                            const coveredMagnitude = props.data.datasets.reduce((covered, otherDataset) => {
                                                const otherValue = otherDataset.values[index] ?? 0;
                                                const otherMagnitude = math.abs(otherValue);
                                                const sameDirection = (value >= 0) === (otherValue >= 0);
                                                return sameDirection && otherMagnitude < magnitude
                                                    ? math.max(covered, otherMagnitude)
                                                    : covered;
                                            }, 0);
                                            const visibleMagnitude = magnitude - coveredMagnitude;
                                            const zIndex = props.data.datasets.filter(otherDataset =>
                                                math.abs(otherDataset.values[index] ?? 0) > magnitude,
                                            ).size();
                                            const top = value >= 0 ? value : -coveredMagnitude;
                                            const isTallest = !props.data.datasets.some(otherDataset => {
                                                const otherValue = otherDataset.values[index] ?? 0;
                                                return (value >= 0) === (otherValue >= 0) && math.abs(otherValue) > magnitude;
                                            });
                                            const visibleSection = <Container
                                                    key={`Segment-${datasetIndex}`}
                                                    name={`Segment-${datasetIndex}`}
                                                    Size={animationProgress.map(progress => UDim2.fromScale(1, visibleMagnitude / chartRange * progress))}
                                                    Position={animationProgress.map(progress => UDim2.fromScale(0, getYPosition(top * progress)))}
                                                    ZIndex={zIndex}
                                                    BackgroundTransparency={unstackedTransparency}
                                                    BackgroundColor3={getBarColor(dataset, datasetIndex, index)}
                                                >
                                                    <uistroke
                                                        key="Stroke"
                                                        Color={barTheme.borderColor}
                                                        Thickness={barTheme.borderThickness}
                                                        ApplyStrokeMode={Enum.ApplyStrokeMode.Border}
                                                    />
                                                    {isTallest && <uicorner
                                                        key="Corners"
                                                        TopLeftRadius={barCornerRadius}
                                                        TopRightRadius={barCornerRadius}
                                                        BottomLeftRadius={new UDim(0, 0)}
                                                        BottomRightRadius={new UDim(0, 0)}
                                                    />}
                                                </Container>;
                                            return combinedTooltips
                                                ? visibleSection
                                                : <Tooltip content={`${tooltipLabel}: ${value}`} placement="Center">{visibleSection}</Tooltip>;
                                        })}
                                        {combinedTooltips && <Tooltip content={getCombinedTooltip(index)} placement="Center">
                                            <Container
                                                name="CombinedTooltipTarget"
                                                Size={animationProgress.map(progress => UDim2.fromScale(
                                                    1,
                                                    (positiveExtents[index] - negativeExtents[index]) / chartRange * progress,
                                                ))}
                                                Position={animationProgress.map(progress => UDim2.fromScale(
                                                    0,
                                                    getYPosition(positiveExtents[index] * progress),
                                                ))}
                                                BackgroundTransparency={1}
                                            />
                                        </Tooltip>}
                                    </Container>}
                                </Container>)}
                            </HStack>
                        </Container>}
                    </Container>
                    {showXAxis && <Container name="XAxisContainer" Size={new UDim2(1, 0, 0, xAxisSize)}>
                        <frame
                            key="XAxisLine"
                            Size={new UDim2(1, 0, 0, getLineThickness(xLine, barTheme.axis))}
                            Position={new UDim2(0, 0, 0, xAxisSpacing)}
                            BorderSizePixel={0}
                            BackgroundColor3={getLineColor(xLine, barTheme.axis)}
                            BackgroundTransparency={getLineTransparency(xLine, barTheme.axis)}
                        />
                        <Container name="XAxisLabels" Size={UDim2.fromScale(1, 1)}>
                            <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill} Padding={barSpacing}>
                                {props.data.labels.map((label, index) => <Container key={`XAxisTick-${index}`} name={`XAxisTick-${index}`} Size={UDim2.fromScale(0, 1)}>
                                    <frame
                                        key="Tick"
                                        Size={new UDim2(0, xAxis?.tickThickness ?? barTheme.xAxis.tickThickness, 0, xAxis?.tickSize ?? barTheme.xAxis.tickSize)}
                                        Position={new UDim2(0.5, 0, 0, xAxisSpacing)}
                                        AnchorPoint={new Vector2(0.5, 0)}
                                        BorderSizePixel={0}
                                        BackgroundColor3={xAxis?.tickColor ?? barTheme.xAxis.tickColor}
                                        BackgroundTransparency={xAxis?.tickTransparency ?? barTheme.xAxis.tickTransparency}
                                    />
                                    <Container name="XAxisLabel" center>
                                        <Text name="XAxisLabelText" text={label} TextWrapped={false} />
                                    </Container>
                                </Container>)}
                            </HStack>
                        </Container>
                    </Container>}
                </VStack>
            </Container>
        </HStack>
    </Container>;
}
