import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Container, createStory, Card, Text } from "@rbxts/react-clean-ui";
import PieChart from "./PieChart";

export = createStory((props) => (
    <Container center>
        <Card>
            <Card.Header>
                <Text text="Pie Chart Example" variant="heading" />
            </Card.Header>
            <Card.Body>
                <PieChart labelHover={props.controls.LabelHover} />
            </Card.Body>
        </Card>
    </Container>
), {
    LabelHover: Boolean(false),
});
