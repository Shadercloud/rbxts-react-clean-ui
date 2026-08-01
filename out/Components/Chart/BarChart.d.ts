import React from "@rbxts/react";
interface BarChartDataset {
    values: number[];
}
interface BarChartData {
    labels: string[];
    datasets: BarChartDataset[];
}
interface BarChartProps {
    data: BarChartData;
}
export declare function BarChart(props: BarChartProps): React.JSX.Element;
export {};
