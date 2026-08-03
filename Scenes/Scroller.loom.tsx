import React from "@rbxts/react";
import { Button } from "../src/Components/Input/Button";
import { Container } from "../src/Components/Layout/Container";
import { HStack } from "../src/Components/Layout/HStack";
import { Text } from "../src/Components/Typography/Text";
import { LoomScene } from "./LoomScene";
import { Scroller } from "../src/Components/Layout/Scroller";
import { Box } from "../src/Components/Surface/Box";
import { FlexItem } from "../src/Components/Layout/FlexItem";
import { VStack } from "../src/Components/Layout/VStack";

export const preview = {
    render: () => (
        <LoomScene>
            <Container
                width="75%"
                center="50%"
            >
                <Box>
                    <VStack>
                        <Container>
                            <HStack>
                                <FlexItem>
                                    <Text text="Enter Your Details" variant="title" />
                                </FlexItem>
                                <Button icon="times" />
                            </HStack>
                        </Container>
                        <Container height="200px">
                            <Scroller>
                                <Text text="Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." />
                            </Scroller>
                        </Container>
                        <Container>
                            <HStack valign="Bottom">
                                <FlexItem>
                                    <Button text="Information" intent="info" icon="info-circle" scale="xl" Event={{
                                        Activated: () => {
                                            print("Clicked Information")
                                        }
                                    }}></Button>
                                </FlexItem>
                                <Button text="Continue" intent="success" icon="arrow-circle-right"></Button>
                                <Button text="Save" intent="warning" icon="floppy"></Button>
                            </HStack>
                        </Container>
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),

    title: "Scroller",
} as const;
