import React from "@rbxts/react";
interface BarChartDataset {
    values: number[];
    labels?: string[];
}
interface BarChartData {
    labels: string[];
    datasets: BarChartDataset[];
    yAxis?: {
        ticks?: number;
    };
}
interface BarChartProps {
    data: BarChartData;
}
export declare function BarChart(props: BarChartProps): React.JSX.Element;
export {};
