import React from "@rbxts/react";
import { Boolean, Choose } from "@rbxts/ui-labs";
import { Container, createStory, Card, Text, BarChart } from "@rbxts/react-clean-ui";

const uniqueFirstDatasetColors = [0, 1, 2, 3].map(() => Color3.fromHSV(math.random(), 0.65, 0.85));
const uniqueSecondDatasetColors = [0, 1, 2, 3].map(() => Color3.fromHSV(math.random(), 0.65, 0.85));

export = createStory((props) => {
    const colorMode = props.controls.Colors;
    const datasets = [
        {
            values: [7, 1, 4, 5],
            colors: colorMode === "Unique" ? uniqueFirstDatasetColors : undefined,
        },
        {
            values: [1, 3, 2, 1],
            colors: colorMode === "Unique" ? uniqueSecondDatasetColors : undefined,
        },
    ];

    return <Container center width="80%" height="90%">
        <Card>
            <Card.Header>
                <Text text="Bar Chart Example" variant="heading" />
            </Card.Header>
            <Card.Body width="100%" height="100%">
                <BarChart data={
                    {
                        labels: ["some really long label", "B", "something else", "D"],
                        yAxis: {
                            ticks: 5,
                        },
                        stacked: props.controls.Stacked,
                        tooltips: {
                            combined: props.controls.CombinedTooltips,
                        },
                        colors: colorMode === "Custom"
                            ? [Color3.fromHex("#7A9E7E"), Color3.fromHex("#C97A4A")]
                            : undefined,
                        datasets,
                    }
                } />
            </Card.Body>
        </Card>
    </Container>;
}, {
    Stacked: Boolean(true),
    CombinedTooltips: Boolean(false),
    Colors: Choose(["Default", "Custom", "Unique"]),
});
