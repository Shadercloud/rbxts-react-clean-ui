import React from "@rbxts/react";
import { Container, createStory, Box, Button, Tooltip, Text, VStack, HStack, Icon } from "@rbxts/react-clean-ui";

function TooltipDemo() {

    return <Container
        center>
        <Box>
            <VStack>
                <Tooltip
                    content="Tooltip text goes here"
                    intent="primary"
                    spacing="md"
                    placement="Top"
                >
                    <Button text="Tooltip Above" />

                </Tooltip>
                <Tooltip
                    content="Tooltip text goes here"
                    intent="success"
                    spacing="md"
                    placement="Bottom"
                >
                    <Button intent="success" text="Tooltip Below (success intent)" />

                </Tooltip>
                <Tooltip
                    content={
                        <Container>
                            <VStack spacing="None">
                                <Container>
                                    <HStack>
                                        <Icon icon="hand-peace-o" />
                                        <Text text="With an Icon!" variant="heading" />
                                    </HStack>
                                </Container>
                                <Text text="Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. " />

                            </VStack>
                        </Container>
                    }
                    intent="warning"
                    spacing="md"
                    placement="Right"
                >
                    <Button intent="primary" text="Tooltip to Right (warning intent / custom content)" />

                </Tooltip>
                <Tooltip content="Hello World" placement="Left">
                    <Text text="Testing" />
                </Tooltip>
            </VStack>
        </Box>

    </Container >
}
export = createStory(TooltipDemo);