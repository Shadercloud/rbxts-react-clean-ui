import React from "@rbxts/react";
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
}
export declare function BarChart(props: BarChartProps): React.JSX.Element;
