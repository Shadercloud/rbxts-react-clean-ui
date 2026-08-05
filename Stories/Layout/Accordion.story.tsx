import React from "@rbxts/react";
import { Boolean } from "@rbxts/ui-labs";
import { Accordion, Box, Container, createStory, Text } from "@rbxts/react-clean-ui";

export = createStory((props) => {
    return (
        <Container width="75%" height="320" center>
            <Box>
                <Accordion defaultValue="overview" collapsible={props.controls.Collapsible} animationDuration={props.controls.Animation ? undefined : 0}>
                    <Accordion.Item value="overview">
                        <Accordion.Header><Text text="Overview" /></Accordion.Header>
                        <Accordion.Content><Text text="A short introduction to the accordion component." /></Accordion.Content>
                    </Accordion.Item>
                    <Accordion.Item value="details">
                        <Accordion.Header icon="info-circle"><Text text="Details" /></Accordion.Header>
                        <Accordion.Content><Text text="This section is deliberately taller. Accordion content can contain any React children and sizes itself automatically to fit them." /></Accordion.Content>
                    </Accordion.Item>
                    <Accordion.Item value="disabled" disabled>
                        <Accordion.Header><Text text="Unavailable section" /></Accordion.Header>
                        <Accordion.Content><Text text="This content cannot be opened." /></Accordion.Content>
                    </Accordion.Item>
                </Accordion>
            </Box>
        </Container>
    );
}, {
    Collapsible: Boolean(false),
    Animation: Boolean(true),
});
