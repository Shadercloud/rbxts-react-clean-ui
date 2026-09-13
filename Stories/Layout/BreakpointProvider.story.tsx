import React from "@rbxts/react";
import { Number, Slider } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import BreakpointProvider from "./BreakpointProvider";

export = createStory(
    (props) => (
        <Container center AutomaticSize="XY">
            <BreakpointProvider width={props.controls.Width} height={props.controls.Height} />
        </Container>
    ),
    {
        Width: Slider(390, 280, 1280, 1),
        Height: Number(844, 300, 1000, 1),
    },
);
