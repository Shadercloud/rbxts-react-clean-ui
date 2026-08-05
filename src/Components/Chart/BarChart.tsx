import React from "@rbxts/react";
import { Container, HStack, VStack } from "../Layout";
import { CleanThemeContext } from "../../Contexts";
import { Tooltip } from "../Interaction";
import { Text } from "../Typography";

interface BarChartDataset {
    values: number[];
    labels?: string[];
}


interface BarChartData {
    labels: string[];
    datasets: BarChartDataset[];
    yAxis?: {
        ticks?: number,
    }
}

interface BarChartProps {
    data: BarChartData;
}

function niceStep(max: number, targetTicks = 5): number {
    if (targetTicks <= 0) return 0;
    const rawStep = max / targetTicks;

    const magnitude = math.pow(10, math.floor(math.log10(rawStep)));
    const residual = rawStep / magnitude;

    let niceResidual: number;

    if (residual <= 1) {
        niceResidual = 1;
    } else if (residual <= 2) {
        niceResidual = 2;
    } else if (residual <= 5) {
        niceResidual = 5;
    } else {
        niceResidual = 10;
    }

    return niceResidual * magnitude;
}

export function BarChart(props: BarChartProps) {
    const theme = React.useContext(CleanThemeContext);

    const sumValues = props.data.labels.map((_, index) =>
        props.data.datasets.reduce(
            (sum, dataset) => sum + (dataset.values[index] ?? 0),
            0,
        ),
    );
    const max = sumValues.reduce((max, value) => math.max(max, value), 0);

    const step = niceStep(max, props.data.yAxis?.ticks);
    const chartMax = step > 0 ? math.ceil(max / step) * step : max;
    const gridValues: number[] = [];
    if (step > 0) {
        for (let value = 0; value <= chartMax; value += step) {
            gridValues.push(value);
        }
    }

    const labelHeight = 50;
    const xLabelWidth = 50;
    const axisLineSpace = 5;
    const axisTickThickness = 2;
    const barSpacing = new UDim(0, 8);
    const tickSize = 10;

    return <Container Size={UDim2.fromScale(1, 1)}>
        <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill} spacing="None">
            <Container Size={new UDim2(0, xLabelWidth, 1, -labelHeight)}>
                <frame Size={new UDim2(0, theme.components.charts.bar.axis.thickness, 1, 0)}
                    Position={new UDim2(1, -axisLineSpace, 0, 0)}
                    AnchorPoint={new Vector2(1, 0)}
                    BorderSizePixel={0}
                    BackgroundColor3={theme.components.charts.bar.axis.color}
                    BackgroundTransparency={theme.components.charts.bar.axis.transparency}
                />
            </Container>
            <Container Size={new UDim2(1, -xLabelWidth, 1, 0)}>
                <VStack spacing="None">
                    <Container Size={new UDim2(1, 0, 1, -labelHeight)}>
                        {gridValues.map((g, gi) => {
                            return <frame
                                Size={new UDim2(1, axisLineSpace, 0, 2)}
                                Position={new UDim2(1, 0, 1 - (g / chartMax), 0)}
                                AnchorPoint={new Vector2(1, 0)}
                                BorderSizePixel={0}
                                BackgroundColor3={theme.components.charts.bar.axis.color}
                                BackgroundTransparency={0.8}
                            >
                                <frame Size={new UDim2(0, tickSize, 1, 0)}
                                    BorderSizePixel={0}
                                    BackgroundColor3={theme.components.charts.bar.axis.color}
                                    BackgroundTransparency={theme.components.charts.bar.axis.transparency}
                                    Position={UDim2.fromScale(0, 0)}
                                    AnchorPoint={new Vector2(1, 0)}
                                />
                                <Text text={`${g}`} TextWrap={false} AnchorPoint={new Vector2(1, 0.5)} Position={new UDim2(0, -15, 0, 0)} />
                            </frame>
                        })}
                        <Container Size={UDim2.fromScale(1, 1)}>
                            <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill}
                                valign="Bottom"
                                Padding={barSpacing}
                            >
                                {props.data.labels.map((label, index) => {
                                    const values = props.data.datasets.map(dataset => dataset.values[index] ?? 0);
                                    // const total = values.reduce((sum, value) => sum + value, 0);

                                    return (
                                        <Container Size={UDim2.fromScale(0, 1)}>
                                            <VStack VerticalFlex={Enum.UIFlexAlignment.None} valign="Bottom" spacing="None">
                                                {values.map((value, datasetIndex) => (
                                                    <Tooltip content={`${label}: ${value}`} placement="Center">
                                                        <Container
                                                            LayoutOrder={1000 - datasetIndex}
                                                            Size={UDim2.fromScale(1, value / chartMax)}
                                                            BackgroundTransparency={0}
                                                            BackgroundColor3={theme.components.charts.colors[datasetIndex % theme.components.charts.colors.size()]}
                                                        />
                                                    </Tooltip>
                                                ))}
                                            </VStack>
                                        </Container>
                                    );
                                })}
                            </HStack>
                        </Container>
                    </Container>
                    <Container Size={new UDim2(1, 0, 0, labelHeight)}>
                        <uipadding PaddingTop={new UDim(0, axisLineSpace)} />
                        <frame Size={new UDim2(1, 0, 0, theme.components.charts.bar.axis.thickness)}
                            BorderSizePixel={0}
                            BackgroundColor3={theme.components.charts.bar.axis.color}
                            BackgroundTransparency={theme.components.charts.bar.axis.transparency}
                        />
                        <Container Size={UDim2.fromScale(1, 1)}>
                            <HStack
                                HorizontalFlex={Enum.UIFlexAlignment.Fill}
                                Padding={barSpacing}
                            >
                                {props.data.labels.map((label, index) => {
                                    return <Container Size={UDim2.fromScale(0, 1)}>
                                        {index === 0 &&
                                            <frame
                                                Position={UDim2.fromOffset(0, axisTickThickness)}
                                                Size={UDim2.fromOffset(axisTickThickness, tickSize)}
                                                BorderSizePixel={0}
                                                BackgroundColor3={theme.components.charts.bar.axis.color}
                                                BackgroundTransparency={theme.components.charts.bar.axis.transparency}
                                            />}
                                        <frame Size={UDim2.fromOffset(axisTickThickness, tickSize)}
                                            Position={
                                                index >= label.size() + 1 ?
                                                    new UDim2(1, 0, 0, axisTickThickness) :
                                                    new UDim2(1, math.ceil((barSpacing.Offset / 2) + (axisTickThickness / 2)), 0, axisTickThickness)
                                            }
                                            AnchorPoint={new Vector2(1, 0)}
                                            BorderSizePixel={0}
                                            BackgroundColor3={theme.components.charts.bar.axis.color}
                                            BackgroundTransparency={theme.components.charts.bar.axis.transparency}
                                        />
                                        <Container center>
                                            <Text text={label} TextWrapped={false} />
                                        </Container>
                                    </Container>
                                })}
                            </HStack>
                        </Container>
                    </Container>
                </VStack >
            </Container >
        </HStack >
    </Container >
}