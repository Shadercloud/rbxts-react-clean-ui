import React from "@rbxts/react";
import { EnumList } from "@rbxts/ui-labs";
import { Box, Container, createStory, ScaleSize } from "@rbxts/react-clean-ui";
import Grid from "./Grid";

export = createStory(
    (props) => (
        <Container center width="85%">
            <Box>
                <Grid gap={props.controls.Gap} />
            </Box>
        </Container>
    ),
    {
        Gap: EnumList<ScaleSize>(
            {
                XS: "xs",
                SM: "sm",
                MD: "md",
                LG: "lg",
                XL: "xl",
            },
            "SM",
        ),
    },
);
