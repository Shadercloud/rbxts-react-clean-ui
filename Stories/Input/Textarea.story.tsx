import React from "@rbxts/react";
import { Boolean, Number } from "@rbxts/ui-labs";
import { Box, Container, createStory } from "@rbxts/react-clean-ui";
import Textarea from "./Textarea";

export = createStory((props) => (
    <Container center>
        <Box>
            <Textarea
                rows={props.controls.Rows}
                height={props.controls.Height}
                maxLength={props.controls.MaxLength}
                disabled={props.controls.Disabled}
            />
        </Box>
    </Container>
), {
    Rows: Number(2, 1, 10, 1),
    Height: Number(120, 48, 400, 1),
    MaxLength: Number(1500, 10, 5000, 10),
    Disabled: Boolean(false),
});
