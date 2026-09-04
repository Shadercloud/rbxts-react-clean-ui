import React from "@rbxts/react";
import { Boolean, EnumList, Number, Slider, String } from "@rbxts/ui-labs";
import { Box, Container, createStory, Intent, ScaleSize } from "@rbxts/react-clean-ui";
import ProgressBar from "./ProgressBar";

export = createStory(
    (props) => (
        <Container center>
            <Box>
                <ProgressBar
                    value={props.controls.Value}
                    max={props.controls.Max}
                    intent={props.controls.Intent}
                    scale={props.controls.Scale}
                    label={props.controls.Label}
                    showValue={props.controls.ShowValue}
                    striped={props.controls.Striped}
                    stripeDuration={props.controls.StripeDuration}
                    stripeDirection={props.controls.StripeDirection}
                />
            </Box>
        </Container>
    ),
    {
        Value: Slider(60, 0, 100, 1),
        Max: Number(100, 1, 500, 1),
        Intent: EnumList<Intent>(
            {
                Primary: "primary",
                Success: "success",
                Warning: "warning",
                Danger: "danger",
                Info: "info",
            },
            "Primary",
        ),
        Scale: EnumList<ScaleSize>(
            {
                XS: "xs",
                SM: "sm",
                MD: "md",
                LG: "lg",
                XL: "xl",
            },
            "MD",
        ),
        Label: String("Uploading"),
        ShowValue: Boolean(true),
        Striped: Boolean(false),
        StripeDuration: Number(0.75, 0.2, 2, 0.05),
        StripeDirection: EnumList<number>(
            {
                LeftToRight: 1,
                RightToLeft: -1,
            },
            "LeftToRight",
        ),
    },
);
