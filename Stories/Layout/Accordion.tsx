import React from "@rbxts/react";
import { Accordion as AccordionComponent, Box, Container, HStack, Icon, Text } from "@rbxts/react-clean-ui";

interface AccordionProps {
    collapsible?: boolean;
    animationDuration?: number;
}

function Accordion(props: AccordionProps = {}) {
    return <Container center>
        <Box>
            <Container width={400} height={320}>
                <AccordionComponent defaultValue="sections" collapsible={props.collapsible} animationDuration={props.animationDuration}>
                    <AccordionComponent.Item value="sections">
                        <AccordionComponent.Header text="How many sections can be open at once?" />
                        <AccordionComponent.Content text="Only one section opens at a time. Toggle the Collapsible control above to allow closing the open section entirely, leaving none expanded." />
                    </AccordionComponent.Item>
                    <AccordionComponent.Item value="custom-header">
                        <AccordionComponent.Header>
                            <HStack valign="Center">
                                <Icon icon="info-circle" />
                                <Text text="Can I put my own components in the header?" />
                            </HStack>
                        </AccordionComponent.Header>
                        <AccordionComponent.Content text="Yes, pass any component as children to Accordion.Header instead of the text and icon props, such as the Text and Icon used to build this header." />
                    </AccordionComponent.Item>
                    <AccordionComponent.Item value="content">
                        <AccordionComponent.Header text="What kind of content can a section hold?" />
                        <AccordionComponent.Content>
                            <Text text="Anything. Accordion.Content accepts arbitrary React children and resizes itself automatically to fit them, whether that's plain text or a composite layout like the row below." />
                            <HStack valign="Center">
                                <Icon icon="check" />
                                <Text text="Icons, buttons, or other components all work here." />
                            </HStack>
                        </AccordionComponent.Content>
                    </AccordionComponent.Item>
                    <AccordionComponent.Item value="disabled" disabled>
                        <AccordionComponent.Header text="Why is this section disabled?" />
                        <AccordionComponent.Content text="Disabled items cannot be expanded, regardless of their content." />
                    </AccordionComponent.Item>
                </AccordionComponent>
            </Container>
        </Box></Container>;
}

export = Accordion;
