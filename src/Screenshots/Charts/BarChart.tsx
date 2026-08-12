import React from "@rbxts/react";
import { BarChart, Container } from "../../index";

function BarChartScreenshot() {
    return (
        <Container center width={600} height={350}>
            <BarChart
                data={{
                    labels: ["Alpha", "Beta", "Gamma", "Delta"],
                    datasets: [
                        { values: [7, 4, 6, 5] },
                        { values: [2, 3, 1, 2] },
                    ],
                }}
            />
        </Container>
    );
}

export = BarChartScreenshot;
