import React from "@rbxts/react";
import { Container, BarChart as BarChartComponent, BarChartDataset } from "@rbxts/react-clean-ui";

type BarChartColorMode = "Default" | "Custom" | "Unique";

interface BarChartProps {
    stacked?: boolean;
    combinedTooltips?: boolean;
    colors?: BarChartColorMode;
}

function BarChart(props: BarChartProps = {}) {
    const stacked = props.stacked ?? true;
    const combinedTooltips = props.combinedTooltips ?? false;
    const colorMode = props.colors ?? "Default";

    const datasets: BarChartDataset[] = [
        {
            values: [7, 1, 4, 5],
            colors: colorMode === "Unique" ? [0, 1, 2, 3].map(() => Color3.fromHSV(math.random(), 0.65, 0.85)) : undefined,
        },
        {
            values: [1, 3, 2, 1],
            colors: colorMode === "Unique" ? [0, 1, 2, 3].map(() => Color3.fromHSV(math.random(), 0.65, 0.85)) : undefined,
        },
    ];

    return <Container
        width={500}
        height={300}
        BackgroundColor3={new Color3(1, 1, 1)}
        BackgroundTransparency={0}
        BorderSizePixel={0}
        ClipsDescendants={true}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <BarChartComponent data={
            {
                labels: ["some really long label", "B", "something else", "D"],
                yAxis: {
                    ticks: 5,
                },
                stacked,
                tooltips: {
                    combined: combinedTooltips,
                },
                colors: colorMode === "Custom"
                    ? [Color3.fromHex("#7A9E7E"), Color3.fromHex("#C97A4A")]
                    : undefined,
                datasets,
            }
        } />
    </Container>;
}

export = BarChart;
