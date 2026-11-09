import React from "@rbxts/react";
import { Boolean, Choose } from "@rbxts/ui-labs";
import { Card, Container, createStory, HStack, Intent, Text, VStack } from "@rbxts/react-clean-ui";
import ToolTipInteractive from "./ToolTipInteractive";

export = createStory((props) => (
    <Container center>
        <Card>
            <Card.Header>
                <HStack valign="Center">
                    <Text text="Interactive Tooltips" variant="heading" />
                </HStack>
            </Card.Header>
            <Card.Body>
                <VStack>
                    <Text text="Interactive popups stay open while the pointer is over them and close after the theme closeDelay." />
                    <Text text="Open the nested popup, then hover the covered triggers under it: they stay closed while an interactive popup is on top." />
                    <ToolTipInteractive
                        intent={props.controls.Intent as Intent}
                        pinOnPress={props.controls.PinOnPress}
                    />
                </VStack>
            </Card.Body>
        </Card>
    </Container>
), {
    Intent: Choose(["primary", "success", "info", "warning", "danger"]),
    PinOnPress: Boolean(false),
});
