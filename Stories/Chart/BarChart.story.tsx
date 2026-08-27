import React from "@rbxts/react";
import { Boolean, Choose } from "@rbxts/ui-labs";
import { createStory, Card, Text, Container } from "@rbxts/react-clean-ui";
import BarChart from "./BarChart";

export = createStory((props) => (
    <Container center>
        <Card>
            <Card.Header>
                <Text text="Bar Chart Example" variant="heading" />
            </Card.Header>
            <Card.Body>
                <BarChart
                    stacked={props.controls.Stacked}
                    combinedTooltips={props.controls.CombinedTooltips}
                    colors={props.controls.Colors as "Default" | "Custom" | "Unique"}
                />
            </Card.Body>
        </Card>
    </Container>
), {
    Stacked: Boolean(true),
    CombinedTooltips: Boolean(false),
    Colors: Choose(["Default", "Custom", "Unique"]),
});
