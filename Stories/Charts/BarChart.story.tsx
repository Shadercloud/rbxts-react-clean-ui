import React from "@rbxts/react";
import { Pie, Container, createStory, Card, Text, Button, Box, BarChart } from "@rbxts/react-clean-ui";

export = createStory((props) => (

    <Container center width="80%" height="90%">
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
                        datasets: [
                            { values: [7, 1, 4, 5] },
                            { values: [1, 3, 2, 1] }
                        ]
                    }
                } />
            </Card.Body>
        </Card>
    </Container>
));