import React, { useState } from "@rbxts/react";
import { Container } from "../src/Components/Layout/Container";
import { LoomScene } from "./LoomScene";
import { Button } from "../src/Components/Input/Button";
import { Draggable, HStack, FlexItem, Fieldset } from "../src/Components/Layout";
import { Card, Icon } from "../src/Components/Surface";
import { Text } from "../src/Components/Typography";
import { Intent } from "../src/Interfaces";
import { Select } from "../src/Components/Input/Select"

function DragCard() {
    const [windowIntent, setWindowIntent] = useState<Intent>("primary")
    const [windowMinimized, setWindowMinimized] = useState<boolean>(false)

    return <>

        <Draggable
            retainPosition
            placeholder={false}
        >
            <Container
                width="300"
                center>

                <Card intent={windowIntent}>
                    <Draggable.Handle>
                        <Card.Header>
                            <HStack valign="Center">
                                <Text text="Draggable Window" variant="heading" LayoutOrder={1} />
                                <FlexItem align="Right" LayoutOrder={2}>
                                    <Button icon="window-minimize" scale="xs" intent={windowIntent} Event={{
                                        Activated: () => {
                                            setWindowMinimized(!windowMinimized);
                                        }
                                    }} />
                                </FlexItem>
                                <Icon icon="arrows" LayoutOrder={3} />
                            </HStack>
                        </Card.Header>
                    </Draggable.Handle>
                    <Card.Body Visible={!windowMinimized}>
                        <Fieldset >
                            <Fieldset.Label>
                                <Text text="Select Window Intent:" />
                            </Fieldset.Label>
                            <Fieldset.Control>
                                <Select onChange={(selected, value) => {
                                    setWindowIntent(value as Intent);
                                }}>
                                    <Select.Option text="Primary" value="primary" />
                                    <Select.Option text="Success" value="success" />
                                    <Select.Option text="Info" value="info" />
                                    <Select.Option text="Warning" value="warning" />
                                    <Select.Option text="Danger" value="danger" />
                                </Select>
                            </Fieldset.Control>
                        </Fieldset>
                    </Card.Body>
                    <Card.Footer>
                        <Button text="Click Me" intent={windowIntent} />
                    </Card.Footer>
                </Card>
            </Container>

        </Draggable>
    </>
}

export const preview = {
    render: () => (
        <LoomScene>
            <DragCard />
        </LoomScene >
    ),

    title: "Card",
} as const;
