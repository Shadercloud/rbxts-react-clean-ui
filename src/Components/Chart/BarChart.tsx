import React, { useState } from "@rbxts/react";
import { Container, HStack } from "../Layout";
import { CleanThemeContext } from "../../Contexts";
import { Tooltip } from "../Interaction";

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

export function BarChart(props: BarChartProps) {
    const theme = React.useContext(CleanThemeContext);

    return <Container Size={UDim2.fromScale(1, 1)}>
        <HStack HorizontalFlex={Enum.UIFlexAlignment.Fill} valign="Bottom" >
            {props.data.datasets.map((dataset) => {
                const max = dataset.values.reduce((max, value) => math.max(max, value));
                const total = dataset.values.reduce((sum, value) => sum + value, 0);
                return dataset.values.map((value, index) => {
                    return (
                        <Tooltip
                            content={`${props.data.labels[index] ?? ""}: ${value}`}
                            placement="Center"
                        >
                            <Container
                                BackgroundTransparency={0}
                                Size={UDim2.fromScale(0, value / max)}
                                BackgroundColor3={theme.components.charts.colors[index % theme.components.charts.colors.size()]}
                            />
                        </Tooltip>
                    );
                })
            })
            }
        </HStack>
    </Container>
}